//
//  BaseViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 25/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- bar Buttons

- (void) addBackButton
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"back arrow.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	button.frame = CGRectMake(0, 0, 60, 40);
	button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
	
	UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = backButton;
}

- (void) addNextButton
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"nextArrow.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	button.frame = CGRectMake(0, 0, 60, 40);
	button.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);

	UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = nextButton;
}

#pragma mark-

-(void) backButtonAction:(UIButton*)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) nextButtonAction:(UIButton*)sender
{
	
}

//Method used to animate view from center of Icon
- (void)popUpView:(UIView*)subView fromPoint:(CGPoint)iconPoint
{
	AppDelegate* appdlegate = _gAppDelegate;
    subView.center = iconPoint;
    [appdlegate.window addSubview:subView];
    
    subView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    [UIView animateWithDuration: KPOP_UP_IN_ICONS_DELAY
                          delay: 0
                        options: (UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
						 //  subView.center = newCenter;
						 
						 subView.transform = CGAffineTransformIdentity;
						 subView.frame = KDEFAULT_FRAME;
                     }
                     completion:^(BOOL finished) {}
     ];
}


@end
