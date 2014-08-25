//
//  NSDate+DateConversions.h
//  Social Ammo
//
//  Created by Meenakshi on 02/05/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSTimeInterval kDateOneDay = 60 * 60 * 24;

@interface NSDate(DateConversions)

+ (NSString*)longStyleDateStringFromString:(NSString*)dateString;
+ (NSDate*)dateFromSADateString:(NSString*)dateString;
+ (NSDate*)dateFromLongStyleString:(NSString*)dateString;
+ (NSDate*)dateFromSADOBStyleDateString:(NSString*)dateString;
+ (NSString*)conversationDateStringWithTimeInterval:(NSTimeInterval)timeInterval;

- (NSString*)longStyleDateString;
- (NSString*)saStyleDateString;
- (NSString*)humanReadableDateString;
- (NSString*)dateString;
- (NSString*)exactTime;
- (NSString*)exactTimeWithDay;
- (NSString*)exactDateTime;
- (NSString*)exactDateTimeWithDay;
- (NSString*)timeWithoutYear;
- (NSString *)dateStringWithoutHourAndMinute;


- (NSString *)timeString;
- (NSString*) month;
- (NSString*) date;

+ (NSDate*) getTodayDate;
+ (NSDate*) getYesterdayDate;
+ (NSDate*) getThisWeekDate;
+ (NSDate*) getLastWeekDate;
+ (NSDate*) getThisMonthDate;
+ (NSDate*) getLastMonthDate;

+ (NSString*) getDateString:(NSDate*)date forTimeInterval:(NSTimeInterval)timeInterval;


@end

