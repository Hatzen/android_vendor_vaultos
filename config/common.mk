#
# SPDX-FileCopyrightText: 2026 VaultOs
# SPDX-License-Identifier: Apache-2.0
#

# VaultOs System Properties
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.vaultos.version=23.2-alpha \
    ro.vaultos.airgap=true \
    ro.setupwizard.ignore_sim_locale=true

# Native Bootanimation
TARGET_BOOTANIMATION_ZIP := vendor/vaultos/media/bootanimation.zip

# Runtime Resource Overlays (RRO)
PRODUCT_PACKAGES += \
    FrameworkResVaultOs \
    SystemUIResVaultOs \
    SettingsProviderResVaultOs

# Security Configurations, Init Services & Component Overrides
PRODUCT_COPY_FILES += \
    vendor/vaultos/configs/component-override.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/component-override.xml \
    vendor/vaultos/configs/privapp-permissions-vaultos.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-vaultos.xml \
    vendor/vaultos/configs/default-permissions-kiwix.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions-kiwix.xml \
    vendor/vaultos/configs/init.vaultos.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.vaultos.rc \
    vendor/vaultos/configs/copy_assets.sh:$(TARGET_COPY_OUT_VENDOR)/bin/copy_assets.sh \
    vendor/vaultos/prebuilts/anonymousplanet.org_en_all_2026-05.zim:$(TARGET_COPY_OUT_PRODUCT)/media/kiwix/anonymousplanet.org_en_all_2026-05.zim

# Bundled Offline Apps & Tools
include vendor/vaultos/apps/apps.mk

# Soong Namespaces
PRODUCT_SOONG_NAMESPACES += \
    hardware/qcom-caf/wlan \
    hardware/qcom-caf/wlan/qcwcn

