//
//  CIImageFilter.h
//  iphone-filters
//

#import <Foundation/Foundation.h>

enum {
    CurveChannelNone                 = 0,
    CurveChannelRed					 = 1 << 0,
    CurveChannelGreen				 = 1 << 1,
    CurveChannelBlue				 = 1 << 2,
};
typedef NSUInteger CurveChannel;

@interface UIImage (CIImageFilter)

/* Filters */
- (UIImage*) greyscale;
- (UIImage*) sepia;
- (UIImage*) posterize:(int)levels;
- (UIImage*) saturate:(double)amount;
- (UIImage*) brightness:(double)amount;
- (UIImage*) gamma:(double)amount;
- (UIImage*) opacity:(double)amount;
- (UIImage*) contrast:(double)amount;
- (UIImage*) bias:(double)amount;
- (UIImage*) invert;

@end
