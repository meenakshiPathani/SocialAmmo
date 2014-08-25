//
//  CaroselItemView.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CaroselItemViewDelegate <NSObject>

- (void) settingButtonTaped;
- (void) createNewTaped;

@end

@interface CaroselItemView : UIView
{
	IBOutlet UILabel* _titleLabel;
	IBOutlet UILabel* _viewsLabel;
	IBOutlet UILabel* _subsLabel;
	IBOutlet UILabel* _radiusLabel;
	
	IBOutlet UIView* _specificCreateView;
	IBOutlet UIView* _infoView;
}

@property (nonatomic, assign) id<CaroselItemViewDelegate> delgate;

+ (id) createCaroselItemView;
- (void) setScreenData:(SubmissionInfo*)item lastIndex:(BOOL)isLastIndex;

@end
