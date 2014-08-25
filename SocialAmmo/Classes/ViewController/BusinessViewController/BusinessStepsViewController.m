//
//  BusinessStepsViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 14/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SubmissionInfo.h"
#import "InterestInfo.h"
//#import "MKMapView+ZoomLevel.h"

#import "BusinessStepsViewController.h"

#define kRadiusMinValue 2
#define kRadiusMaxValue 1558

#define kSliderDefaultValue 778



@interface BusinessStepsViewController () <BusinessViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
	NSUInteger		_radius;
	
	NSString*	_businessName;
	NSString*	_businessDescription;
	
	CGSize			_scrollViewContentSize;

	UITextView*		_currentTextView;
	
	UIView*	_selectedInterestView;
	
	NSMutableArray*	_selectedInterstIdArray;
	
	UserInfo*		_userInfo;
	
	CGPoint _lastContentOffSet;
}

@end

@implementation BusinessStepsViewController

- (id)initWithCompletionBlock:(BusinessStepsCompletionBlock)block
{
    self = [super initWithNibName:kBuinessStepsViewNib bundle:nil];
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

	_radius = kSliderDefaultValue;
	_selectedRadiusLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_radius];
	
	_userInfo = _gDataManager.userInfo;
	_businessIndustryLabel.text = _userInfo.businessInfo.businessName;
	
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
	
	_mapBackgroundView.layer.cornerRadius = 8.0f;
	_mapView.showsUserLocation = YES;
	
	CGFloat height = (kIPhone5) ? 490 : 405;
	CGRect rect = CGRectMake(0, 0, 320, height);
	_contentView.frame = rect;
	[_contentView addSubview:_pageOne];
	
	_pageOne.contentSize = CGSizeMake(320, 490);
	_pageOne.frame = rect;

	_pageTwo.contentSize = CGSizeMake(320, 490);
	_pageTwo.frame = rect;
	
	_pageThree.contentSize = CGSizeMake(320, 490);
	_pageThree.frame = rect;
	
	[_gAppDelegate registerKeyboardNotifications:self];
	_slider.maximumTrackTintColor = [UIColor blackColor];
	[_slider setThumbImage:[UIImage imageNamed:@"doneicon.png"] forState:UIControlStateNormal];
	_slider.thumbTintColor = GET_COLOR(59, 183, 201, 1.0);
	
	[_interestScrollView flashScrollIndicators];

	[self prepareLayoutForFirstStep];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	_slider.value = kSliderDefaultValue;
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
	[_gAppDelegate unregisterKeyboardNotifications:self];

}

#pragma mark-

- (IBAction) radiusSliderValueChanged:(id)sender
{
	UISlider* slider = (UISlider*)sender;
	_radius = slider.value;

	_selectedRadiusLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_radius];
	NSLog(@"%lu",(unsigned long)_radius);
		
	[self addCircleOverlay:_mapView.userLocation.location];
	[self sendRequesToGetCreatorCountBasedOnRadius:_radius];
//	_pageTwo.scrollEnabled = YES;
}

- (IBAction) didtouchSlider:(id)sender
{
//	_pageTwo.scrollEnabled = NO;
}

//- (void) moveToAtPageIndex:(NSUInteger)pageIndex
//{
////	[_scrollView setContentOffset:CGPointMake(pageIndex * 320.0, _scrollView.contentOffset.y) animated:YES];
//}

- (IBAction) nextButtonOfStep1Pressed:(id)sender
{
	if ([_currentTextView isFirstResponder])
		[_currentTextView resignFirstResponder];
	
	[self addSubViewWithEffect:_pageTwo removedView:_pageOne];
		
	[self sendRequesToGetCreatorCountBasedOnRadius:_radius];
}

- (IBAction) nextButtonOfStep2Pressed:(id)sender
{
	[self addSubViewWithEffect:_pageThree removedView:_pageTwo];

	[self prepareLayoutForThirdStep];
}

- (IBAction) beginButtonPressed:(id)sender
{
	if (_selectedInterstIdArray.count == 0)
	{
		[UIUtils messageAlert:@"Please select the interest." title:nil delegate:nil];
		return;
	}
	
	[self sendRequestToCreateOpenSubmission];
}

- (void) addSubViewWithEffect:(UIScrollView*)addingView removedView:(UIScrollView*)removingView
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_contentView.layer addAnimation:transition forKey:nil];
	
	[removingView removeFromSuperview];
	[_contentView addSubview:addingView];
}

#pragma mark-

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat y = scrollView.contentOffset.y;
	NSLog(@"scrollViewDidScroll %f",y);
	
	
//	if(scrollView.tag == _scrollView.tag)
//	{
//		if (_lastContentOffSet.x != _scrollView.contentOffset.x || (_scrollView.contentOffset.x != _pointX))
//		{
//			_lastContentOffSet = CGPointMake(_pointX, _scrollView.contentOffset.y);
//			[_scrollView setContentOffset: _lastContentOffSet animated:NO];
//		}
//	}
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//	NSLog(@"dsds 2 %ld",(long)scrollView.tag);
//}

#pragma mark- MapView delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 200000, 200000);
//	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 500, 500);
//    [_mapView setRegion:region animated:NO];
	
	[self addCircleOverlay:userLocation.location];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    renderer.strokeColor = [UIColor redColor];
	renderer.lineWidth = 2.0;
//	renderer.fillColor = [UIColor yellowColor];
    return renderer;
}

#pragma mark-

- (void) addCircleOverlay:(CLLocation*)userLocation
{
	NSArray* overlays = _mapView.overlays;
	[_mapView removeOverlays:overlays];
	
	CGFloat radiusInMeter = _radius * 1000;
	[self zoomToRadius:radiusInMeter withLocation:userLocation];
	
	MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:radiusInMeter];
	[_mapView addOverlay:circle];
	[_mapView setCenterCoordinate:userLocation.coordinate animated:YES];
	
//	[_mapView calSetCenterCoordinate:userLocation.coordinate zoomLevel:_radius animated:YES];
}

- (void) zoomToRadius:(CGFloat)radius withLocation:(CLLocation*)userLocation
{
	double miles = MetersToMiles(radius);
	double scalingFactor = ABS( (cos(2 * M_PI * userLocation.coordinate.latitude / 360.0) ));
	
	MKCoordinateSpan span;
	
	span.latitudeDelta = miles/69.0;
	span.longitudeDelta = miles/(scalingFactor * 69.0);
	
	MKCoordinateRegion region;
	region.span = span;
	region.center = userLocation.coordinate;
	
	[_mapView setRegion:region animated:NO];
}

float MetersToMiles(float meter) {
    // 1 mile is 1609.344 meters
    // source: http://www.google.com/search?q=1+mile+in+meters
    return meter * 0.000621371192f;
}

#pragma mark-

- (void) prepareLayoutForThirdStep
{
	if (_gDataManager.interestList.count == 0)
		[self sendRequestToGetInterestList];
	else
		[self prepareLayoutOfInterestScrollview];

}

-(void) sendRequestToGetInterestList
{
	[_gDataManager sendRequestForQuickInterestWithCompletion:^(BOOL status, NSString* message, ERequestType requestType){
		if (status)
			[self prepareLayoutOfInterestScrollview];
	}];
}

- (void) prepareLayoutOfInterestScrollview
{
	[self clearLayoutOfInterestScrollview];
	
	NSArray* interestList = _gDataManager.interestList;
	
	_selectedInterstIdArray = [[NSMutableArray alloc] initWithCapacity:interestList.count];

	int x = 0, y = 5, width = 100, height = 130;
	for (InterestInfo* info in interestList)
	{
		UIView* view = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
				
		UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0, 0, width, height);
		button.tag = info.interestId;
		[button addTarget:self action:@selector(interestButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[view addSubview:button];
		
		UIImage* image = [UIImage imageNamed:@"bullet.png"];
		UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = CGRectMake(4, 0, image.size.width, image.size.height);
		[view addSubview:imageView];
		
		CGRect rect = CGRectMake(0, image.size.height, width, height - image.size.height);
		UILabel* label = [UIUtils createLabelWithText:info.name frame:rect];
		label.textAlignment = NSTextAlignmentCenter;
		label.lineBreakMode = NSLineBreakByWordWrapping;
		label.numberOfLines = 2;
		[view addSubview:label];
		
		[_interestScrollView addSubview:view];
				
		x = x+ width + 10;
	}
	
	_interestScrollView.contentSize = CGSizeMake(x, CGRectGetHeight(_interestScrollView.frame));
	
}

- (void) clearLayoutOfInterestScrollview
{
	NSArray* subviewArray = _interestScrollView.subviews;
	
	for (UIView* view in subviewArray)
		[view removeFromSuperview];
}

#pragma mark-

- (void) prepareLayoutForFirstStep
{
	_businessView.delegate = self;
	[_businessView displayBusinessInfo:_gDataManager.userInfo];
}

#pragma mark -- BusinessView Delegate

- (void) beginEditing:(UITextView*)textView
{
	_currentTextView = textView;
	
	if (textView.tag == 1)
	{
		if ([textView.text isEqual:_userInfo.businessName])
			textView.text = @"";
	}
	else if (textView.tag == 2)
	{
		if ([textView.text isEqual:@"Hi, we are a business and we have yet to write three lines about us."])
			textView.text = @"";
	}
	
	//if(!kIPhone5)
	{
		CGFloat offset = (kIPhone5) ? 80 : 0;
		int y = CGRectGetHeight(textView.frame) + CGRectGetMinY(textView.frame) - offset;
		[_pageOne setContentOffset:CGPointMake(0, y) animated:YES];
	}
}

- (void) endEditing:(UITextView*)textView
{
//	_scrollView.contentOffset = CGPointZero;
	
	NSString* text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (textView.tag == 1)
	{
		if (text.length == 0)
			textView.text = _userInfo.businessName;
	}
	else if (textView.tag == 2)
	{
		if (text.length == 0)
			textView.text = @"Hi, we are a business and we have yet to write three lines about us.";
	}
	
	if (textView.tag == 1) // buisness name
		_businessName = text;
	else if (textView.tag == 2) // business description
		_businessDescription = text;
	
}

- (void) selectImageAction
{
	[self displayActionSheet];
}

- (void) displayActionSheet
{
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Library", nil];
	[actionSheet showInView:self.view];
}

#pragma mark --
#pragma mark -- Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
				[self openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
			break;
		case 1:
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
				[self openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
			break;
		default:
			break;
	}
	[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark-

- (void) openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
	UIImagePickerController* cameraCtrl = [[UIImagePickerController alloc] init];
	cameraCtrl.delegate = self;
	cameraCtrl.sourceType = sourceType;
	cameraCtrl.allowsEditing = NO;
	[self.homeVC presentViewController:cameraCtrl animated:YES completion:NULL];
}

#pragma mark UIImagePickerController delgate-

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage* chosenImage = info[UIImagePickerControllerOriginalImage];
	CGRect rect = [[UIScreen mainScreen] bounds];
	chosenImage = [UIUtils scaleImage:chosenImage inRect:rect proportionally:YES];
	
	if (chosenImage)
	{
		[_businessView setBusinessImageViewWithImage:chosenImage];
	}
	
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - keyboard notifications

- (void)keyboardWillShow:(NSNotification*)notification
{
	NSDictionary* userInfo = [notification userInfo];
	CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	rect = [self.view convertRect:rect fromView:nil];
	NSTimeInterval animationDuration = [[userInfo objectForKey:
										 UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	
	[UIView animateWithDuration:animationDuration animations:^{
		
		_scrollViewContentSize = _pageOne.contentSize;
		_pageOne.contentSize = CGSizeMake(_scrollViewContentSize.width, _scrollViewContentSize.height + rect.size.height);
	}];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
	NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:
										 UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	
	[UIView animateWithDuration:animationDuration animations:^{
		
		_pageOne.contentSize = _scrollViewContentSize;
	}];
}

#pragma mark-

- (void) handleTapGesture:(UITapGestureRecognizer*)gesture
{
	[self.view endEditing:YES];
}

- (void) interestButtonPressed:(UIButton*) sender
{
	NSString* interestId = [NSString stringWithFormat:@"%ld", (long)sender.tag];
	
	UIView* view = sender.superview;

	if ([self checkInterestIdExist:sender.tag])
	{
		view.layer.shadowRadius = 0.0f;
		view.layer.shadowOpacity = 0.0f;
		
		[_selectedInterstIdArray removeObject:interestId];
	}
	else
	{
		view.layer.shadowColor = kBlueColor.CGColor;
		view.layer.shadowRadius = 3.0f;
		view.layer.shadowOpacity = 1.0f;
		view.layer.shadowOffset = CGSizeZero;
		view.layer.masksToBounds = NO;
		
		[_selectedInterstIdArray addObject:interestId];
	}
}

- (BOOL) checkInterestIdExist:(NSUInteger)interestId
{
	for (NSString* interest in _selectedInterstIdArray) {
		if ([interest integerValue] == interestId)
			return YES;
	}
	
	return NO;
}

#pragma mark -

- (void) sendRequestToCreateOpenSubmission
{
	SubmissionInfo* info = [self createSubmissionObject];
	
	[_gDataManager sendRequestToSaveSubmission:info withCompletion:^(BOOL status, NSString* message, ERequestType requestType){
		
		if (status)
		{
			[self.view removeFromSuperview];
			self.completion();
		}
		else
		{
			[UIUtils messageAlert:message title:nil delegate:nil];
		}
	}];
}


- (SubmissionInfo*) createSubmissionObject
{
	SubmissionInfo* info = [[SubmissionInfo alloc] initWithSubmissionType:EOpenSubmission];
	info.submissionName =  (_businessName.length > 0) ? _businessName : _gDataManager.userInfo.businessName;
	if (_businessDescription.length == 0)
		info.submissionDescription = @"Hi, we are a business and we have yet to write three lines about us.";
	else
		info.submissionDescription = _businessDescription;
	info.radius = _radius;
	info.selectedInterestIds = [[NSArray alloc] initWithArray:_selectedInterstIdArray];
	info.logoImage = _businessView.profileImageV.image;
	
	return info;
}

- (void) sendRequesToGetCreatorCountBasedOnRadius:(NSUInteger)radius
{
	[_gDataManager sendRequestToSearchUser:EUserTypeCreator radius:radius categoryId:nil withCompletion:^(BOOL status, NSString* message, ERequestType requestType){
		
		NSAttributedString* countStr = [self getAttributedCountStr:[NSString stringWithFormat:@"%lu",(unsigned long)_gDataManager.searchCount]];
		_creatorCountLabel.attributedText = countStr;
	}];
}

- (NSAttributedString*) getAttributedCountStr:(NSString*)str
{
	NSMutableAttributedString* countStr  = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:kBlueColor,NSFontAttributeName:[UIFont fontWithName:kFontRalewayBold size:18.0f]}];
	
	NSAttributedString* textStr = [[NSAttributedString alloc] initWithString:@" current creators in this radius" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:kFontRalewayRegular size:16.0f]}];
	
	[countStr appendAttributedString:textStr];
	
	return  countStr;
}

@end
