//
//  EWAYActivityProgress.h
//  EWAYTest
//

#import <Foundation/Foundation.h>

@interface PayflowActivityProgress : NSObject

+ (void)showActivityProgressWithText:(NSString *)text;
+ (void)showActivityProgress;
+ (void)hideActivityProgress;

@end
