#import <substrate.h>
#import <UIKit/UIKit.h>

static NSString * const audioSel = @"_didTapAudioButton:";

static void (*orig_didTapVideoButton)(id self, SEL _cmd, id sender);
static void (*orig_didTapAudioButton)(id self, SEL _cmd, id sender);

static void confirmCall(id self, SEL _cmd, id sender) {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are ya Sure?"
		message:nil preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *call = [UIAlertAction actionWithTitle:@"Yes, call" style:UIAlertActionStyleDefault handler:^(id _){
		if ([NSStringFromSelector(_cmd) isEqual:audioSel]) {
			orig_didTapAudioButton(self, _cmd, sender);
		} else {
			orig_didTapVideoButton(self, _cmd, sender);
		}

	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:call];
	[alert addAction:cancel];
	__kindof UIViewController *activeVC = [self valueForKey:@"_delegate"];
	[activeVC presentViewController:alert animated:YES completion:nil];

}

__attribute__((constructor)) static void areYouSureInit(void) {
	Class IGDirectThreadCallButtonsCoordinator = objc_getClass("IGDirectThreadCallButtonsCoordinator");
	MSHookMessageEx(IGDirectThreadCallButtonsCoordinator, @selector(_didTapVideoButton:), (IMP) &confirmCall, (IMP*) &orig_didTapVideoButton);
	MSHookMessageEx(IGDirectThreadCallButtonsCoordinator, @selector(_didTapAudioButton:), (IMP) &confirmCall, (IMP*) &orig_didTapAudioButton);

}