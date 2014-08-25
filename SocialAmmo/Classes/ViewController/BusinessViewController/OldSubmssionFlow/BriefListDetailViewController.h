//
//  BriefListDetailViewController.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/20/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

typedef void (^BriefListDetailCompletionBlock) (void);

@interface BriefListDetailViewController : BaseViewController
{
	IBOutlet UITableView* _listTableView;
	
	IBOutlet UIView*	_paymentAlertBackgroundView;
	IBOutlet UIView*	_paymentAlertView;
	IBOutlet UILabel*	_paymentAlertLabel;
}

@property (nonatomic, copy) BriefListDetailCompletionBlock completion;

- (id)initWithCompletionBlock:(BriefListDetailCompletionBlock)block;


@end
