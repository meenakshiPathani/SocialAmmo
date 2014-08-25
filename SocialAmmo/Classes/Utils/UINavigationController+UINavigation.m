//
//  UINavigationController+UINavigation.m
//

#import "UINavigationController+UINavigation.h"

@implementation UINavigationController (UINavigation)

- (void) viewDidLoad
{
    [super viewDidLoad];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 7
	if (KVersion >= 7)
	{
		self.edgesForExtendedLayout = UIRectEdgeNone;
		if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
			self.interactivePopGestureRecognizer.enabled = NO;
		}
	}
#endif
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 7

- (BOOL) isTopViewCtrl:(NSString*)className
{
	return [self.topViewController isKindOfClass:NSClassFromString(className)];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault ;
}

#endif

@end
