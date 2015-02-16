## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := armemu

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/generic/armemu/device_armemu.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := armemu
PRODUCT_NAME := cm_armemu
PRODUCT_BRAND := generic
PRODUCT_MODEL := armemu
PRODUCT_MANUFACTURER := generic
