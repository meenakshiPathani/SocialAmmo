//
//  AcceptDeclineListViewController.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/21/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

typedef void (^AcceptDeclineListCompletionBlock) (void);

@interface AcceptDeclineListViewController:BaseViewController<UIDocumentInteractionControllerDelegate>
{
	IBOutlet UITableView* _listTableView;
}
@property (nonatomic, copy) AcceptDeclineListCompletionBlock completion;
@property (nonatomic,retain) UIDocumentInteractionController* documentController;

- (id)initWithCompletionBlock:(AcceptDeclineListCompletionBlock)block;

@end
