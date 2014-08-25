//
//  SABlurView.h
//  SABlurView
//


#import <UIKit/UIKit.h>

@interface SABlurView : UIView

@property (nonatomic, readwrite) CGFloat blurRadius; // default is 20.0f
@property (nonatomic, readwrite) CGFloat saturationDelta; // default is 1.5
@property (nonatomic, readwrite) UIColor *tintColor; // default nil
@property (nonatomic, weak) UIView *viewToBlur; // default is superview

@end
