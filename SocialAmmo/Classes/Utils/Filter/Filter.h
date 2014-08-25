//
//  Filter.h
//  
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject
{
    
}

-(id) initWithNameAndFilter:(NSString *) theName filter:(CIFilter *) theFilter; 

@property (nonatomic,strong) NSString *name; 
@property (nonatomic,strong) CIFilter *filter; 

@end
