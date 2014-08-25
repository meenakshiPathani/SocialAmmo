//
//  FilterToolView.m
//  DemoFilterApp
//
//  Created by Meenakshi on 09/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UIImage+Extensions.h"
#import "Filter.h"

#import "FilterToolView.h"

@implementation FilterToolView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self baseInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self baseInit];
	}
	return self;
}

#pragma mark-

- (void)baseInit
{
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FilterColor_back.png"]];
	
	[self initializeFilterContext];
}

-(void) initializeFilterContext
{
    context = [CIContext contextWithOptions:nil];
}

-(void) applyGesturesToFilterPreviewImageView:(UIView *) view
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyFilter:)];
	
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
	
    [view addGestureRecognizer:singleTapGestureRecognizer];
}


-(void) applyFilter:(id) sender
{
	selectedFilterView.layer.shadowRadius = 0.0f;
	selectedFilterView.layer.shadowOpacity = 0.6f;
    
	selectedFilterView = [(UITapGestureRecognizer *) sender view];
    
	selectedFilterView.layer.shadowColor = [UIColor redColor].CGColor;
	selectedFilterView.layer.shadowRadius = 3.0f;
	selectedFilterView.layer.shadowOpacity = 0.9f;
	selectedFilterView.layer.shadowOffset = CGSizeZero;
	selectedFilterView.layer.masksToBounds = NO;
    
	NSUInteger filterIndex = selectedFilterView.tag;
	CGImageRef cgimg = nil;
	if (filterIndex == 0)
	{
		cgimg = [context createCGImage:beginImage fromRect:[beginImage extent]];
	}
	else {
		Filter *filter = [filters objectAtIndex:filterIndex -1];
		CIImage *outputImage = [filter.filter outputImage];
		cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
	}
	
	finalImage = [UIImage imageWithCGImage:cgimg];
	
	//	finalImage = [finalImage imageRotatedByDegrees:90];
    
	if ([self.observer respondsToSelector:@selector(applyFilterImage:)])
		[self.observer applyFilterImage:finalImage];
	   
	CGImageRelease(cgimg);
}

-(void) createPreviewViewsForFilters
{
    int offsetX = 10;
	
    for(int index = 0; index < [filters count] + 1; index++)
    {
        UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 5, 40, 40)];
        
//        filterView.layer.borderColor = [UIColor blackColor].CGColor;
//		filterView.layer.borderWidth = 2.0f;
//		filterView.layer.cornerRadius = 3.0f;
		
        filterView.tag = index;
        
        // create a label to display the name
        UILabel *filterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, filterView.bounds.size.width, 15)];
        
//        filterNameLabel.center = CGPointMake(filterView.bounds.size.width/2, filterView.bounds.size.height + filterNameLabel.bounds.size.height);
        
		filterNameLabel.backgroundColor = [UIColor clearColor];
        filterNameLabel.textColor = [UIColor whiteColor];
        filterNameLabel.font = [UIFont fontWithName:kFontRalewayRegular size:10.0];
        filterNameLabel.textAlignment = NSTextAlignmentCenter;
		
		CGImageRef cgimg = nil;
		
		if (index == 0)
		{
			filterNameLabel.text =  @"Original";
			cgimg =  [context createCGImage:beginImage fromRect:[beginImage extent]];
		}
		else {
			Filter *filter = (Filter *) [filters objectAtIndex:index-1];
			filterNameLabel.text =  filter.name;
			CIImage *outputImage = [filter.filter outputImage];
			cgimg =  [context createCGImage:outputImage fromRect:[outputImage extent]];
		}
		
        UIImage *smallImage =  [UIImage imageWithCGImage:cgimg];
        
		//        if(smallImage.imageOrientation == UIImageOrientationUp)
		//        {
		//            smallImage = [smallImage imageRotatedByDegrees:90];
		//        }
		
        // create filter preview image views
        UIImageView *filterPreviewImageView = [[UIImageView alloc] initWithImage:smallImage];
        
        [filterView setUserInteractionEnabled:YES];
        
//        filterPreviewImageView.layer.cornerRadius = 15;
//		filterPreviewImageView.layer.borderWidth = 2.0f;
//		filterPreviewImageView.layer.borderColor = [UIColor blackColor].CGColor;
        filterPreviewImageView.opaque = NO;
        filterPreviewImageView.backgroundColor = [UIColor clearColor];
        filterPreviewImageView.layer.masksToBounds = YES;
        filterPreviewImageView.frame = CGRectMake(0, 0, 40, 40);
        
        filterView.tag = index;
		
        [self applyGesturesToFilterPreviewImageView:filterView];
        
        [filterView addSubview:filterPreviewImageView];
        [filterView addSubview:filterNameLabel];
        
        [self addSubview:filterView];
        
        offsetX += filterView.bounds.size.width + 10;
		
//		CFRelease(cgimg);
        
    }
    
	[self setContentSize:CGSizeMake(offsetX, CGRectGetHeight(self.frame))];
}

-(void) loadFiltersForImage:(UIImage *) image
{
    CIImage *filterPreviewImage = [[CIImage alloc] initWithImage:image];
    beginImage = filterPreviewImage;
	
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,filterPreviewImage,
                             @"inputIntensity",[NSNumber numberWithFloat:0.8],nil];
	
//    CIFilter *colorMonochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey,filterPreviewImage,
//								 @"inputColor",[CIColor colorWithString:@"Red"],
//                                 @"inputIntensity",[NSNumber numberWithFloat:0.8], nil];
	
	CIFilter *photoEffectChrome = [CIFilter filterWithName:@"CIPhotoEffectChrome" keysAndValues:kCIInputImageKey,filterPreviewImage, nil];
	
	CIFilter *photoEffectFade = [CIFilter filterWithName:@"CIPhotoEffectFade" keysAndValues:kCIInputImageKey,filterPreviewImage, nil];
	
	CIFilter *photoEffectInstant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues:kCIInputImageKey,filterPreviewImage, nil];
	
	CIFilter *photoEffectProcess = [CIFilter filterWithName:@"CIPhotoEffectProcess" keysAndValues:kCIInputImageKey,filterPreviewImage, nil];
	
	CIFilter *photoEffectTransfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues:kCIInputImageKey,filterPreviewImage, nil];
	
	CIFilter *photoEffectTonal = [CIFilter filterWithName:@"CIPhotoEffectTonal" keysAndValues:kCIInputImageKey,filterPreviewImage, nil];
	
	CIFilter *photoEffectNoir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues:kCIInputImageKey,filterPreviewImage, nil];
	
	CIFilter *photoEffectMono = [CIFilter filterWithName:@"CIPhotoEffectMono" keysAndValues:kCIInputImageKey,filterPreviewImage, nil];
	
	[filters removeAllObjects];
    filters = [[NSMutableArray alloc] init];
    
    [filters addObjectsFromArray:[NSArray arrayWithObjects:
                                  [[Filter alloc] initWithNameAndFilter:@"Sepia" filter:sepiaFilter],
								  [[Filter alloc] initWithNameAndFilter:@"Fade" filter:photoEffectFade],
								  [[Filter alloc] initWithNameAndFilter:@"Chrome" filter:photoEffectChrome],
								  [[Filter alloc] initWithNameAndFilter:@"Instant" filter:photoEffectInstant],
								  [[Filter alloc] initWithNameAndFilter:@"Process" filter:photoEffectProcess],
								  [[Filter alloc] initWithNameAndFilter:@"Transfer" filter:photoEffectTransfer],
								  [[Filter alloc] initWithNameAndFilter:@"Tonal" filter:photoEffectTonal],
								  [[Filter alloc] initWithNameAndFilter:@"Noir" filter:photoEffectNoir],
								  [[Filter alloc] initWithNameAndFilter:@"Mono" filter:photoEffectMono]
                                  , nil]];
    
    [self createPreviewViewsForFilters];
}

@end
