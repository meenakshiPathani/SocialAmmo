//
//  CustomInputView.h
//  PicLab
//
//  Created by Rupesh Kumar on 2/17/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

@protocol CustomInputViewDelegate<NSObject>
@optional
- (void) fillTextWithColor:(UIColor*)textColor;
@end

@interface CustomInputView : UIImageView
{
    
}

@property (nonatomic, assign) IBOutlet id<CustomInputViewDelegate> customInputViewDelegate;

@end
