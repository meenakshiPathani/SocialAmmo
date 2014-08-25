//
//  WebServiceManager.h
//  
//

#import <Foundation/Foundation.h>
#import "Defines.h"

typedef enum
{
    WEB_SERVICE_STATUS_NONE=0,
    WEB_SERVICE_STATUS_SUCCESS,
    WEB_SERVICE_STATUS_FAIL
}WEB_SERVICE_OPERATION_STATUS;

@protocol WebServiceManagerDelegate

- (void) getResponseFromServer: (NSData*) responseData
                   requestType: (ERequestType) theRequestType
                 requestStatus: (WEB_SERVICE_OPERATION_STATUS) theRequestStatus;
@end


@interface WebServiceManager : NSObject
{
	ERequestType _requesttype;
	BOOL _isShowProgress;

}

@property (nonatomic, retain) NSMutableData*                responseData;
@property (nonatomic, retain) NSNumber* filesize;
@property (nonatomic, retain) NSURLConnection*              activeConnection;

@property (nonatomic, assign) id<WebServiceManagerDelegate> delegate;

+ (NSURLRequest*) requestWithService:(NSString*)service;
+ (NSMutableURLRequest*) requestWithUrlString:(NSString*)urlString; // in case base url are not same

+ (NSURLRequest*) postRequestWithService:(NSString*)service
							  postString:(NSString*)postString;

+ (NSMutableURLRequest*) postRequestWithUrlString:(NSString*)urlString
									   postString:(NSString*)postString;

+ (void) sendRequest:(NSURLRequest*)request
		  completion:(void (^)(NSData*, NSError*)) callback;

- (void) sendrequest:(NSURLRequest*)request requesttype:(ERequestType)requestType withProgress:(BOOL)isProgress;

@end
