//
//  LinkedInCompanyListVC.m
//  SocialAmmo
//
//  Created by Meenakshi on 08/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "LinkedInCompanyListVC.h"

#define kMaxHeightForCompanyList 300

@interface LinkedInCompanyListVC ()

@end

@implementation LinkedInCompanyListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCompletionBlock:(LinkedInCompanyCompletedBlock)block
{
    self = [super initWithNibName:kLinkedInCompanyListViewNib bundle:nil];
    if (self) {
        // Custom initialization
		self.completion = block;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self prepareLayoutOfCompanyList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault ;
}

#pragma mark --
#pragma mark -- TableView Data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.companyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString* cellIdentifier = @"cell";
	
	UITableViewCell* cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:
															  cellIdentifier];
	cell.backgroundColor = [UIColor clearColor];
	
	NSDictionary* dict = [self.companyList objectAtIndex:indexPath.row];
	cell.textLabel.text = [dict objectForKey:@"name"];
			
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"didSelectRowAtIndexPath");
	
	[self.view removeFromSuperview];
	self.completion(indexPath.row);
}

#pragma mark-

- (void) prepareLayoutOfCompanyList
{
	CGFloat height = self.companyList.count * 50;
	height = MIN(height, kMaxHeightForCompanyList);
	
	CGRect rect = _tableBackgroundView.frame;
	rect.size.height = height;
	_tableBackgroundView.frame = rect;
	
	rect = _tableBackgroundView.frame;
	rect.size.height = CGRectGetHeight(_tableBackgroundView.frame) + 10;
	rect.origin.y = (CGRectGetHeight(self.view.frame) - CGRectGetHeight(_tableBackgroundView.frame))/2;
	
	_tableBackgroundView.frame = rect;
}

@end
