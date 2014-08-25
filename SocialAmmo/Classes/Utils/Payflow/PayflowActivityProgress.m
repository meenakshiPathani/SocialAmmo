//
//  EWAYActivityProgress.m
//  EWAYTest
//


#import "PayflowActivityProgress.h"
#import <QuartzCore/QuartzCore.h>

@interface PayflowActivityProgress ()

@property (strong, nonatomic) UIView *coverView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UILabel *label;
@property (getter = isPresented) BOOL presented;

+ (PayflowActivityProgress *)activityProgressInstance;

@end

@implementation PayflowActivityProgress

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_coverView = [[UIView alloc] init];
		_coverView.backgroundColor = [UIColor blackColor];
		_coverView.alpha = 0.6;
		_coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

		_containerView = [[UIView alloc] init];
		_containerView.backgroundColor = [UIColor blackColor];
		_containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_containerView.layer.cornerRadius = 5.0f;

		_activityIndicator = [[UIActivityIndicatorView alloc] init];
		_activityIndicator.color = [UIColor whiteColor];
		_activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
		[_activityIndicator startAnimating];
		[_containerView addSubview:_activityIndicator];

		_label = [[UILabel alloc] init];
		_label.text = @"Processing...";
		_label.textAlignment = NSTextAlignmentCenter;
		_label.textColor = [UIColor whiteColor];
		_label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		[_containerView addSubview:_label];
	}

	return self;
}

+ (PayflowActivityProgress *)activityProgressInstance
{
	static PayflowActivityProgress *sSharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sSharedInstance = [[PayflowActivityProgress alloc] init];
	});

	return sSharedInstance;
}

+ (void)showActivityProgressWithText:(NSString *)text
{
	PayflowActivityProgress *obj = [PayflowActivityProgress activityProgressInstance];
	if (text)
	{
		obj.label.text = text;
	}

	if (!obj.isPresented)
	{
		UIView *view = [UIApplication sharedApplication].keyWindow;
		obj.coverView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
		obj.containerView.frame = obj.coverView.frame;
		obj.label.frame = CGRectMake(0.0f, CGRectGetHeight(view.frame) * 0.5f - 15.0f, CGRectGetWidth(view.frame), 30.0f);
		obj.activityIndicator.frame = CGRectMake(CGRectGetWidth(view.frame) * 0.5f - 25.0f, CGRectGetHeight(view.frame) * 0.5f - 70.0f, 50.0f, 50.0f);
		[view addSubview:obj.containerView];
		[view addSubview:obj.coverView];
		obj.presented = YES;
		[UIView animateWithDuration:0.1 animations:^{
			obj.containerView.frame = CGRectMake(20.0f, CGRectGetHeight(view.frame) * 0.5 - 40.0f, CGRectGetWidth(view.frame) - 40.0f, 80.0f);
			obj.activityIndicator.frame = CGRectMake(CGRectGetWidth(obj.containerView.frame) * 0.5f - 25.0f, 0.0f, 50.0f, 50.0f);
			obj.label.frame = CGRectMake(0.0f, 50.0f, CGRectGetWidth(obj.containerView.frame), 30.0f);
//			[obj.containerView setNeedsLayout];
		}];
	}
}

+ (void)showActivityProgress
{
	[PayflowActivityProgress showActivityProgressWithText:nil];
}

+ (void)hideActivityProgress
{
	PayflowActivityProgress *obj = [PayflowActivityProgress activityProgressInstance];
	obj.presented = NO;
	if ([obj.coverView superview])
	{
		[obj.coverView removeFromSuperview];
		[obj.containerView removeFromSuperview];
	}
}

@end
