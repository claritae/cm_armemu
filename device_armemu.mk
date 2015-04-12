$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product-if-exists, vendor/generic/armemu/armemu-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/generic/armemu/overlay

# Build Kernel
TARGET_KERNEL_SOURCE := kernel/armemu
TARGET_KERNEL_CONFIG := goldfish_armv7_defconfig
BOARD_KERNEL_IMAGE_NAME := uImage
BOARD_USES_UBOOT := true

LOCAL_PATH := out/target/product/armemu/obj/KERNEL_OBJ/arch/arm/boot
ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := $(LOCAL_PATH)/$(BOARD_KERNEL_IMAGE_NAME)
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

# Convert kernel image to uImage
KERNEL_EXTERNAL_MODULES:
	echo "Build external kernel modules here."

TARGET_KERNEL_MODULES := KERNEL_EXTERNAL_MODULES

# Build U-Boot
PRODUCT_OUT ?= out/target/product/armemu
TARGET_U_BOOT_SOURCE := u-boot
TARGET_U_BOOT_CONFIG := goldfish_config

include $(TARGET_U_BOOT_SOURCE)/AndroidU-Boot.mk

LOCAL_U_BOOT := $(TARGET_PREBUILT_U-BOOT)

# define U-Boot images
# TARGET_KERNEL_UIMAGE := $(PRODUCT_OUT)/zImage.uimg
TARGET_RAMDISK_UIMAGE := $(PRODUCT_OUT)/ramdisk.uimg
TARGET_RECOVERY_UIMAGE := $(PRODUCT_OUT)/ramdisk-recovery.uimg

# define build targets for kernel, U-Boot and U-Boot images
.PHONY: $(TARGET_PREBUILT_KERNEL) $(TARGET_PREBUILT_U-BOOT) $(TARGET_RAMDISK_UIMAGE) $(TARGET_RECOVERY_UIMAGE)

# $(TARGET_KERNEL_UIMAGE): $(TARGET_PREBUILT_KERNEL)
#	mkimage -A arm -C none -O linux -T kernel -d $(TARGET_PREBUILT_INT_KERNEL) -a 0x00010000 -e 0x00010000 $(TARGET_KERNEL_UIMAGE)

$(TARGET_RAMDISK_UIMAGE): $(INSTALLED_RAMDISK_TARGET)
	mkimage -A arm -C none -O linux -T ramdisk -d $(PRODUCT_OUT)/ramdisk.img -a 0x00800000 -e 0x00800000 $(TARGET_RAMDISK_UIMAGE)

$(TARGET_RECOVERY_UIMAGE): $(PRODUCT_OUT)/ramdisk-recovery.img
	mkimage -A arm -C none -O linux -T ramdisk -d $(PRODUCT_OUT)/ramdisk-recovery.img -a 0x00800000 -e 0x00800000 $(TARGET_RECOVERY_UIMAGE)

# LOCAL_KERNEL_UIMAGE := $(TARGET_KERNEL_UIMAGE)
LOCAL_RAMDISK_UIMAGE := $(TARGET_RAMDISK_UIMAGE)
LOCAL_RECOVERY_UIMAGE := $(TARGET_RECOVERY_UIMAGE)


PRODUCT_COPY_FILES += \
     $(LOCAL_U_BOOT):u-boot.bin \
     $(LOCAL_KERNEL):kernel \
     $(LOCAL_KERNEL):system/zImage.uimg \
     $(LOCAL_RAMDISK_UIMAGE):system/ramdisk.uimg \
#     $(LOCAL_RECOVERY_UIMAGE):system/ramdisk-recovery.uimg \
     device/generic/armemu/init.recovery.armemu.rc:root/init.recovery.armemu.rc \
     device/generic/armemu/init.recovery.armemu.sh:root/init.recovery.armemu.sh

$(call inherit-product, build/target/product/full.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_armemu
PRODUCT_DEVICE := armemu
