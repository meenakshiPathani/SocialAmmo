//
//  CreatorBeaconView.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 8/20/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CreatorBeaconPageView.h"
#import "BusinessOpenSubmissionInfo.h"

@implementation CreatorBeaconPageView


- (id) initWithPageNumber:(NSUInteger)pageNumber
{
	self = [[[NSBundle mainBundle] loadNibNamed:[UIUtils iphoneScreenName:@"CreatorBeaconPageView"]
										  owner:self options:nil] objectAtIndex:0];
    if (self)
	{
		self.pageNumber = pageNumber;
    }
    return self;
}

- (void) setOpenSubmissionDetails:(BusinessOpenSubmissionInfo*)obj
{
	self.businessSubInfo = obj;
	
	_profileImageView.hidden = YES;
	_profileImageView.layer.borderColor = kBlueColor.CGColor;
	_profileImageView.layer.borderWidth = 5.0f;
	_profileImageView.layer.cornerRadius = CGRectGetWidth(_profileImageView.frame)/2;
	_profileImageView.clipsToBounds = YES;
	
	//	_seenImageView.hidden = !_openSubmisisonInfo.isSeen;
	//	_hideButton.hidden = NO;
	
	NSString* specificCount = [NSString stringWithFormat:@"%lu",(unsigned long)obj.specificSubmisisonCount];
	[_specificBtn setAttributedTitle:[self getAttritibutedTitleWithnumber:specificCount] forState:UIControlStateNormal];
	_indicaterlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)obj.unseenSpecificSubmisisonCount];
	
	_creaternameLbl.text = obj.name;
	_createrContentLbl.text = obj.description;
	_locationlabel.text = [NSString stringWithFormat:@"%.2f km",obj.distance];
	_specificUnseenLabel.text = [NSString stringWithFormat:@"%d",obj.unseenSpecificSubmisisonCount];
	
	_profileImageView.hidden = NO;
	_profileImageView.imageUrl = obj.profilePicUrl;
	[_profileImageView becomeActive];
	
	//UIBezierPath* exclusionPath = [UIBezierPath bezierPathWithOvalInRect:_logoSpaceImageView.frame];
	//_creaternameTextV.textContainer.exclusionPaths  = @[exclusionPath];
	//_createrContentTextV.textContainer.exclusionPaths  = @[exclusionPath];
}

#pragma mark-

// calculates the radius of the circle that surrounds the label
- (float) radiusToSurroundFrame:(CGRect)frame
{
    return MAX(frame.size.width, frame.size.height) * 0.5 + 20.0f;
}

- (UIBezierPath *)curvePathWithOrigin:(CGPoint)origin
{
    return [UIBezierPath bezierPathWithArcCenter:origin
                                          radius:[self radiusToSurroundFrame:_logoSpaceImageView.frame]
                                      startAngle:-180.0f
                                        endAngle:180.0f
                                       clockwise:YES];
    
}

- (NSAttributedString*) getAttritibutedTitleWithnumber:(NSString*)str
{
	NSMutableAttributedString* numberStr  = [[NSMutableAttributedString alloc] initWithString:str
											 attributes:@{NSFontAttributeName:[UIFont fontWithName: kFontRalewayExtraBold size:20.0f]}];
	
	NSAttributedString* specificStr = [[NSAttributedString alloc] initWithString:@" specific" attributes:@{NSFontAttributeName:[UIFont fontWithName: kFontRalewayBold size:14.0f]}];
	
	[numberStr appendAttributedString:specificStr];
	
	return  numberStr;
}

#pragma mark --
#pragma mark -- Button action

- (IBAction) hideBtnAction:(id)sender
{
	if ([self.delgate respondsToSelector:@selector(handlehideAction:)])
		[self.delgate handlehideAction:self.businessSubInfo.businessId];
}

- (IBAction) createBtnAction:(id)sender
{
	if ([self.delgate respondsToSelector:@selector(handleCreateAction:)])
		[self.delgate handleCreateAction:self.businessSubInfo];
}

- (IBAction) specificBtnAction:(id)sender
{
	[UIUtils messageAlert:@"Work in Progress" title:nil delegate:nil];
}

- (void) cleanUp
{
	_logoSpaceImageView.image = nil;
	_profileImageView.image = nil;
}


@end
