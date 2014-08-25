//
//  CaroselItemView.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


#import "CaroselItemView.h"

@implementation CaroselItemView

+ (id) createCaroselItemView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CaroselItemView"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) dealloc
{
	
}

#pragma mark -

- (void) setScreenData:(SubmissionInfo*)item lastIndex:(BOOL)isLastIndex
{
	if (!isLastIndex)
	{
		_infoView.hidden = NO;
		_specificCreateView.hidden = YES;
		
		_titleLabel.text = (item.isOpenSubmission) ? @"OPEN SUBMISSIONS" : item.submissionName;
		_viewsLabel.text =@"TCB";  //[NSString stringWithFormat:@"%d",item.viewCount];
		_subsLabel.text =  [NSString stringWithFormat:@"%lu", (unsigned long)item.submittedContentCount];
		_radiusLabel.text = [NSString stringWithFormat:@"%lukm", (unsigned long)item.radius];
	}
	else
	{
		_infoView.hidden = YES;
		_specificCreateView.hidden = NO;
	}
}

- (IBAction) settingButtonAction:(id)sender
{
	if ([self.delgate respondsToSelector:@selector(settingButtonTaped)])
		[self.delgate settingButtonTaped];
}

- (IBAction) createNewButtonaction:(id)sender
{
	if ([self.delgate respondsToSelector:@selector(createNewTaped)])
		[self.delgate createNewTaped];
}

@end
