ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	export TARGET = iphone:clang:16.5:15.0
else
	export TARGET = iphone:clang:14.5:13.0
endif

export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CCMonoAudio
CCMonoAudio_BUNDLE_EXTENSION = bundle
CCMonoAudio_FILES = CCMonoAudio.m
CCMonoAudio_PRIVATE_FRAMEWORKS = ControlCenterUIKit
CCMonoAudio_INSTALL_PATH = /Library/ControlCenter/Bundles/

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/bundle.mk