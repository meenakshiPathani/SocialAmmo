

#import "LeftTableViewCell.h"

#pragma mark -
#pragma mark Implementation

@implementation LeftTableViewCell

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

- (void) setUpInitial:(NSDictionary*)menuInfo
{
	_nameLabel.text = [menuInfo objectForKey:@"Name"];
	_cellImageView.image = [UIImage imageNamed:[menuInfo objectForKey:@"ImageName"]];
}

@end
