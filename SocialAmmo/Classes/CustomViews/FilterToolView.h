//
//  FilterToolView.h
//  DemoFilterApp
//
//  Created by Meenakshi on 09/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

@protocol FilterToolDelegate <NSObject>

- (void) applyFilterImage:(UIImage*)image;

@end

@interface FilterToolView : UIScrollView
{
	CIContext *context;
    NSMutableArray *filters;
    CIImage *beginImage;
    UIView *selectedFilterView;
    UIImage *finalImage;
}
@property(nonatomic, assign)id <FilterToolDelegate> observer;

-(void) loadFiltersForImage:(UIImage *) image;

@end
