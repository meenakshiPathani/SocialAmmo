//
//  SubmissionTableViewCell.m
//  SocialAmmo
//
//  Created by Meenakshi on 05/08/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SubmissionTableViewCell.h"

@implementation SubmissionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
