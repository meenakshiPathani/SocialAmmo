//
//  UIUtils.h
//  Version 1.0
//  

#include <sys/xattr.h>
#import "UIPrefix.h"
#
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

#import "UIUtils.h"

#define  KeyboardDoneButtonTag  7000



@implementation UIUtils

+ (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle: @"OK" otherButtonTitles: nil];
	[alert show];
}

+ (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate tag:(NSUInteger)tag
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle: @"OK" otherButtonTitles: nil];
	alert.tag = tag;
	[alert show];
}

+ (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate withCancelTitle:(NSString*)cancelTitle otherButtonTitle:(NSString*)otherBtnTitle tag:(NSUInteger)tag
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherBtnTitle, nil];
	alert.tag = tag;
	[alert show];
}

+ (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate withCancelTitle:(NSString*)cancelTitle otherButtonTitle:(NSString*)otherBtnTitle otherButtonTitle1:(NSString*)otherBtnTitle1 tag:(NSUInteger)tag
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherBtnTitle,otherBtnTitle1,nil];
	alert.tag = tag;
	[alert show];
}

+ (void) messageAlertWithOkCancel:(NSString*)msg title:(NSString*)title delegate:(id)delegate
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle: @"No" otherButtonTitles:@"Yes", nil];
	[alert show];
}


+ (void) messageAlertWithOkCancel:(NSString*)msg title:(NSString*)title delegate:(id)delegate tag:(NSUInteger)tag
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle: @"No" otherButtonTitles:@"Yes", nil];
	alert.tag = tag;
	[alert show];
}


+ (void) errorAlert:(NSString*)msg
{
	[UIUtils messageAlert:msg title:@"Error" delegate:nil];
}

+ (void) localizedErrorAlert:(NSString*)strId
{
	[UIUtils messageAlert:strId title:@"Message" delegate:nil];
}

+ (void) conditionFailedMsg:(NSString*)condition filename:(NSString*)fname line:(int)line
{
	NSString* str = [NSString stringWithFormat:@"Condition Failed (%@)\n\n%@\nLine No: %d", condition, fname, line];
	[UIUtils messageAlert:str title:@"DebugError (Please report)" delegate:nil];
}

# pragma mark -

+ (BOOL) isString:(NSString*)str inArray:(NSArray*)array
{
	for (id s in array)
	{
		if (_IsSameString(str, s))
			return YES;
	}
	return NO;
}

#pragma mark -

+ (BOOL) isConnectedToNetwork
{
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	// synchronous model

	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		DLog(@"Error. Could not recover network reachability flags\n");
		return 0;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	//return (isReachable && !needsConnection) ? YES : NO;
	//BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	return (isReachable && !needsConnection);
}


+ (void) addNotificationToQueue:(NSString*)name object:(id)inObject userInfo:(NSDictionary*)dictionary postingStyle:(NSPostingStyle)style
{
	NSNotification* notification = [NSNotification notificationWithName:(NSString *)name object:(id)inObject userInfo:dictionary];

	[[NSNotificationQueue defaultQueue] dequeueNotificationsMatching:notification coalesceMask:NSNotificationCoalescingOnName];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:style];
}

+ (BOOL) checkForSpecialCharacter:(NSString*)string
{
	NSString* str = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYZ1234567890.-_";
	NSCharacterSet* alfaNumericSet = [NSCharacterSet characterSetWithCharactersInString:str];
	for (int i = 0; i < string.length; ++i)
	{
		if (![alfaNumericSet characterIsMember:[string characterAtIndex:i]])
			return YES;
	}
	return NO;
}

+ (void) moveView:(UIView*)view toX:(CGFloat)x andY:(CGFloat)y
{
	_Assert(view);
	CGRect r = view.frame;
	view.frame = CGRectMake(x, y, r.size.width, r.size.height);
}

+ (void) moveView:(UIView*)view xOffset:(CGFloat)x yOffset:(CGFloat)y
{
	_Assert(view);
	CGRect r = view.frame;
	r.origin.x += x;
	r.origin.y += y;
	view.frame = r;
}

+ (void) moveViewFor:(UIViewController*)viewC xOffset:(CGFloat)x yOffset: (CGFloat)y
{
#ifdef _ShowStatusBar
	_Assert(viewC && viewC.view);
	CGRect r = viewC.view.frame;
	r.origin.y -= 20;
	viewC.view.frame = r;
#endif
	
}

#pragma mark -

+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (paths.count <= 0)
		return nil;

	NSString* dirPath = [paths objectAtIndex:0];
	if (subpath)
		dirPath = [dirPath stringByAppendingFormat:@"/%@", subpath];

	return dirPath;
}

+ (void) saveFileWithData:(NSData*)data withFilePath:(NSString*)filePath
{
	NSString* str = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
	
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	
	NSArray* pathArray = [filePath componentsSeparatedByString:@"/"];
	NSMutableArray* pathArr = [NSMutableArray arrayWithArray:pathArray];
	[pathArr removeLastObject];
	NSMutableString* pathStr = [NSMutableString string];
	[pathStr appendString:[pathArr objectAtIndex:0]];
	for (int i = 1; i< pathArr.count; ++i)
	{
		[pathStr appendString:[NSString stringWithFormat:@"%@/", [pathArr objectAtIndex:i]]];
	}
	
	[fileMgr createDirectoryAtPath:pathStr withIntermediateDirectories:YES attributes:nil error:nil];
	NSError* error;
	
	[str writeToFile:filePath atomically:YES encoding:NSISOLatin1StringEncoding error:&error];
}

+ (void) saveImageWithData:(NSData*)data forFilePath:(NSString*)filePath
{
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	
	NSArray* pathArray = [filePath componentsSeparatedByString:@"/"];
	NSMutableArray* pathArr = [NSMutableArray arrayWithArray:pathArray];
	[pathArr removeLastObject];
	NSMutableString* pathStr = [NSMutableString string];
	[pathStr appendString:[pathArr objectAtIndex:0]];
	for (int i = 1; i< pathArr.count; ++i)
	{
		[pathStr appendString:[NSString stringWithFormat:@"%@/", [pathArr objectAtIndex:i]]];
	}
	
	[fileMgr createDirectoryAtPath:pathStr withIntermediateDirectories:YES attributes:nil error:nil];
	
	[data writeToFile:filePath atomically:YES];
}

+ (BOOL) isFileExistAtPath:(NSString*)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (void) createDirectoryAtPath:(NSString*)path
{
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	[fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (NSString*) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString*) getUniqueImageNameForDirectory:(NSString*)directory withPrefix:(NSString*)prefix
{
	NSString* guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
	if (prefix.length == 0)
		prefix = @"WIPImage";
	NSString* uniqueFileName = [NSString stringWithFormat:@"%@%@%@", prefix, kImageFileSeparator,guid];
	NSString* filepath = [NSString stringWithFormat:@"%@%@.png", directory, uniqueFileName];
	DLog(@"uniqueFileName: '%@'", uniqueFileName);
	
//	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//	NSDate* now = [NSDate date];
//	
//	NSString* theDate = [dateFormat stringFromDate:now];
//	NSString* uniqueName = [NSString stringWithFormat:@"%@%@%u.png", prefix, kImageFileSeparator,(NSUInteger)([now timeIntervalSince1970]*10.0)];
//	NSString* filepath = [NSString stringWithFormat:@"%@%@.png", directory, uniqueName];
	
	if(![[NSFileManager defaultManager]fileExistsAtPath:filepath])
		return filepath;
	return nil;
}

+ (NSString*) getUniqueImageNameForDirectory:(NSString*)directory
{
	NSString* guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
	NSString* uniqueFileName = [NSString stringWithFormat:@"%@",guid];
	NSString* filepath = [NSString stringWithFormat:@"%@%@.png", directory, uniqueFileName];
	DLog(@"uniqueFileName: '%@'", uniqueFileName);
	
	//	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	//	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	//	NSDate* now = [NSDate date];
	//
	//	NSString* theDate = [dateFormat stringFromDate:now];
	//	NSString* uniqueName = [NSString stringWithFormat:@"%@%@%u.png", prefix, kImageFileSeparator,(NSUInteger)([now timeIntervalSince1970]*10.0)];
	//	NSString* filepath = [NSString stringWithFormat:@"%@%@.png", directory, uniqueName];
	
	if(![[NSFileManager defaultManager]fileExistsAtPath:filepath])
		return filepath;
	return nil;
}


+ (NSString*)getFormatedString:(NSNumber*)number withMaxDigit:(NSInteger)maxDidgit
{
	NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
    [numberFormatter setPaddingCharacter:@"0"];
    [numberFormatter setMinimumIntegerDigits:maxDidgit];
    [numberFormatter setMaximumIntegerDigits:maxDidgit];
	
    return [numberFormatter stringFromNumber:number];
}

+ (NSString*) encodedString:(NSString*)str
{
	NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
															(NULL,(CFStringRef)str, NULL,
															 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
															 kCFStringEncodingUTF8 ));
	return encodedString;
}

#pragma mark -

+ (NSArray*) getSubViewsFromView:(UIView*)view withClass:(NSString*) className
{
	NSMutableArray* classArray = [NSMutableArray array];
	NSArray* viewsArray = [view subviews];
	
	for (int i = 0; i < viewsArray.count; ++i)
	{
		UIView* view = [viewsArray objectAtIndex:i];
		
		if ([view isKindOfClass:NSClassFromString(className)]) 
		{
			[classArray addObject:view];
		}
		NSArray* array = [self getSubViewsFromView:view withClass:className];
		[classArray addObjectsFromArray:array];
	}
	return classArray;
}

#pragma mark -

+ (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL*)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

#pragma mark -

+ (BOOL) isDevicePortrait
{
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

#pragma mark -

+ (NSDate*) fileModifiedDate:(NSString*)path 
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) 
        return nil;

    NSError* error = nil;
    NSDictionary* attributes = [fileManager attributesOfItemAtPath:path error:&error];
    if (!attributes) 
        return nil;
    return [attributes fileCreationDate];
}

#pragma mark -

+ (BOOL) validateEmail:(NSString *) email
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

+ (BOOL) validatePhoneNr:(NSString *) phone
{
	NSString* phoneRegex = @"> /\(?([0-9]{3})\\)?([ .-]?)([0-9]{3})\2([0-9]{4})/";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phoneTest evaluateWithObject:phone];
    return isValid;
}

+ (BOOL) validateDisplayName:(NSString *) name  // Alphabetic characters
{
	name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString* phoneRegex = @"^[a-zA-Z]*$";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phoneTest evaluateWithObject:name];
    return isValid;
}

+ (BOOL) validateForEmptyString: (NSString *)inputString andFieldName: (NSString *)theFieldName
{
    BOOL isValid = YES;
    NSString* updatedInputString = [inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([updatedInputString  length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:kBlankDataMessage,theFieldName]
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        isValid = NO;
        
    }
    return isValid;
}

+ (NSString*) checknilAndWhiteSpaceinString:(NSString*)string
{
    return (string == nil || string.length <1)?@"":[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL) isIphone
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return YES;
    else
        return NO;
}

#pragma mark-

+ (NSString*) iPhone5ImageName:(NSString*)imageName
{
    NSMutableString* imageNameMutable = [NSMutableString stringWithString:imageName];
    NSRange retinaAtSymbol = [imageName rangeOfString:@"@"];
    if (retinaAtSymbol.location != NSNotFound)
    {
        [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
    }
    else
    {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f)
        {
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound)
            {
                [imageNameMutable insertString:@"-568h@2x" atIndex:dot.location];
            }
            else
            {
                [imageNameMutable appendString:@"-568h@2x"];
            }
        }
    }
    return [NSString stringWithString:imageNameMutable];
}

+ (NSString*) iphoneScreenName:(NSString*)screenName
{
    NSMutableString* screenNameMutable = [NSMutableString stringWithString:screenName];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight != 568.0f)
        [screenNameMutable appendString:@"_iPhone4"];
    
    return [NSString stringWithString:screenNameMutable];
}

+ (BOOL) isEmptyString:(NSString *)string;
{
    if (((NSNull *) string == [NSNull null]) || (string == nil) ) {
        return YES;
    }
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    if ([string isEqualToString:@""]) {
        return YES;
    }
	
    return NO;
}

+ (NSArray*) getCountryList
{
	NSLocale *locale = [NSLocale currentLocale];
	NSArray *countryArray = [NSLocale ISOCountryCodes];
	
	NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
	
	for (NSString *countryCode in countryArray) {
		
		NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
		[sortedCountryArray addObject:displayNameString];
		
	}
	
	[sortedCountryArray sortUsingSelector:@selector(localizedCompare:)];
	return sortedCountryArray;
}


#pragma mark-

+ (id) jsonFromData:(NSData*)data
{
    if (data == nil)
	{
		[UIUtils messageAlert:@"No data found." title:@"" delegate:nil];
		return nil;
	}
	
    NSError *parseError = nil;
	id rootArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
	
    if (rootArray)
		return rootArray;
	
    return nil;
}

+ (NSString*) getJsonPostString:(NSDictionary*)dict
{
	_Assert(dict);
    
	NSError* error;
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict
													   options:NSJSONWritingPrettyPrinted
														 error:&error];
	
    if (jsonData)
    {
		NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
#ifdef ARC_DISABLEAdministrator
        [jsonString autorelease];
#endif
        return jsonString;
    }
	else
	{
		DLog(@"Got an error: %@", error);
	}
	
    return nil;
}


#pragma mark-

+ (UILabel*) createLabelWithText:(NSString*)text frame:(CGRect)rect
{
	UILabel* label = [[UILabel alloc] initWithFrame:rect];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor blackColor];
	label.text = text;
	label.font = [UIFont fontWithName:kFontRalewayBold size:15.0];
	
	return label;
}

+ (UIView*) createWhiteLineWithFrame:(CGRect)rect
{
	UIView* lineView = [[UIView alloc] initWithFrame:rect];
	lineView.backgroundColor = [UIColor whiteColor];
	return lineView;
}

+ (void) setExclusiveTouchForButtons:(UIView *)myView
{
    for (UIView * button in [myView subviews]) {
        if([button isKindOfClass:[UIButton class]])
            [((UIButton *)button) setExclusiveTouch:YES];
    }
}

#pragma mark-

+ (UIImage*) scaleImage:(UIImage*) image inRect:(CGRect) rect proportionally:(BOOL)proportionally
{
	assert(image);
	
    double ratio;
    double delta;
    CGPoint offset;
	
	CGSize newSize = rect.size;
	
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
	
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
	
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
	
	
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize proportionally:(BOOL)proportionally
{
	assert(image);

    float width = newSize.width;
    float height = newSize.height;
	
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
	
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
	
    width = image.size.width / divisor;
    height = image.size.height / divisor;
	
    rect.size.width  = width;
    rect.size.height = height;
	
    if(height < width)
        rect.origin.y = height / 3;
    [image drawInRect: rect];
	
    UIImage* smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return smallImage;
}

// This method is used to add reveal button as left bar button on navigation bar.

+ (UIButton*) getRevelButtonItem:(UIViewController*)viewController
{
    SAMenuViewController *revealController = [viewController revealViewController];
//    [viewController.view addGestureRecognizer:revealController.panGestureRecognizer];

    UIImage* image3 = [UIImage imageNamed:@"more.png"];
    CGRect frameimg = CGRectMake(0, 0,36,36);
    UIButton* barButton = [[UIButton alloc] initWithFrame:frameimg];
	barButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	barButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [barButton setImage:image3 forState:UIControlStateNormal];
    [barButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [barButton setShowsTouchWhenHighlighted:YES];
    
    return barButton;
}

+ (UIButton*) addBackButtonWithOutTitle
{
	NSString* imageName = @"ack arrow.png";
	UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage* backBtnImage = [UIImage imageNamed:imageName];
	[backButton setImage:backBtnImage forState:UIControlStateNormal];
	backButton.frame = CGRectMake(0, 0, 32, 32);
	return backButton;
}


+ (UIFont*) cutomFont:(NSURL*)url
{
	//	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//    NSString * documentsDirectory = [paths objectAtIndex:0];
	//    NSString * fontPath = [documentsDirectory stringByAppendingPathComponent:@"Fonts/Chalkduster.ttf"];
	
	//    NSURL * url = [NSURL fileURLWithPath:@"Users/mindfire/Library/Application Support/iPhone Simulator/7.1/Applications/4CEF22B1-38C2-4484-8C0A-29A3E5408738/Documents/Intro.ttf"];
	
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    NSString * newFontName = (__bridge NSString *)CGFontCopyPostScriptName(newFont);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error;
    CTFontManagerRegisterGraphicsFont(newFont, &error);
    CGFontRelease(newFont);
	
    UIFont* finalFont = [UIFont fontWithName:newFontName size:18.0f];
	
	return finalFont;
}


@end

