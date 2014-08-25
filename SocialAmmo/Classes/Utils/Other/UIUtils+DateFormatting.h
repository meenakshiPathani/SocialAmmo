//
//  UIUtils+DateFormatting.h
//  
//
//  Created by Meenakshi on 19/03/13.
//
//  Version 1.0
//  ARC Enable


#import "UIUtils.h"

@interface UIUtils (DateFormatting)

+ (NSDate*) dateWithString: (NSString*) string dateFormat: (NSString*) dateFormat;

+ (NSString*) stringWithDateFormat:(NSDate*)date dateFormat:(NSString*)dateFormat;

@end
