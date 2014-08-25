//
//  CreatorToolView.h
//  SocialAmmo
//
//  Created by Meenakshi on 17/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

@protocol CreatorToolDelegate <NSObject>

- (void) applyToolImageAtIndex:(NSInteger)imageIndex;

@end

@interface CreatorToolView : UIScrollView
{
	NSArray*	_toolArray;
	NSInteger _previousSelectedIndex;
}
@property(nonatomic, assign)id <CreatorToolDelegate> observer;

- (void) initalizeToolView:(NSArray*)tools withImage:(UIImage*)image withType:(EPackType)type;
- (void) updateBaseImage:(UIImage*)image;

@end
