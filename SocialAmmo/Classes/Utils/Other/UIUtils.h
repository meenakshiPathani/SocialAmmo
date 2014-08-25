//
//  UIUtils.h
//  Version 1.0
//

#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

+ (void) messageAlert: (NSString*)msg title: (NSString*)title delegate: (id)delegate;
+ (void) messageAlertWithOkCancel:(NSString*)msg title:(NSString*)title delegate:(id)delegate;

+ (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate withCancelTitle:(NSString*)cancelTitle otherButtonTitle:(NSString*)otherBtnTitle tag:(NSUInteger)tag;

+ (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate withCancelTitle:(NSString*)cancelTitle otherButtonTitle:(NSString*)otherBtnTitle otherButtonTitle1:(NSString*)otherBtnTitle1 tag:(NSUInteger)tag;

+ (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate tag:(NSUInteger)tag;
+ (void) messageAlertWithOkCancel:(NSString*)msg title:(NSString*)title delegate:(id)delegate tag:(NSUInteger)tag;

+ (void) errorAlert:(NSString*)msg;
+ (void) localizedErrorAlert:(NSString*)strId;

+ (void) conditionFailedMsg:(NSString*)condition filename:(NSString*)fname line:(int)line;

// pure UI utils function
+ (BOOL) isString:(NSString*)str inArray:(NSArray*)array;

+ (BOOL) isConnectedToNetwork;

+ (void) addNotificationToQueue:(NSString*)name object:(id)self userInfo:(NSDictionary*)dictionary postingStyle:(NSPostingStyle)style;

+ (void) moveView:(UIView*)view toX:(CGFloat)x andY:(CGFloat)y;
+ (void) moveView:(UIView*)view xOffset:(CGFloat)x yOffset:(CGFloat)y;
+ (void) moveViewFor:(UIViewController*)viewC xOffset:(CGFloat)x yOffset:(CGFloat)y;

+ (BOOL) checkForSpecialCharacter:(NSString*) string;

+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath;
+ (void) saveFileWithData:(NSData*)data withFilePath:(NSString*)filePath;
+ (void) saveImageWithData:(NSData*)data forFilePath:(NSString*)filePath;
+ (BOOL) isFileExistAtPath:(NSString*)filePath;
+ (void) createDirectoryAtPath:(NSString*)path;
+ (NSString*) documentsDirectory;

+ (NSString*) getUniqueImageNameForDirectory:(NSString*)directory withPrefix:(NSString*)prefix;
+ (NSString*) getUniqueImageNameForDirectory:(NSString*)directory;

+ (NSString*)getFormatedString:(NSNumber*)number withMaxDigit:(NSInteger)maxDidgit;
+ (NSString*) encodedString:(NSString*)str;

+ (NSArray*) getSubViewsFromView:(UIView*)view withClass:(NSString*) className;

+ (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL*)URL;

+ (BOOL) isDevicePortrait;

+ (NSDate*) fileModifiedDate:(NSString*)path;

+ (BOOL) validateEmail: (NSString *) email;
+ (BOOL) validatePhoneNr:(NSString *) phone;
+ (BOOL) validateDisplayName:(NSString *) name;
// Alphabetic characters

+ (BOOL) validateForEmptyString: (NSString *)inputString andFieldName: (NSString *)theFieldName;
+ (NSString*) checknilAndWhiteSpaceinString:(NSString*)string;

+ (BOOL) isIphone;
+ (NSString*) iPhone5ImageName:(NSString*)imageName;
+ (NSString*) iphoneScreenName:(NSString*)screenName;

+ (BOOL) isEmptyString:(NSString *)string;
+ (NSArray*) getCountryList;

+ (id) jsonFromData:(NSData*)data;
+ (NSString*) getJsonPostString:(NSDictionary*)dict;

+ (UILabel*) createLabelWithText:(NSString*)text frame:(CGRect)rect;
+ (UIView*) createWhiteLineWithFrame:(CGRect)rect;
+ (void) setExclusiveTouchForButtons:(UIView *)myView;

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize proportionally:(BOOL)proportionally;
+ (UIImage*) scaleImage:(UIImage*) image inRect:(CGRect) rect proportionally:(BOOL)proportionally;
+ (UIButton*) getRevelButtonItem:(UIViewController*)viewController;
+ (UIButton*) addBackButtonWithOutTitle;

+ (UIFont*) cutomFont:(NSURL*)url;

@end


