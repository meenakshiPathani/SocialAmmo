//
//  CreatorToolSubView.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/4/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CreatorToolSubView.h"

@implementation CreatorToolSubView

+ (id) createCreatorToolSuBView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CreatorToolSubView"
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

- (void) setOrigin:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

#pragma mark -

- (void) setScreenData:(PackInfo*)item
{
	self.tag = item.packId;
	
	_packImageV.image = nil;
	_packImageV.imageUrl = item.packIconUrl;
	[_packImageV becomeActive];
	
	_packInfo = item;
	
	// set Title Names
	_packName.text = item.packName;
	_brandName.attributedText = [self getBrandName:item.brandName];
	
	// Handle btn display
	(item.purchase)?[self displayOpenBtn]:[self displayBuyBtn];
	
	//(NO)?[self displayOpenBtn]:[self displayBuyBtn];
}

- (void) displayBuyBtn
{
	_buyBtn.hidden = NO;
	_openBtn.hidden = YES;
	_lockImageV.hidden = NO;
	
//	[_buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
	
	if (_packInfo.free)
	{
		[_buyBtn setTitle:@"Free" forState:UIControlStateNormal];
	}
	else
	{
		NSString* coin = [NSString stringWithFormat:@"%lu",(unsigned long)_packInfo.coin];
		NSString* cost = [NSString stringWithFormat:@"%lu",(unsigned long)_packInfo.cost];
		
		// Set  buy Button Title
		NSAttributedString* buyrBtnTitle = [self getBuyCreditlabel:coin witCreditInDolor:cost];
		
		[_buyBtn setAttributedTitle:buyrBtnTitle forState:UIControlStateNormal];
	}
}

- (void) displayOpenBtn
{
	_buyBtn.hidden = YES;
	_openBtn.hidden = NO;
	
	_lockImageV.hidden = YES;
}


#pragma  mark-- Get Attributed Detail

- (NSAttributedString*) getBrandName:(NSString*)brandName
{
	NSMutableAttributedString*byStr  = [[NSMutableAttributedString alloc] initWithString:@"by "
										attributes:@{NSForegroundColorAttributeName: [UIColor
										darkGrayColor],NSFontAttributeName:[UIFont fontWithName:
										kFontRalewayBold size:9.0f]}];
	
	NSAttributedString* brandNameStr = [[NSAttributedString alloc] initWithString:brandName
										attributes:@{NSForegroundColorAttributeName:
										[UIColor blackColor],NSFontAttributeName:
										[UIFont fontWithName:kFontRalewayBold size:9.0f]}];
	
	[byStr appendAttributedString:brandNameStr];
	
	return  byStr;
}

- (NSAttributedString*) getBuyCreditlabel:(NSString*)creditValue witCreditInDolor:(NSString*)dolorTxt
{
	NSString* dolorCreidt = [NSString stringWithFormat:@"(or $%@)",dolorTxt];
	NSString* creditText = [NSString stringWithFormat:@"%@ %@",creditValue,dolorCreidt];
	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:
												 creditText  attributes:nil];
	
	UIColor *creditColor = [UIColor whiteColor];
    // Credit text attributes
    NSRange credittextRange = [creditText rangeOfString:creditValue];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:creditColor,
									NSFontAttributeName:[UIFont fontWithName:kFontRalewayBold
									size:10.0f]}  range:credittextRange];
	
	// dolor text attributes
    NSRange dolortextRange = [creditText rangeOfString:dolorCreidt];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:creditColor, NSFontAttributeName:
									[UIFont fontWithName:kFontRalewayBold size:11.0f]}
							       range:dolortextRange];
	
	return  attributedText;
}

#pragma  mark -- Button Action

- (IBAction) openBtnAction:(id)sender
{
	if ([self.delgate respondsToSelector:@selector(openPack:)])
		[self.delgate openPack:_packInfo];
}

- (IBAction) buyBtnAction:(id)sender
{
	if ([self.delgate respondsToSelector:@selector(buyPack:)])
		[self.delgate buyPack:_packInfo];
}

@end
