//
//  LeftViewController.h
//  BidAbout
//
//  Created by     on 01/07/13.
//  Copyright (c) 2013 BolderImage. All rights reserved.
//

@interface LeftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray* _menuList;
//	IBOutlet UIView* _fotterView;
}

@property (nonatomic, retain) IBOutlet UITableView* leftTableView;

@end