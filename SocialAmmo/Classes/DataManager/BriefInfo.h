//
//  BriefInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 11/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface BriefInfo : NSObject 
{
	
}
@property (nonatomic, assign)NSUInteger briefId;

@property (nonatomic, strong)NSString*	briefTitle;
@property (nonatomic, strong)NSString*	description;
@property (nonatomic, strong)NSString*	fontName;
@property (nonatomic, strong)NSString*	briefCreationDate;

@property (nonatomic, strong)UIImage*	logoImage;
@property (nonatomic, strong)NSString*	logoImageURL;

@property (nonatomic, strong)NSDate*	startDate;
@property (nonatomic, strong)NSDate*	endDate;

@property (nonatomic, strong)NSArray*	interestArray;
@property (nonatomic, strong)NSArray*	locationArray;

@property (nonatomic, assign)NSUInteger newSubmission;
@property (nonatomic, assign)NSUInteger accepted;
@property (nonatomic, assign)NSUInteger declined;
@property (nonatomic, assign)NSUInteger credit;		//Social Ammo coins

@property (nonatomic, assign)BOOL newSubmissionNotification;
@property (nonatomic, assign)BOOL acceptContentNotification;
@property (nonatomic, assign)BOOL declineContentNotification;
@property (nonatomic, assign)BOOL creditNotification;		//Social Ammo coins notif

@property (nonatomic, assign)CGFloat cost;	// In AUD
@property (nonatomic, assign)NSUInteger noOfContents;

@property (nonatomic, assign)BOOL expired;

- (id)initWithInfo:(NSDictionary*)dictionary;


@end
