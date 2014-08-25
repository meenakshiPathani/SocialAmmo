//
//  SocialSharing.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 5/5/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialSharing : NSObject<UIDocumentInteractionControllerDelegate>
{
}

@property (nonatomic,retain) NSString* detailsTxt;
@property (nonatomic,retain) NSString* userName;
@property (nonatomic,retain) UIImage* sharedImage;
@property (nonatomic,retain) NSString* thumbimageURl;
@property (nonatomic,retain) NSString* fullImageUrl;
@property (nonatomic,retain) UIViewController* topController;

@property (nonatomic,retain) NSString* tokenStr;
@property(nonatomic, strong) UIDocumentInteractionController * docController;

- (id)initWithInfo:(NSDictionary*)dictionary andController:(UIViewController*)topController;

- (void) shareOnFacebook;
- (void) shareOnTwitter;
- (void) shareOnLinkdIn;
//- (void) shareOnInstagram;
- (void) shareOnPinInterest;

@end
