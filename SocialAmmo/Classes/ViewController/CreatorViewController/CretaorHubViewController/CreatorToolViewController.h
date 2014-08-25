//
//  CreatorToolViewController.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/4/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "PackInfo.h"

@protocol CreatorToolViewDelegate <NSObject>

- (void) displayCanvasForPack:(PackInfo*)pack;
- (void) displayPurchaseSheetForPack:(PackInfo*)pack;
- (void) installFreePack:(PackInfo*)pack;


@end

@interface CreatorToolViewController : UIViewController
{
	IBOutlet UIScrollView* _scrollView;
	
	IBOutlet UIView* _bottomView;
	IBOutlet UIButton* _herebtn;
	IBOutlet UIView* _underlineview;
	
	PackInfo*	_packInfo;
}
@property (nonatomic, weak)id<CreatorToolViewDelegate> observer;

- (void) updateToolWithPackInfo:(PackInfo*)pack;

@end
