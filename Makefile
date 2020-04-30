include $(THEOS)/makefiles/common.mk

export TARGET = iphone:clang:11.2:11.0
export ARCHS = arm64 arm64e

BUNDLE_NAME = CCMonoAudio
CCMonoAudio_BUNDLE_EXTENSION = bundle
CCMonoAudio_FILES = CCMonoAudio.m
CCMonoAudio_PRIVATE_FRAMEWORKS = ControlCenterUIKit
CCMonoAudio_INSTALL_PATH = /Library/ControlCenter/Bundles/

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/bundle.mk
