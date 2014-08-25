//
//  UserTypeViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 02/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SignUpViewController.h"
#import "UserTypeViewController.h"

@interface UserTypeViewController ()

@end

@implementation UserTypeViewController

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


#pragma mark - Button Action

- (IBAction) userTypeButtonPressed:(UIButton*)sender
{
	EUserType userType = (EUserType)sender.tag;
	UserInfo* userInfo = [[UserInfo alloc] initWithUserType:userType];
	
	[self showSignUpScreenForUser:userInfo];
}

- (IBAction) backButtonPressed:(UIButton*)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-

- (void) showSignUpScreenForUser:(UserInfo*)info
{
	SignUpViewController* viewCtrl = [[SignUpViewController alloc] initWithNibName:@"SignUpView" bundle:nil];
	viewCtrl.userInfo = info;
	[self.navigationController pushViewController:viewCtrl animated:YES];
}

@end
