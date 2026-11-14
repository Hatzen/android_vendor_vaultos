# VaultOs Release, Signing, and Update Architecture Concept

## 1. Executive Summary & Vision
VaultOs is designed as an ultra-secure, privacy-first, air-gapped mobile operating system based on Android 16 / LineageOS 23.2 for the SHIFTphone 8 (`otter`).
This document outlines the architecture for:
- Sovereign release distribution and hosting.
- Separation of official production signed builds vs community builds.
- Cryptographic verification and tamper-proofing.
- In-OS system updates, emergency bootloader toggles, and flashing utilities.

---

## 2. Release & Secret Key Architecture

### 2.1 The Two-Tier Build Model
To maintain transparency and allow open-source verification while guaranteeing official integrity:

1. **Official Release Builds (Signed by VaultOs Private Keys)**:
   - Built exclusively in a secure, isolated CI/CD or air-gapped build machine.
   - Signed with private cryptographic keys (`releasekey`, `platform`, `shared`, `media`, `networkstack`, and custom `AVB` / Android Verified Boot keys).
   - Private keys are stored strictly in an encrypted, offline/private repository (`vaultos-secrets` / HSM), never committed to public git.
   - Target devices running official builds have the custom AVB root of trust locked into the hardware Keystore (`avb_custom_key`). This guarantees that any malicious payload or ISP injection will cause the bootloader to reject booting.

2. **Community / Developer Builds**:
   - The public repositories (`android_vendor_vaultos`, `android_device_shift_otter`, `android_kernel_shift_qcm6490`) allow any developer or researcher to compile `user` or `userdebug` builds with standard AOSP/Lineage test-keys.
   - Fully reproducible, allowing external auditing of all source modifications.

### 2.2 Key Generation Protocol (Official Private Keys)
Official keys should be generated using AOSP `development/tools/make_key`:
```bash
# Generate 4096-bit RSA keys for Android Verified Boot and APK signing
development/tools/make_key releasekey '/CN=VaultOs ReleaseKey/'
development/tools/make_key platform '/CN=VaultOs Platform/'
development/tools/make_key shared '/CN=VaultOs Shared/'
development/tools/make_key media '/CN=VaultOs Media/'
development/tools/make_key networkstack '/CN=VaultOs NetworkStack/'
```
And generate AVB custom key:
```bash
openssl genrsa -out avb.pem 4096
avbtool extract_public_key --key avb.pem --output avb_pk.bin
```

---

## 3. ROM Distribution & Server Hosting Strategy

### Phase 1: GitHub Releases (Immediate Launch)
- **Platform**: `Hatzen/VaultOs` GitHub Releases.
- **Limit**: Max 2 GB per file (our bacon OTA zip is ~1.8 GB).
- **Security**: Direct HTTPS distribution backed by GitHub's enterprise CDN, with SHA-256 and Ed25519 signature files attached to each tag.

### Phase 2: Dedicated Sovereign Server (Production & OTA)
- **Infrastructure**: Dedicated Hetzner Cloud Server or Storage Box located in Nuremberg / Falkenstein, Germany.
- **Domain**: Official mirror (e.g., `releases.vaultos.org` / `update.vaultos.org`).
- **Web Server**: Caddy / NGINX with strict TLS 1.3, CSP headers, HSTS, and directory listing disabled.
- **OTA API Endpoint**: Serves a structured, cryptographically signed JSON manifest:
  ```json
  {
    "response": [
      {
        "datetime": 1731580800,
        "filename": "vaultos_otter-ota-v1.0.0.zip",
        "id": "v1.0.0",
        "romtype": "official",
        "size": 1932735283,
        "url": "https://releases.vaultos.org/otter/vaultos_otter-ota-v1.0.0.zip",
        "version": "1.0.0",
        "sha256": "ab3a323d0f5ce3718fd1e302070be1a22b775377f9ae166f172115cbb87fa574",
        "minisig": "RWQSbY...signature..."
      }
    ]
  }
  ```

---

## 4. Cryptographic Integrity & Anti-Tampering

Every published release must include:
1. `SHA256SUMS`: Checksums of `boot.img`, `vendor_boot.img`, `dtbo.img`, and `vaultos_otter-ota.zip`.
2. `SHA256SUMS.minisig` or `SHA256SUMS.sig`: Cryptographic Ed25519 signature generated with `minisign` or `signify`.

### Verification Command for Users:
```bash
# Using minisign with VaultOs hardcoded public key:
minisign -Vm SHA256SUMS -P <VAULTOS_PUBLIC_KEY>
sha256sum --check SHA256SUMS
```

---

## 5. Standalone Flashing Utility (Windows & Linux)

### Objectives
- Single-binary zero-dependency CLI/GUI installer.
- Eliminates manual driver, PATH, or fastboot syntax errors for end users.
- Embedded platform-tools (`adb` and `fastboot`).
- Enforces cryptographic verification before any flashing command is executed.

### Flash Sequence
1. **Device Handshake**: Verify connected device matches `otter` (`fastboot getvar product`).
2. **Security & Data Warnings**: Explicit prompts warning of data wipe and ISP tampering risks.
3. **Partition Flash**:
   ```bash
   fastboot flash boot boot.img
   fastboot flash vendor_boot vendor_boot.img
   fastboot flash dtbo dtbo.img
   ```
4. **Recovery Transition & Sideload**:
   ```bash
   fastboot reboot recovery
   adb sideload vaultos_otter-ota.zip
   ```

---

## 6. Custom Otter Control System & In-OS Updater Extension

The `CustomOtterControl` app inside VaultOs serves as the device's sovereign security control center:
1. **Fastboot / Recovery Shortcut & OEM Control**:
   - Directly triggers elevated system reboots into `bootloader` or `recovery` for easy flashing.
   - Provides clear visual alerts regarding risks: bootloader lock/unlock, carrier/ISP man-in-the-middle attacks, and backup requirements.
2. **In-OS Updater Integration**:
   - Queries the OTA JSON endpoint over HTTPS (or Tor onion mirror).
   - Verifies the cryptographic signature of incremental or full updates before passing to Android's `UpdateEngine`.
