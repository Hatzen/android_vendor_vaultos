# VaultOs Vendor Tree (`vendor/vaultos`)

This repository contains the ROM-level customization layer for **VaultOs** on the SHIFTphone 8 (`otter`):
- Modern Runtime Resource Overlays (RRO) for `android`, `com.android.systemui`, and `com.android.providers.settings`
- OS makefiles and product definition (`vaultos_otter`)
- Security configurations, component overrides, and privileged permissions
- Offline system applications and system services (`CustomOtterControl`)
- Branding assets (`bootanimation.zip`, wallpapers, and true-black themes)

## Structure

```
vendor/vaultos/
├── AndroidProducts.mk
├── config/
│   ├── common.mk
│   └── vaultos_otter.mk
├── configs/
│   ├── component-override.xml
│   ├── default-permissions-kiwix.xml
│   └── privapp-permissions-vaultos.xml
├── media/
│   └── bootanimation.zip
├── overlay/
│   ├── FrameworkResVaultOs/
│   ├── SystemUIResVaultOs/
│   └── SettingsProviderResVaultOs/
├── apps/
│   ├── Android.bp
│   └── apps.mk
└── manifest/
    └── vaultos.xml
```

## AOSP / LineageOS Integration

This repository is synced to `vendor/vaultos` via `.repo/local_manifests/vaultos.xml`.
Build target:
```bash
lunch vaultos_otter-userdebug
mka bacon
```
