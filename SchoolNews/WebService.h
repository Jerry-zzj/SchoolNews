//
//  WebService.h
//  SchoolNews
//
//  Created by shuangchi on 12月13星期四.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@interface WebService : NSObject<ASIHTTPRequestDelegate>
{
    BOOL finished_;
    NSURL* url_;
}
+ (id)singleton;
- (void )getWebServiceData;
- (void)setURLWithString:(NSString* )sender;
//- (void)setFinishNotificationName:(NSString* )sender;
@end
