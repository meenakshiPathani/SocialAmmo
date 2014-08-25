//
//  BusinessBriefTableCell.h
//  Social Ammo
//
//  Created by Meenakshi on 04/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BriefInfo.h"

@protocol BusinessBriefTableCellDelegate <NSObject>

- (void) briefBtnActionWithType:(EBriefAction)briefactiontype forBrief:(BriefInfo*)breifInfo;

@end

@interface BusinessBriefTableCell : UITableViewCell
{
	IBOutlet UIView*	_backgroundView;
	IBOutlet UIView*	_topBlueView;
	IBOutlet UIView*	_bottomView;

	IBOutlet UILabel*	_briefLabel;
	
	IBOutlet UILabel*	_newSubmissionLabel;
	IBOutlet UILabel*	_creditLabel;
	IBOutlet UILabel*	_acceptedLabel;
	IBOutlet UILabel*	_declineLabel;
	
	IBOutlet UIImageView* _submissionNotifImageView;
	IBOutlet UIImageView* _creditNotifImageView;
	IBOutlet UIImageView* _acceptNotifImageView;
	IBOutlet UIImageView* _declineNotifImageView;
}

@property (nonatomic, strong) BriefInfo* briefInfo;

@property(nonatomic, weak)id <BusinessBriefTableCellDelegate> delegate;

- (void) setBriefInfoInCell:(BriefInfo*)info index:(NSUInteger)index;

- (IBAction) briefInfoButtonPressed:(id)sender;
- (IBAction) briefSettingButtonPressed:(id)sender;


@end
