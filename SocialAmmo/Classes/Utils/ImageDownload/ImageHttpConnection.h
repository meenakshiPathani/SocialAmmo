//
//  ImageHttpConnection.h
//

#define	_ReleaseHttpConnection(obj)					{ [ImageHttpConnection releaseConnection:obj]; obj = nil; }

typedef enum  tagStatusCode
{
	EStatusCodeInvalid = -1,
	EStatusCodeError = -1,
	EStatusCodeSuccess,
	EStatusRequestSent	= 10001,
	EStatusResponseReceived,
	EStatusResponseDataReceiving,
	EStatusRequestCompleted,
	EStatusRequestFailed,
	
	EStatusRequestQueued,
	EStatusNoTransaction,
	EStatusRequestPending,
	EStatusNoSessionError,
	EStatusXMLParsingError,
	EStatusUserAlreadyExists,
	EStatusURLConnectionError,
	EStatusInvalidRequest,
	EStatusInvalidResponse,
	
	EStatusHTTPSuccess = 200,
	EStatusHTTPInvalidURL = 400,
	EStatusHTTPBadGateway = 502,
	EStatusHTTPServerNotReachable = 504,
	
	EStatusCodeUpdationFailed = 1,
	EStatusCodeDatabaseError = 2,
	EStatusCodeXmlError = 3,
	EStatusCodeUserAlreadyExist = 4,
	EStatusCodeRequestSentSuccessfully,
	
	EStatusCodeCantFindHost = -1003,
	EStatusCodeDomainNotSupportedHere = 531,
	EStatusCodePartialSuccessful = 201,
	EStatusCodeUnknownUser = 531,
	EStatusCodeWrongPassword = 409,
	EStatusCodeMessageNotFound = 426,
	EStatusCodeInvalidURL = 2400,
	EStatusCodeGetResponseSuccessfully = 2200,
	EStatusCodeBadGateway = 2502,
	EStatusCodeUnableToReachServer = 2504,
	EStatusCodeRequestTimedOut = 1001,
	EStatusCodeNoInternetConnection = 1009
} EStatusCode;

@class ImageHttpConnection;

@protocol ImageHttpConnectionDelegate <NSObject>

@optional
- (void) requestRespondedWithStatus:(NSUInteger)statusCode connection:(ImageHttpConnection*)connection;

@required
- (void) requestFailedWithError:(NSError*) errorCode connection:(ImageHttpConnection*)connection;
- (void) requestCompletedWithData:(NSData*)data connection:(ImageHttpConnection*)connection;

@end

@interface ImageHttpConnection : NSObject 
{
	NSString*			_urlString;
	NSURLConnection*	_urlConnection;
	NSMutableData*		_responseData;

	id<ImageHttpConnectionDelegate>	_delegate;
	NSObject*					_userInfo;
}

@property(nonatomic, readonly) NSString*	urlString;
@property(nonatomic, readonly) NSData*		responseData;
@property(nonatomic, readonly) NSObject*	userInfo;

@property(nonatomic, readonly) BOOL			isFree;


- (id) initWithDelegate:(id) delegate userInfo:(NSObject*)userInfo;

- (EStatusCode) sendRequestWithUrlString:(NSString*) urlString;
+ (NSData*) sendSyncRequestWithUrlString:(NSString*) urlString;

- (void) cancelRequest;
- (void) logResponse;

+ (void) releaseConnection:(ImageHttpConnection*) connection;

@end
