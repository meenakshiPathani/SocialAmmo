//
//  UIUtils+DateFormatting.m
//  
//
//  Created by Meenakshi on 19/03/13.
//
//

#import "UIUtils+DateFormatting.h"

@implementation UIUtils (DateFormatting)

#pragma mark -

+ (NSDate*) dateWithString: (NSString*) string dateFormat: (NSString*) dateFormat
{
    if (string)
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormat];
   
#ifdef ARC_UNABLED
        [dateFormatter autorelease];
#endif
        
        return [dateFormatter dateFromString:string];
    }
    return nil;
}

+ (NSString*) stringWithDateFormat:(NSDate*)date dateFormat:(NSString*)dateFormat
{
    if (date == nil)
        return @"";
    
    NSDateFormatter* inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:dateFormat];
    
#ifdef ARC_UNABLED
    [inFormat autorelease];
#endif

    return [NSString stringWithFormat:@"%@",[inFormat stringFromDate:date]];
}

@end
