//
//  UIImage+Color.m
//  SocialAmmo
//
//  Created by Meenakshi on 17/06/14.
//  Copyright (c) 2014 Test Point. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

- (UIImage*) imageWithColor:(UIColor*)color
{
//	CGRect rect = CGRectMake(0, 0, 1, 1);
//    // Create a 1 by 1 pixel context
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
//    [color setFill];
//    UIRectFill(rect);   // Fill it with your color
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
	
	UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, self.size.width, self.size.height), [self CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
	
    UIImage* coloredImg = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	return coloredImg;
}


- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
	
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
	
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
	
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
	
    CGContextSetAlpha(ctx, alpha);
	
    CGContextDrawImage(ctx, area, self.CGImage);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return newImage;
}

@end
