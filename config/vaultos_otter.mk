#
# SPDX-FileCopyrightText: 2026 VaultOs
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from otter device hardware makefile
$(call inherit-product, device/shift/otter/device.mk)

# Inherit LineageOS base telephony & common phone config
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit VaultOs common configurations
$(call inherit-product, vendor/vaultos/config/common.mk)

# Boot animation dimensions
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Device identifier
PRODUCT_NAME := vaultos_otter
PRODUCT_DEVICE := otter
PRODUCT_BRAND := SHIFT
PRODUCT_MODEL := SHIFTphone 8
PRODUCT_MANUFACTURER := SHIFT
PRODUCT_GMS_CLIENTID_BASE := android-uniscope

# Ensure Lineage build flags & features are activated for otter
export LINEAGE_BUILD := otter


PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildFingerprint=SHIFT/otter/otter:14/SOS.6.7.20260712/20260712:user/release-keys \
    DeviceProduct=otter

