include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

BUNDLE_NAME = BlurryAlerts

BlurryAlerts_FILES = SFBlurryAlertsRootListController.m
BlurryAlerts_INSTALL_PATH = /Library/PreferenceBundles
BlurryAlerts_FRAMEWORKS = UIKit
BlurryAlerts_PRIVATE_FRAMEWORKS = Preferences
BlurryAlerts_CFLAGS = -fobjc-arc
BlurryAlerts_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BlurryAlerts.plist$(ECHO_END)
