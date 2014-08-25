//
//  ImportImageViewController.h
//  SocialAmmo
//
//  Created by Meenakshi on 21/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


typedef void (^ImportImageCompletionBlock) (UIImage* image);

@interface ImportImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
	
}
@property (nonatomic, copy) ImportImageCompletionBlock completion;
@property (nonatomic, strong) UINavigationController* navigationController;


- (id)initWithCompletionBlock:(ImportImageCompletionBlock)block;

- (IBAction) cameraButtonPressed:(id)sender;
- (IBAction) libraryButtonPressed:(id)sender;

@end
