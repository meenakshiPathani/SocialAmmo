//
//  ImageHttpConnection.m
//  
//

#import "ImageHttpConnection.h"

@implementation ImageHttpConnection

@synthesize responseData = _responseData, userInfo = _userInfo;
@synthesize urlString = _urlString;

- (BOOL) isFree
{
	return (_urlConnection == nil);
}

- (id) initWithDelegate:(id) delegate userInfo:(NSObject*)userInfo;
{
	if (self = [super init])
	{
		_delegate = [delegate retain];
		_userInfo = [userInfo retain];
	}
	return self;
}

- (void) dealloc
{
	[self cancelRequest];
	
	_ReleaseObject(_urlString);
	
	_ReleaseObject(_delegate);
	_ReleaseObject(_userInfo);
	
	[super dealloc];
}

#pragma mark -

- (EStatusCode) sendRequestWithUrlString:(NSString*) urlString
{
	//	NSLog(serverURL);
	if (_urlConnection != nil)
		return EStatusRequestPending;
	
	_urlString = [urlString retain];


	NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[urlRequest setHTTPMethod:@"GET"];
	[urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
	[urlRequest setTimeoutInterval:60.0];

	assert(_urlConnection == nil);
	_urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	
	if (!_urlConnection)
		return EStatusURLConnectionError;
	
	return EStatusRequestSent;
}

+ (NSData*) sendSyncRequestWithUrlString:(NSString*) urlString;
{
	NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[urlRequest setHTTPMethod:@"GET"];
	[urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
	[urlRequest setTimeoutInterval:60.0];
	
	NSError* error = nil;
	return [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
}

+ (void) releaseConnection:(ImageHttpConnection*) connection
{
	if (connection)
	{
		[connection cancelRequest];
		[connection release];
	}
}

-(void) cancelRequest
{
	[_urlConnection cancel];
	_ReleaseObject(_urlConnection);
	_ReleaseObject(_responseData);
}

- (void) logResponse
{
	//	NSLog(@"Response Received: %@", 
	//		  [[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] autorelease]);
}

#pragma mark-

- (void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	assert(_urlConnection == connection);
	
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	NSUInteger responseStatusCode = [httpResponse statusCode];
	
	if ([_delegate respondsToSelector:@selector(requestRespondedWithStatus:connection:)])
		[_delegate requestRespondedWithStatus:responseStatusCode connection:self];
	
	if (responseStatusCode != 200)
	{	
		NSString* msg  = [NSHTTPURLResponse localizedStringForStatusCode:responseStatusCode];
		[UIUtils messageAlert:msg title:nil delegate:nil];

//		NSLog(@"The description is %@", [NSHTTPURLResponse localizedStringForStatusCode:responseStatusCode]);
		return;
	}
	
	_ReleaseObject(_responseData);
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	assert(_urlConnection == connection);

	if (_responseData == nil)
	{
		_responseData = [[NSMutableData dataWithData:data] retain];
	}
	else
	{
		[_responseData appendData:data];
	}

}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	assert(_urlConnection == connection);
	
	[_delegate requestFailedWithError:error connection:self];
	
	NSString* msg  = ([error localizedDescription]);

	if (!_gDataManager.isAlertShow)
	{
		[UIUtils messageAlert:msg title:nil delegate:self];
		_gDataManager.isAlertShow = YES;
	}
	_ReleaseObject(_urlConnection);
}

- (void) connectionDidFinishLoading:(NSURLConnection*) connection 
{
	assert(_urlConnection == connection);
	//NSLog([_responseData description]);
	
	[_delegate requestCompletedWithData:_responseData connection:self];
	_ReleaseObject(_urlConnection);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	_gDataManager.isAlertShow = NO;
}

@end
