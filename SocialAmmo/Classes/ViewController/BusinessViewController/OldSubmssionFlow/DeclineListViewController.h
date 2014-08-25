//
//  DeclineListViewController.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/25/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

typedef void (^DeclineListCompletionBlock) (void);


@interface DeclineListViewController : BaseViewController
{
	IBOutlet UITableView* _listTableView;
}
@property (nonatomic, copy) DeclineListCompletionBlock completion;

- (id)initWithCompletionBlock:(DeclineListCompletionBlock)block;

@end
