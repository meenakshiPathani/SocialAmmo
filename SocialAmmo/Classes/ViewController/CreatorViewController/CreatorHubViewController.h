//
//  CreatorViewController.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/11/14.
//  Copyright (c) 2014 //  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BusinessOpenSubmissionInfo.h"

@interface CreatorHubViewController : BaseViewController
{
	IBOutlet UILabel*	_creatorLabel;
	
	IBOutlet UIView* _paymentActionView;
	IBOutlet UIView* _paymentBackgroundView;
	
	IBOutlet UIButton*	_createCanvasButton;

}
@property (nonatomic, strong)BusinessOpenSubmissionInfo* submissionInfo;

- (IBAction) creatorCanvasButtonAction:(id)sender;

- (IBAction) ammoCoinBtnAction:(id)sender;
- (IBAction) paymentBtnAction:(id)sender;
- (IBAction) cancelPaymentBtnAction:(id)sender;

@end
