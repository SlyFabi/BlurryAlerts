INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = arm64 arm64e
target ?= iphone:13.0:13.0
GO_EASY_ON_ME=1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BlurryAlerts

BlurryAlerts_FILES = Tweak.xm
BlurryAlerts_CFLAGS = -fobjc-arc
BlurryAlerts_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += blurryalerts
include $(THEOS_MAKE_PATH)/aggregate.mk
