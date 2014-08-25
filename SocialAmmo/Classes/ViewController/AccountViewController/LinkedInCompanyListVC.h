//
//  LinkedInCompanyListVC.h
//  SocialAmmo
//
//  Created by Meenakshi on 08/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

typedef void (^LinkedInCompanyCompletedBlock) (NSUInteger index);


@interface LinkedInCompanyListVC : UIViewController
{
	IBOutlet UITableView*	_tableview;
	IBOutlet UIView*	_tableBackgroundView;
}
@property (nonatomic, strong)NSArray* companyList;

@property (nonatomic, copy) LinkedInCompanyCompletedBlock completion;

- (id)initWithCompletionBlock:(LinkedInCompanyCompletedBlock)block;

@end
