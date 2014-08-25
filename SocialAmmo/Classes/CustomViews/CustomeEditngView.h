//
//  CustomeEditngView.h
//  PicLab
//
//

@interface CustomeEditngView : UITextView<UITextViewDelegate>
{
    CGFloat _centerY;
    CGFloat _centerX;
    CGRect _initialbounds;

    CGFloat _width;
    CGFloat _height;
    
	CGFloat _prevPinchScale;
	
    UITapGestureRecognizer* _tapgestureforResign;
}

- (void) managetextUpdate:(UIFont*)font;

@end
