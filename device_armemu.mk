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

#$(PRODUCT_OUT)/u-boot.bin: $(TARGET_PREBUILT_U-BOOT)
#	cp $(TARGET_PREBUILT_U-BOOT) $(PRODUCT_OUT)/u-boot.bin

LOCAL_U_BOOT := $(TARGET_PREBUILT_U-BOOT)

# define U-Boot images
TARGET_KERNEL_UIMAGE := $(PRODUCT_OUT)/zImage.uimg
TARGET_RAMDISK_UIMAGE := $(PRODUCT_OUT)/ramdisk.uimg
TARGET_RECOVERY_UIMAGE := $(PRODUCT_OUT)/ramdisk-recovery.uimg

# define build targets for kernel, U-Boot and U-Boot images
.PHONY: $(TARGET_PREBUILT_KERNEL) $(TARGET_PREBUILT_U-BOOT) $(TARGET_KERNEL_UIMAGE) $(TARGET_RAMDISK_UIMAGE) $(TARGET_RECOVERY_UIMAGE)

$(TARGET_KERNEL_UIMAGE): $(TARGET_PREBUILT_KERNEL)
	mkimage -A arm -C none -O linux -T kernel -d $(TARGET_PREBUILT_INT_KERNEL) -a 0x00010000 -e 0x00010000 $(TARGET_KERNEL_UIMAGE)

$(TARGET_RAMDISK_UIMAGE): $(INSTALLED_RAMDISK_TARGET)
	mkimage -A arm -C none -O linux -T ramdisk -d $(PRODUCT_OUT)/ramdisk.img -a 0x00800000 -e 0x00800000 $(TARGET_RAMDISK_UIMAGE)

$(TARGET_RECOVERY_UIMAGE): $(PRODUCT_OUT)/ramdisk-recovery.img
	mkimage -A arm -C none -O linux -T ramdisk -d $(PRODUCT_OUT)/ramdisk-recovery.img -a 0x00800000 -e 0x00800000 $(TARGET_RECOVERY_UIMAGE)

LOCAL_KERNEL_UIMAGE := $(TARGET_KERNEL_UIMAGE)
LOCAL_RAMDISK_UIMAGE := $(TARGET_RAMDISK_UIMAGE)
LOCAL_RECOVERY_UIMAGE := $(TARGET_RECOVERY_UIMAGE)


PRODUCT_COPY_FILES += \
     $(LOCAL_U_BOOT):u-boot.bin \
     $(LOCAL_KERNEL):kernel \
     $(LOCAL_KERNEL_UIMAGE):system/zImage.uimg \
     $(LOCAL_RAMDISK_UIMAGE):system/ramdisk.uimg \
     $(LOCAL_RECOVERY_UIMAGE):system/ramdisk-recovery.uimg \
     device/generic/armemu/init.recovery.armemu.rc:root/init.recovery.armemu.rc \
     device/generic/armemu/init.recovery.armemu.sh:root/init.recovery.armemu.sh

$(call inherit-product, build/target/product/full.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_armemu
PRODUCT_DEVICE := armemu
