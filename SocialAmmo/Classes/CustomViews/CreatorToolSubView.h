//
//  CreatorToolSubView.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/4/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "PackInfo.h"

@protocol CreatorToolSubViewDelegate <NSObject>

- (void) openPack:(PackInfo*)info;
- (void) buyPack:(PackInfo*)info;

@end

@interface CreatorToolSubView : UIView
{
    IBOutlet UIButton*  _openBtn;
    IBOutlet UIButton* _buyBtn;
	
	IBOutlet UILabel* _packName;
	IBOutlet UILabel* _brandName;
	
	IBOutlet AsyncImageView* _packImageV;
	IBOutlet UIImageView* _lockImageV;

	
	PackInfo*	_packInfo;
}

@property (nonatomic, assign) id<CreatorToolSubViewDelegate> delgate;

+ (id) createCreatorToolSuBView;

- (void) setOrigin:(CGPoint)point;
- (void) setScreenData:(PackInfo*)item;

- (IBAction) openBtnAction:(id)sender;
- (IBAction) buyBtnAction:(id)sender;
- (void) displayOpenBtn;

@end
