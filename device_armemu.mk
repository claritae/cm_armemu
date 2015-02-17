$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product-if-exists, vendor/generic/armemu/armemu-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/generic/armemu/overlay

LOCAL_PATH := device/generic/armemu
ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := $(LOCAL_PATH)/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

# Build U-Boot
PRODUCT_OUT ?= out/target/product/armemu
TARGET_U_BOOT_SOURCE := u-boot
TARGET_U_BOOT_CONFIG := goldfish_config

include $(TARGET_U_BOOT_SOURCE)/AndroidU-Boot.mk
$(PRODUCT_OUT)/u-boot.bin: $(TARGET_PREBUILT_U-BOOT)
	cp $(TARGET_PREBUILT_U-BOOT) $(PRODUCT_OUT)/u-boot.bin

LOCAL_U_BOOT := $(TARGET_PREBUILT_U-BOOT)

PRODUCT_COPY_FILES += \
     $(LOCAL_U_BOOT):u-boot.bin \
     $(LOCAL_KERNEL):kernel \
     device/generic/armemu/init.recovery.armemu.rc:root/init.recovery.armemu.rc \
     device/generic/armemu/init.recovery.armemu.sh:root/init.recovery.armemu.sh

$(call inherit-product, build/target/product/full.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_armemu
PRODUCT_DEVICE := armemu
