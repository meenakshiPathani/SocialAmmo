//
//  LayerListViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "LayerTableViewCell.h"
#import "LayerListViewController.h"

@interface LayerListViewController () <LayerTableViewCellDelegate>
{
	CGFloat		_yOffset;
	
}

@end

@implementation LayerListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	UINib* nib = [UINib nibWithNibName:kLayerTableCellNib bundle:[NSBundle mainBundle]];
	[self.tableview registerNib:nib forCellReuseIdentifier:@"LayerTableCell"];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self adjustLayoutOfView];

	[self.tableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Button action

- (IBAction) doneButtonPressed:(id)sender
{
	[self.view removeFromSuperview];
}

#pragma mark- Tableview method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.layerList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"LayerTableCell";
	LayerTableViewCell* cell = (LayerTableViewCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	cell.contentView.backgroundColor = [UIColor clearColor];
	cell.delegate = self;
	
	LayerInfo* info = [self.layerList objectAtIndex:indexPath.row];
	[cell initaiteLayerCell:info withTag:indexPath.row];

	[cell.deleteLayerButton addTarget:self action:@selector(deleteLayerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	return  cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// here we get the cell from the selected row.
	LayerTableViewCell *selectedCell = (LayerTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
	
	selectedCell.hidenEyeButton.hidden = YES;
	selectedCell.showLayerButton.hidden = NO;
	
	LayerInfo* info = [self.layerList objectAtIndex:indexPath.row];
	info.showLayer = YES;
		
	if ([self.delegate respondsToSelector:@selector(activateTheLayerAtIndex:)])
		[self.delegate activateTheLayerAtIndex:info.layerTag];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return _tableHeaderView;
}

#pragma mark --

- (void) adjustLayoutOfView
{
	NSUInteger count = self.layerList.count;
	NSUInteger height = 60 * count + _tableHeaderView.frame.size.height;
	
	CGFloat maxHeight = kIPhone5 ? 200 : 160;
	CGRect rect = self.tableview.frame;
	rect.size.height = MIN(height, maxHeight);
	self.tableview.frame = rect;
	
	rect = self.view.frame;
	rect.origin.y -= self.tableview.frame.size.height - self.view.frame.size.height;

	rect.size.height = self.tableview.frame.size.height;
	
	self.view.frame = rect;
}


#pragma mark-

- (IBAction) deleteLayerButtonPressed:(UIButton*)sender
{
	LayerInfo* info = [self.layerList objectAtIndex:sender.tag];
	NSUInteger layerIndex = info.layerTag;

	[self.layerList removeObjectAtIndex:sender.tag];
	[self adjustLayoutOfView];
	[self.tableview reloadData];
		
	if ([self.delegate respondsToSelector:@selector(removeLayer:)])
		[self.delegate removeLayer:layerIndex];
}


- (void) handleShowButtonTap:(UIButton*)sender
{
	LayerInfo* info = [self.layerList objectAtIndex:sender.tag];
	
	if ([self.delegate respondsToSelector:@selector(showLayer:atIndex:)])
		[self.delegate showLayer:NO atIndex:info.layerTag];
}

- (void) handleHideButtonTap:(UIButton*)sender
{
	LayerInfo* info = [self.layerList objectAtIndex:sender.tag];
	
	if ([self.delegate respondsToSelector:@selector(showLayer:atIndex:)])
		[self.delegate showLayer:YES atIndex:info.layerTag];
}

- (void) updateLayerList:(NSMutableArray*)list
{
	self.layerList = list;
	[self.tableview reloadData];
	
	[self adjustLayoutOfView];
}

@end
