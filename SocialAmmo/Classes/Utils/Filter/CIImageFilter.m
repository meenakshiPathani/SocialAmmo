//
//  CIImageFilter.m
//  iphone-filters
//

#include <math.h>
#import "CIImageFilter.h"

#define RoundToQuantum(quantum)  ClampToQuantum(quantum)
#define ScaleCharToQuantum(value)  ((Quantum) (value))

/* These are our own constants */
#define SAFECOLOR(color) MIN(255,MAX(0,color))

typedef void (*FilterCallback)(UInt8 *pixelBuf, UInt32 offset, void *context);

@implementation UIImage (ImageFilter)


#pragma mark Basic Filters
#pragma mark Internals
- (UIImage*) applyFilter:(FilterCallback)filter context:(void*)context
{
	CGImageRef inImage = self.CGImage;
    size_t width = CGImageGetWidth(inImage);
    size_t height = CGImageGetHeight(inImage);
    size_t bits = CGImageGetBitsPerComponent(inImage);
    size_t bitsPerRow = CGImageGetBytesPerRow(inImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(inImage);
    int alphaInfo = CGImageGetAlphaInfo(inImage);
    
    if (alphaInfo != kCGImageAlphaPremultipliedLast &&
        alphaInfo != kCGImageAlphaNoneSkipLast) {
        if (alphaInfo == kCGImageAlphaNone ||
            alphaInfo == kCGImageAlphaNoneSkipFirst) {
            alphaInfo = kCGImageAlphaNoneSkipLast;
        }else {
            alphaInfo = kCGImageAlphaPremultipliedLast;
        }
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     bits,
                                                     bitsPerRow,
                                                     colorSpace,
                                                     alphaInfo);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), inImage);
        inImage = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
    }else {
        CGImageRetain(inImage);
    }
    
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
	int length = (int)CFDataGetLength(m_DataRef);
	CFMutableDataRef m_DataRefEdit = CFDataCreateMutableCopy(NULL,length,m_DataRef);
	CFRelease(m_DataRef);
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetMutableBytePtr(m_DataRefEdit);
	
	for (int i=0; i<length; i+=4)
	{
		filter(m_PixelBuf,i,context);
	}
    CGImageRelease(inImage);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
											 width,
											 height,
											 bits,
											 bitsPerRow,
											 colorSpace,
											 alphaInfo
											 );
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef
                                              scale:self.scale
                                        orientation:self.imageOrientation];
	CGImageRelease(imageRef);
    CFRelease(m_DataRefEdit);
	return finalImage;
	
}

#pragma mark C Implementation
void filterGreyscale(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	uint32_t gray = 0.3 * red + 0.59 * green + 0.11 * blue;
	
	pixelBuf[r] = gray;
	pixelBuf[g] = gray;
	pixelBuf[b] = gray;
}

void filterSepia(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red * 0.393) + (green * 0.769) + (blue * 0.189));
	pixelBuf[g] = SAFECOLOR((red * 0.349) + (green * 0.686) + (blue * 0.168));
	pixelBuf[b] = SAFECOLOR((red * 0.272) + (green * 0.534) + (blue * 0.131));
}

void filterPosterize(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	int levels = *((int*)context);
	if (levels == 0) levels = 1; // avoid divide by zero
	int step = 255 / levels;
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red / step) * step);
	pixelBuf[g] = SAFECOLOR((green / step) * step);
	pixelBuf[b] = SAFECOLOR((blue / step) * step);
}


void filterSaturate(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double t = *((double*)context);
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	int avg = ( red + green + blue ) / 3;
	
	pixelBuf[r] = SAFECOLOR((avg + t * (red - avg)));
	pixelBuf[g] = SAFECOLOR((avg + t * (green - avg)));
	pixelBuf[b] = SAFECOLOR((avg + t * (blue - avg)));
}

void filterBrightness(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double t = *((double*)context);
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(red*t);
	pixelBuf[g] = SAFECOLOR(green*t);
	pixelBuf[b] = SAFECOLOR(blue*t);
}

void filterGamma(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double amount = *((double*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(pow(red,amount));
	pixelBuf[g] = SAFECOLOR(pow(green,amount));
	pixelBuf[b] = SAFECOLOR(pow(blue,amount));
}

void filterOpacity(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double val = *((double*)context);
	
	int a = offset+3;
	
	int alpha = pixelBuf[a];
	
	pixelBuf[a] = SAFECOLOR(alpha * val);
}

double calcContrast(double f, double c){
	return (f-0.5) * c + 0.5;
}

void filterContrast(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double val = *((double*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(255 * calcContrast((double)((double)red / 255.0f), val));
	pixelBuf[g] = SAFECOLOR(255 * calcContrast((double)((double)green / 255.0f), val));
	pixelBuf[b] = SAFECOLOR(255 * calcContrast((double)((double)blue / 255.0f), val));
}

double calcBias(double f, double bi){
	return (double) (f / ((1.0 / bi - 1.9) * (0.9 - f) + 1));
}

void filterBias(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double val = *((double*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red * calcBias(((double)red / 255.0f), val)));
	pixelBuf[g] = SAFECOLOR((green * calcBias(((double)green / 255.0f), val)));
	pixelBuf[b] = SAFECOLOR((blue * calcBias(((double)blue / 255.0f), val)));
}

void filterInvert(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(255-red);
	pixelBuf[g] = SAFECOLOR(255-green);
	pixelBuf[b] = SAFECOLOR(255-blue);
}

#pragma mark Filters

-(UIImage*)greyscale 
{
	return [self applyFilter:filterGreyscale context:nil];
}

- (UIImage*)sepia
{
	return [self applyFilter:filterSepia context:nil];
}

- (UIImage*)posterize:(int)levels
{
	return [self applyFilter:filterPosterize context:&levels];
}

- (UIImage*)saturate:(double)amount
{
	return [self applyFilter:filterSaturate context:&amount];
}

- (UIImage*)brightness:(double)amount
{
	return [self applyFilter:filterBrightness context:&amount];
}

- (UIImage*)gamma:(double)amount
{
	return [self applyFilter:filterGamma context:&amount];	
}

- (UIImage*)opacity:(double)amount
{
	return [self applyFilter:filterOpacity context:&amount];	
}

- (UIImage*)contrast:(double)amount
{
	return [self applyFilter:filterContrast context:&amount];
}

- (UIImage*)bias:(double)amount
{
	return [self applyFilter:filterBias context:&amount];	
}

- (UIImage*)invert
{
	return [self applyFilter:filterInvert context:nil];
}

@end
