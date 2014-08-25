//
//  NSDate+DateConversions.m
//  Social Ammo
//
//  Created by Meenakshi on 02/05/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "NSDate+DateConversions.h"

@implementation NSDate(DateConversions)

static NSDateFormatter* saDateFormatter = nil;


+ (NSDateFormatter*)longStyleDateFromtter
{
    static NSDateFormatter *longStyleDateFormatter = nil;
	if (nil == longStyleDateFormatter)
	{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        longStyleDateFormatter = dateFormatter;
    }
    return longStyleDateFormatter;
}

+ (NSDateFormatter*)SADateFormatter
{
	if (nil == saDateFormatter)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
        saDateFormatter = dateFormatter;
    }
    return saDateFormatter;
}

+ (NSDateFormatter *)conversationLongDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM'/'dd'/'yy"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)conversationDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd,yyyy"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)conversationShortDateFormatter
{
    static NSDateFormatter* dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"h.mm a"];
        [dateFormatter setAMSymbol:@"AM"];
        [dateFormatter setPMSymbol:@"PM"];
    });
    return dateFormatter;
}

+ (NSString *)longStyleDateStringFromString:(NSString *)dateString
{
	NSDate *date = [[self SADateFormatter] dateFromString:dateString];
    return [date longStyleDateString];
}

+ (NSDate *)dateFromSADateString:(NSString *)dateString
{
	return [[self SADateFormatter] dateFromString:dateString];
}

+ (NSDate*)dateFromSADOBStyleDateString:(NSString*)dateString
{
    return [[self conversationDateFormatter] dateFromString:dateString];
}

+ (NSString*)conversationDateStringWithTimeInterval:(NSTimeInterval)timeInterval
{
	//    NSDateFormatter *formatter = timeInterval + kDateOneDay < current ? [self conversationDateFormatter] : [self conversationShortDateFormatter];
	NSDateFormatter *formatter = [self conversationDateFormatter];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

#pragma mark -

+ (NSCalendar *)calendar
{
    static NSCalendar* sCalendar = nil;
    if (sCalendar == nil)
    {
        sCalendar = [NSCalendar currentCalendar];
    }
    
    return sCalendar;
}

- (NSString *)timeString
{
    NSString* timeString = nil;
    
    static NSDateFormatter* dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"h:mm a"];
        [dateFormatter setAMSymbol:@"am"];
        [dateFormatter setPMSymbol:@"pm"];
    });
    
    timeString = [dateFormatter stringFromDate:self];
    return timeString;
}

- (NSString*) month
{
	NSString* month = nil;
    
    static NSDateFormatter* dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"MMM"];
    });
    
    month = [dateFormatter stringFromDate:self];
    return month;
}

- (NSString*) date
{
	NSString* date = nil;
    
    static NSDateFormatter* dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd"];
    });
    
    date = [dateFormatter stringFromDate:self];
    return date;
}


- (NSString *)dateString
{
    NSString* dateString = nil;
    
    static NSDateFormatter* dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"h:mma M/d/YY"];
        [dateFormatter setAMSymbol:@"am"];
        [dateFormatter setPMSymbol:@"pm"];
        
    });
    dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}

- (NSString *)dayOfTheWeek
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"eeee"];
    });
    
    return [dateFormatter stringFromDate:self];
}

- (NSString*)exactTime
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"h.mm a"];
		
		[dateFormatter setAMSymbol:@"am"];
		[dateFormatter setPMSymbol:@"pm"];
    });
    return [dateFormatter stringFromDate:self];
}

- (NSString*)exactTimeWithDay
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"cccc, h.mm a"];
		
		[dateFormatter setAMSymbol:@"am"];
		[dateFormatter setPMSymbol:@"pm"];
    });
    return [dateFormatter stringFromDate:self];
}

- (NSString*)exactDateTime
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd/MM/yyyy, h.mm a"];
		
		[dateFormatter setAMSymbol:@"am"];
		[dateFormatter setPMSymbol:@"pm"];
    });
    return [dateFormatter stringFromDate:self];
}

- (NSString*)exactDateTimeWithDay
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"cccc MMMM dd, yyyy - h:mm a"];
		
		[dateFormatter setAMSymbol:@"am"];
		[dateFormatter setPMSymbol:@"pm"];
    });
    return [dateFormatter stringFromDate:self];
}

- (NSString*)timeWithoutYear
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"cccc MMMM dd - h:mm a:"];
		
		[dateFormatter setAMSymbol:@"am"];
		[dateFormatter setPMSymbol:@"pm"];
    });
    return [dateFormatter stringFromDate:self];
}

- (NSString *)dateStringWithoutHourAndMinute
{
    NSString* dateString = nil;
    
    static NSDateFormatter* dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"M/d/YY"];
    });
    dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}

- (NSString*)DOBStyleDateString
{
    return [[NSDate conversationDateFormatter] stringFromDate:self];
}

- (NSString *)humanReadableDateString
{
    NSString* dateString = nil;
    
    static const long long kHDMSecondsInMinute = 60;
    static const long long kHDMSecondsInHour = 60 * kHDMSecondsInMinute;
    static const long long kHDMSecondsInDay = 24 * kHDMSecondsInHour;
    static const long long kHDMSecondsInWeek = 7 * kHDMSecondsInDay;
    
    NSDate *now = [NSDate date];
    long long delta = llround([now timeIntervalSinceDate:self]);
    
    if (delta < kHDMSecondsInMinute)
    {
        dateString = @"Less than a minute ago";
    }
    else if (delta < 2 * kHDMSecondsInMinute)
    {
        dateString =  @"1 min ago";
    }
    else if (delta < kHDMSecondsInHour)
    {
        dateString =  [NSString stringWithFormat:@"%lld mins ago", delta / kHDMSecondsInMinute];
    }
    else if (delta < 2 * kHDMSecondsInHour)
    {
        dateString = @"1 hour ago";
    }
    else if (delta < kHDMSecondsInDay)
    {
        //dateString = [NSString stringWithFormat:@"%lld hours ago", delta / kHDMSecondsInHour];
		long long hours = delta/kHDMSecondsInHour;
		if (hours > 3) // When message time goes beyond 3hrs then it should appear as Today, 12:56pm.
			dateString = [self timeString];
		else
			dateString = [NSString stringWithFormat:@"%lld hours ago", delta / kHDMSecondsInHour];
    }
    else if (delta < 2 * kHDMSecondsInDay)
    {
        dateString = [NSString stringWithFormat:@"%@ Yesterday", [self timeString]];
    }
    else if (delta < kHDMSecondsInWeek)
    {
        dateString = [NSString stringWithFormat:@"%@ %@", [self timeString], [self dayOfTheWeek]];
    }
    else
    {
        dateString = [self dateString];
    }
    
    return dateString;
}

- (NSString *)longStyleDateString
{
    NSDateFormatter* dateFormatter = [NSDate longStyleDateFromtter];
    NSString *result = [dateFormatter stringFromDate:self];
    return result;
}

- (NSString *)saStyleDateString
{
	return [[NSDate SADateFormatter] stringFromDate:self];
}

+ (NSDate*)dateFromLongStyleString:(NSString*)dateString
{
    NSDateFormatter* dateFormatter = [NSDate longStyleDateFromtter];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate*) getTodayDate
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
	
	[components setHour:-[components hour]];
	[components setMinute:-[components minute]];
	[components setSecond:-[components second]];
	NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
	return today;
}

+ (NSDate*) getYesterdayDate
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
	
	[components setHour:-[components hour]];
	[components setMinute:-[components minute]];
	[components setSecond:- [components second]];
	NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
	
	[components setHour:-24];
	[components setMinute:0];
	[components setSecond:0];
	NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
	
	return yesterday;
}

+ (NSDate*) getThisWeekDate
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
	
	[components setHour:-[components hour]];
	[components setMinute:-[components minute]];
	[components setSecond:-[components second]];
	
	[components setHour:-24];
	[components setMinute:0];
	[components setSecond:0];
	
	components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
	
	[components setDay:([components day] - ([components weekday] - 1))];
	NSDate *thisWeek  = [cal dateFromComponents:components];
		
	return thisWeek;
}

+ (NSDate*) getLastWeekDate
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
	
	[components setHour:-[components hour]];
	[components setMinute:-[components minute]];
	[components setSecond:-[components second]];
	
	[components setHour:-24];
	[components setMinute:0];
	[components setSecond:0];
	
	components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
	
	[components setDay:([components day] - 7)];
	NSDate *lastWeek  = [cal dateFromComponents:components];
	
	return lastWeek;
}

+ (NSDate*) getThisMonthDate
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
	
	[components setHour:-[components hour]];
	[components setMinute:-[components minute]];
	[components setSecond:-[components second]];
	
	[components setHour:-24];
	[components setMinute:0];
	[components setSecond:0];
	
	components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
	
	[components setDay:([components day] - ([components day] -1))];
	NSDate *thisMonth = [cal dateFromComponents:components];
	
	return thisMonth;
}

+ (NSDate*) getLastMonthDate
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
	
	[components setHour:-[components hour]];
	[components setMinute:-[components minute]];
	[components setSecond:-[components second]];
	
	[components setHour:-24];
	[components setMinute:0];
	[components setSecond:0];
	
	components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
	
	[components setMonth:([components month] - 1)];
	NSDate *lastMonth = [cal dateFromComponents:components];
	return lastMonth;
}

#pragma mark-

+ (NSString*) getDateString:(NSDate*)date forTimeInterval:(NSTimeInterval)timeInterval
{
	NSString* messageTime = nil;
	NSDate* todayDate = [NSDate getTodayDate];
	NSDate* yesterdayDate = [NSDate getYesterdayDate];
	NSDate* thisWeekDate = [NSDate getThisWeekDate];
	
	NSTimeInterval today = [todayDate timeIntervalSince1970];
	NSTimeInterval yesterday = [yesterdayDate timeIntervalSince1970];
	NSTimeInterval thisWeek = [thisWeekDate timeIntervalSince1970];
	
	if(timeInterval >= today)
	{
		messageTime = [NSString stringWithFormat:@"Today, %@", [date humanReadableDateString]];
	}
	else if (timeInterval >= yesterday)
	{
		messageTime = [NSString stringWithFormat:@"Yesterday, %@",[date exactTime]];
	}
	else if (timeInterval >= thisWeek)
	{
		messageTime = [date exactTimeWithDay];
	}
	else
	{
		messageTime = [date exactDateTime];
	}
	
	return messageTime;
}



@end
