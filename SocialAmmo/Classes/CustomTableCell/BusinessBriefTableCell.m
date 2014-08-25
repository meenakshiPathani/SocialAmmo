//
//  BusinessBriefTableCell.m
//  Social Ammo
//
//  Created by Meenakshi on 04/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SABlurView.h"

#import "BusinessBriefTableCell.h"

@implementation BusinessBriefTableCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark-

- (void) setBriefInfoInCell:(BriefInfo*)info index:(NSUInteger)index
{
	self.briefInfo = info;

	_backgroundView.layer.cornerRadius = 4.0f;
	NSString* briefTitle = [UIUtils checknilAndWhiteSpaceinString:info.briefTitle];
	NSLog(@"****** %@ *********", briefTitle);
	_briefLabel.text = [NSString stringWithFormat:@"%lu. %@", (unsigned long)index, briefTitle];
	
	_newSubmissionLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.newSubmission];
	_creditLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.credit];
	_acceptedLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.accepted];
	_declineLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.declined];
	
	_submissionNotifImageView.hidden = !info.newSubmissionNotification;
	_creditNotifImageView.hidden = !info.creditNotification;
	_acceptNotifImageView.hidden = !info.acceptContentNotification;
	_declineNotifImageView.hidden = !info.declineContentNotification;

}

#pragma mark - Delegate Methods

- (IBAction) briefInfoButtonPressed:(UIButton*)sender
{
	if ([self.delegate respondsToSelector:@selector(briefBtnActionWithType:forBrief:)])
		[self.delegate briefBtnActionWithType:(EBriefAction)sender.tag forBrief:self.briefInfo];
}

- (IBAction) briefSettingButtonPressed:(id)sender
{
	[UIUtils messageAlert:@"Work in progress." title:nil delegate:nil];
}


@end
