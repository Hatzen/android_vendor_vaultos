#
# SPDX-FileCopyrightText: 2026 VaultOs
# SPDX-License-Identifier: Apache-2.0
#

# Default to true if not specified
WITH_KSU ?= true

# VaultOs Bundled Offline Applications & System Services
# Note: FancyLauncher (KISS) is deactivated in favor of stock Launcher3 / Concept 010 monochrome launcher.
PRODUCT_PACKAGES += \
    Alibi \
    Backup \
    Briar \
    CustomOtterControl \
    eSpeak \
    Files \
    LinuxWiki \
    LLM \
    Maps \
    Office \
    Parannoying \
    SkyMap \
    Stepsy \
    Terminal \
    VLC \
    Wiki

# Root & Kernel Management Packages (Toggleable via WITH_KSU)
ifeq ($(WITH_KSU),true)
PRODUCT_PACKAGES += \
    Kernel \
    KernelSU
endif

