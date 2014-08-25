//
//  LayerListViewController.h
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

@protocol LayerListViewDelegate <NSObject>

- (void) removeLayer:(NSUInteger)layerIndex;
- (void) showLayer:(BOOL)show atIndex:(NSUInteger)layerIndex;
- (void) activateTheLayerAtIndex:(NSUInteger)index;

@end


@interface LayerListViewController : UIViewController
{	
	IBOutlet UIView*		_tableHeaderView;
}
@property (nonatomic, assign)CGFloat yOffset;

@property (nonatomic, strong) IBOutlet UITableView* tableview;
@property(nonatomic, weak)id<LayerListViewDelegate> delegate;

@property(nonatomic, strong)NSMutableArray* layerList;

- (IBAction) doneButtonPressed:(id)sender;

- (void) adjustLayoutOfView;
- (void) updateLayerList:(NSMutableArray*)list;

@end
