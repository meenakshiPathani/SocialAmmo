//
//  CustomeEditngView.m
//
//

#import "CustomeEditngView.h"

#define kMaxWidth 300
#define kMaxTextlength 50
#define kMaxHeight self.superview.frame.size.height

@implementation CustomeEditngView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = kBlueColor.CGColor;
        self.layer.borderWidth = 2.0f;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        super.delegate = self;
        self.editable = NO;
		self.textColor = kBlueColor;
        _initialbounds = self.bounds;
		self.scrollEnabled = NO;
		
		self.maximumZoomScale = 1.5;
		self.minimumZoomScale = 1.0;
		self.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
		
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
        
        _centerX = self.center.x;
        _centerY = self.center.y;
        
        UIPanGestureRecognizer* panGRForDrag = [[UIPanGestureRecognizer alloc] initWithTarget:
												self action:@selector(dragTextView:)];
        UIPinchGestureRecognizer* pinchGRForZoom = [[UIPinchGestureRecognizer alloc] initWithTarget:
													self action:@selector(resizeTxtview:)];
        UITapGestureRecognizer* tapGestureForEdit = [[UITapGestureRecognizer alloc] initWithTarget:
													 self action:@selector(textViewStartEditing:)];
        _tapgestureforResign = [[UITapGestureRecognizer alloc] initWithTarget:
								self action:@selector(dismissKeyBoard:)];
        
        tapGestureForEdit.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:panGRForDrag];
        [self addGestureRecognizer:pinchGRForZoom];
        [self addGestureRecognizer:tapGestureForEdit];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark --
#pragma mark  Methods

- (void) managetextUpdate:(UIFont*)font
{
    if (font)
        self.font = font;
    
    CGSize  rect;
	if (self.bounds.size.width < kMaxWidth-5)
        rect = [self sizeThatFits:CGSizeMake(FLT_MAX,FLT_MAX)];
	else
        rect = [self sizeThatFits:CGSizeMake(kMaxWidth,FLT_MAX)];
    
	CGSize box;
	if (_width > rect.width)
		box = CGSizeMake(fminf(_width, kMaxWidth), fminf(rect.height,kMaxHeight));
	else
	    box = CGSizeMake(fminf(rect.width, kMaxWidth), fminf(rect.height,kMaxHeight));
    
	self.bounds = CGRectMake(0,0,box.width,box.height);
	self.center = CGPointMake(_centerX,_centerY);
    
    CGPoint centerPoint = self.center ;
    DLog(@"%f",self.frame.origin.y);
    
    if (self.frame.origin.y < 0)
         centerPoint.y = centerPoint.y + ( -1 * self.frame.origin.y);
    if (self.frame.origin.x < 0)
        centerPoint.x = centerPoint.x + (-1 * self.frame.origin.x);
    
    CGFloat heightValue = self.frame.origin.y+self.bounds.size.height;
    CGFloat widthValue = self.frame.origin.x+self.bounds.size.width;
    DLog(@"%f",kMaxHeight);

    if (heightValue > kMaxHeight)
        centerPoint.y = centerPoint.y - (heightValue - kMaxHeight);
    if (widthValue > kMaxWidth)
        centerPoint.x = centerPoint.x - (widthValue - kMaxWidth);

    self.center = centerPoint;

    [self setNeedsDisplay];
}

#pragma mark --
#pragma mark Gesture methods

- (void) dragTextView:(UIPanGestureRecognizer*)sender
{
    static CGRect originalFrame;
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        originalFrame = sender.view.frame;
		[self resignFirstResponder];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [sender translationInView:sender.view.superview];
        CGRect newFrame = CGRectMake(originalFrame.origin.x + translate.x,
                                     originalFrame.origin.y + translate.y,
                                     originalFrame.size.width,
                                     originalFrame.size.height);
        
//
//        if ((newFrame.origin.y > self.superview.frame.size.height-newFrame.size.height) ||
//			(newFrame.origin.y < 0) || ((newFrame.origin.x + newFrame.size.width) > 300) ||
//			(newFrame.origin.x < 0))
//            return;

		if ((newFrame.origin.y > self.superview.frame.size.height-40) || (newFrame.origin.y < (-20)) ||
			(newFrame.origin.x > self.superview.frame.size.width -40) || (newFrame.origin.x < (-40)))
            return;
       
        self.frame = newFrame;
        
//		centerX = self.center.x;
//		centerY = self.center.y;
    }
//
//    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    self.layer.position = self.center;

}

- (void) resizeTxtview:(UIPinchGestureRecognizer*)sender
{
    if (!self.editable)
        return;

    static CGRect initialBounds;
	static CGFloat initialFontsize;
    
	if (sender.state == UIGestureRecognizerStateBegan)
    {
		
		initialBounds = self.bounds;
		
//		CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
//		if (factor < 1.0 || factor > 1.5)
//			return;
        
		UIFontDescriptor* des = [self.font fontDescriptor];
		NSNumber* size = des.fontAttributes[UIFontDescriptorSizeAttribute];
		initialFontsize = size.floatValue;
		[self resignFirstResponder];
    }
	
	if (sender.state == UIGestureRecognizerStateChanged)
    {
		
		CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
//		if (factor < 1.0 || factor > 1.5)
//			return;
		
		CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
		CGRect newbounds = CGRectApplyAffineTransform(initialBounds, zt);
		
		if (newbounds.size.width < 260  &&  newbounds.size.width > 120)
			self.bounds = newbounds;
		else
			return;
//		if (CGRectContainsRect(initialbounds, newbounds))
//		{
//			self.bounds = initialbounds;
//		}
//		else
//			self.bounds = newbounds;
		
		self.font = [UIFont fontWithName:self.font.fontName size:initialFontsize * factor];
		
		_width = self.bounds.size.width;
		_height = self.bounds.size.height;
		
		_centerX = self.center.x;
		_centerY = self.center.y;
    }
    
	if (sender.state == UIGestureRecognizerStateEnded)
    {
		_centerX = self.center.x;
		_centerY = self.center.y;
    }
    
    [self setNeedsDisplay];
}

//- (void) resizeTxtview:(UIPinchGestureRecognizer*)gestureRecognizer
//{
//	if (!self.editable)
//        return;
//	
//	static CGFloat initialFontsizeD;
//	static CGRect initialBounds;
//
//	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
//	{
//		// Reset the last scale, necessary if there are multiple objects with different scales
//		_prevPinchScale = [gestureRecognizer scale];
//		
//		initialBounds = self.bounds;
//		UIFontDescriptor* des = [self.font fontDescriptor];
//		NSNumber* size = des.fontAttributes[UIFontDescriptorSizeAttribute];
//		initialFontsizeD = size.floatValue;
//	}
//	
//	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
//		[gestureRecognizer state] == UIGestureRecognizerStateChanged) {
//		
//		CGFloat currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"]
//								floatValue];
//		
//		// Constants to adjust the max/min values of zoom
//		const CGFloat kMaxScale = 1.5;
//		const CGFloat kMinScale = 1.0;
//		
//		// new scale is in the range (0-1)
//		CGFloat newScale = 1 -  (_prevPinchScale - [gestureRecognizer scale]);
//		newScale = MIN(newScale, kMaxScale / currentScale);
//		newScale = MAX(newScale, kMinScale / currentScale);
//		CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform],
//															 newScale, newScale);
//		[gestureRecognizer view].transform = transform;
////		self.font = [UIFont systemFontOfSize:initialFontsizeD * newScale];
//		
//		// Store the previous scale factor for the next pinch gesture call
//		_prevPinchScale = [gestureRecognizer scale];
//		
//		NSLog(@"%@", NSStringFromCGRect(self.frame));
//		
//	}
//}

- (void) textViewStartEditing:(UITapGestureRecognizer*)sender
{
    self.editable = YES;
    [self.superview addGestureRecognizer:_tapgestureforResign];
}

- (void) dismissKeyBoard:(UITapGestureRecognizer*)sender
{
    [self resignFirstResponder];
    [self removeGestureRecognizer:_tapgestureforResign];
}

#pragma mark --
#pragma mark Touch methods

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return  NO;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

# pragma mark --
# pragma mark TextView delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:
(NSString *)text
{
	NSInteger txtlength = [[textView text] length] - range.length + text.length ;

	return (!(txtlength > kMaxTextlength));
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = 312.0f;
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), fminf(newSize.height, maxHeight));
    textView.frame = newFrame;
}
@end
