//
//  ImportImageViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 21/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ImportImageViewController.h"

@interface ImportImageViewController ()

@end

@implementation ImportImageViewController

- (id)initWithCompletionBlock:(ImportImageCompletionBlock)block
{
    self = [super initWithNibName:kImportImageViewNib bundle:nil];
    if (self) {
        // Custom initialization
		self.completion = block;
    }
    return self;
}

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
	
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]
										  initWithTarget:self action:@selector(handleTapGesture:)];
	[self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark -- Button action

- (IBAction) cameraButtonPressed:(id)sender;
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		[self openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction) libraryButtonPressed:(id)sender;
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
		[self openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark-

- (void) openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
	UIImagePickerController* cameraCtrl = [[UIImagePickerController alloc] init];
	cameraCtrl.delegate = self;
	cameraCtrl.sourceType = sourceType;
	cameraCtrl.allowsEditing = NO;
	[self.navigationController presentViewController:cameraCtrl animated:YES completion:NULL];
}

#pragma mark UIImagePickerController delgate-

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* chosenImage = info[UIImagePickerControllerOriginalImage];
	
	CGRect rect = [[UIScreen mainScreen] bounds];
	chosenImage = [UIUtils scaleImage:chosenImage inRect:rect proportionally:YES];
	
//	_editngImageView.image = chosenImage;
//	
//	if (chosenImage)
//	{
//		[self hideAnimatedForView:_cameraSheetView];
//		[self showHideTollViewAnimation];
//	}
	
	[picker dismissViewControllerAnimated:NO completion:^{
		// Hide the action sheet view
		self.completion(chosenImage);
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:NO completion:^{
		// Hide the action sheet view
		self.completion(nil);
	}];
}

#pragma mark-

- (void) handleTapGesture:(UITapGestureRecognizer*)gestureRecognizer
{
	[self.view removeFromSuperview];
}

@end
