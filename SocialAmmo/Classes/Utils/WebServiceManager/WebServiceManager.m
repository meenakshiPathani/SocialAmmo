//
//  WebServiceManager.m
//  
//


#import "WebServiceManager.h"

@implementation WebServiceManager

+ (NSURLRequest*) requestWithService:(NSString*)service
{
	NSString* urlString = [kServerUrl stringByAppendingString:service];
	return [WebServiceManager requestWithUrlString:urlString];
}

+ (NSMutableURLRequest*) requestWithUrlString:(NSString*)urlString // in case base url are not same
{
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
									[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setTimeoutInterval:60.0];

	return (NSMutableURLRequest*)request;
}

+ (NSURLRequest*) postRequestWithService:(NSString*)service
							  postString:(NSString*)postString
{
	NSString* urlString = [kServerUrl stringByAppendingString:service];

	return [WebServiceManager postRequestWithUrlString:urlString postString:postString];
}

+ (NSMutableURLRequest*) postRequestWithUrlString:(NSString*)urlString
									   postString:(NSString*)postString
{
	NSData*	postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
	NSString* postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
									[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded; charset=UTF-8"
   forHTTPHeaderField:@"Content-Type"];
	[request setTimeoutInterval:60.0];

	[request setHTTPBody:postData];

	return request;
}

#pragma mark - Send Request

+ (void) sendRequest:(NSURLRequest*)request
		  completion:(void (^)(NSData*, NSError*)) callback
{
	if ([UIUtils isConnectedToNetwork] == NO)
	{
		callback(nil, [NSError errorWithDomain:kNetworkErrorMessage code:0 userInfo:nil]);
		return;
	}

	_Assert(request);

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse* response,
											   NSData* responseData, NSError* error)
	{
		
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSUInteger responseStatusCode = [httpResponse statusCode];
		if (responseStatusCode == 200)
		{
			callback(responseData, error);
		}
		else
		{
			callback(nil, error);
			DLog(@"%@",[error description]);
		}

		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}];
}


- (BOOL) setUpConnectionForRequest:(NSURLRequest*)request
{
    if (![UIUtils isConnectedToNetwork])
    {
        [UIUtils messageAlert:kNetworkErrorMessage title:@"" delegate:nil];
        return FALSE;
    }
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection)
    {
        self.activeConnection = connection;
        
		(_isShowProgress)?[_gAppDelegate showProgressView:YES]:[_gAppDelegate showLoadingView:YES];
		[_gAppDelegate setProgressData:0.0];
		[self setLoadingtext];

        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        return TRUE;
    }
	
    self.activeConnection = nil;
    return FALSE;
}

- (void) sendrequest:(NSURLRequest*)request requesttype:(ERequestType)requestType withProgress:(BOOL)isProgress
{
	_requesttype = requestType;
	_isShowProgress = isProgress;
	
    if ([self setUpConnectionForRequest:request])
        _responseData = [[NSMutableData alloc]init];
}

- (void) setLoadingtext
{
	switch (_requesttype)
	{
		case ERequestTypeSubmitContent:
			[_gAppDelegate setLoadingViewTitle:@"Submitting..."];
			break;
			
		case ERequestTypeSaveBrief:
			[_gAppDelegate setLoadingViewTitle:@"Creating..."];
			break;
			
		case ERequestTypeSendPrivateMessage:
			[_gAppDelegate setLoadingViewTitle:@"Sending..."];
			break;

		case ERquestTypeLoadLogoImage:
			[_gAppDelegate setLoadingViewTitle:@"Downloading..."];
			break;
			
		default:
			[_gAppDelegate setLoadingViewTitle:@"Loading..."];
			break;
	}
}

#pragma mark - Url Connection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[_responseData setLength:0];
	self.filesize = [NSNumber numberWithLongLong:[response expectedContentLength]];
}

- (void)connection:(NSURLConnection *)connection  didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	float myProgress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
	[_gAppDelegate setProgressData:myProgress];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_responseData appendData:data];
}

- (void) connection:(NSURLConnection*) connection didFailWithError:(NSError*) error
{
    self.activeConnection = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	(_isShowProgress)?[_gAppDelegate showProgressView:NO]:[_gAppDelegate showLoadingView:NO];
    
	NSString* errorMessage = [NSString stringWithFormat:@"%@. Please try again!",error.localizedDescription];
	
    [UIUtils messageAlert:errorMessage title:@"" delegate:nil];
}

- (void) connectionDidFinishLoading:(NSURLConnection*) connection
{
   WEB_SERVICE_OPERATION_STATUS _requestStatus = WEB_SERVICE_STATUS_SUCCESS;
    
    [_delegate getResponseFromServer:_responseData requestType:_requesttype requestStatus:_requestStatus];
	
    self.activeConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	(_isShowProgress)?[_gAppDelegate showProgressView:NO]:[_gAppDelegate showLoadingView:NO];
}

@end
