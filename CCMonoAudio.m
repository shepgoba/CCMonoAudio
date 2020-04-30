#import "CCMonoAudio.h"
//extern long long monoAudioEnabled(void);
@interface UIImage (private)
+(id)systemImageNamed:(NSString *)name;
@end

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


static void setMonoAudioEnabled(int enabled) {
  	void *accessibilityHandle = dlopen("/usr/lib/libAccessibility.dylib", RTLD_LAZY);
	void (*fn_setMonoAudioEnabled)(int) = dlsym(accessibilityHandle, "_AXSMonoAudioSetEnabled");
	fn_setMonoAudioEnabled(enabled);
	dlclose(accessibilityHandle);
}

static long long getMonoAudioEnabled(void) {
	void *accessibilityHandle = dlopen("/usr/lib/libAccessibility.dylib", RTLD_LAZY);
	long long (*fn_getMonoAudioEnabled)(void) = dlsym(accessibilityHandle, "_AXSMonoAudioEnabled");
	long long monoAudioEnabled = fn_getMonoAudioEnabled();
	dlclose(accessibilityHandle);

	return monoAudioEnabled;
}

@implementation CCMonoAudio
-(id)init {
	if (self = [super init]) {
		if (getMonoAudioEnabled()) {
			_selected = YES;
		}
	}
	return self;
}
- (UIImage *)iconGlyph {
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")) {
		UIImage *systemImage = [UIImage systemImageNamed:@"hifispeaker"];
		CGSize newSize = CGSizeMake(systemImage.size.width * 2, systemImage.size.height * 2);
		UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
    		UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext*_Nonnull myContext) {
        		[systemImage drawInRect:(CGRect) {.origin = CGPointZero, .size = newSize}];
    		}];
		return image;
	} else {
		return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
	}
//[UIImage systemImageNamed:@"hifispeaker.fill"];
}

- (UIColor *)selectedColor {
	return [UIColor blackColor];
}

- (BOOL)isSelected {
  return _selected;
}

- (void)setSelected:(BOOL)selected {
	_selected = selected;

	[super refreshState];

	if (_selected) {
		setMonoAudioEnabled(1);
	} else {
		setMonoAudioEnabled(0);
	}
}

@end
