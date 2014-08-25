

#import <Foundation/Foundation.h>

@interface LeftTableViewCell : UITableViewCell

{
	IBOutlet UIImageView*  _cellImageView;
	IBOutlet UILabel* _nameLabel;
}

- (void) setUpInitial:(NSDictionary*)menuInfo;

@end
