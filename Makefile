TARGET := iphone:clang:latest:13.4
INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AreYouSure

AreYouSure_FILES = Tweak.m
AreYouSure_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
