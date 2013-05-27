//
//  ClearAllUnhandlePushNotification.m
//  SchoolNews
//
//  Created by Jerry on 3月8星期五.
//
//

#import "ClearPushNotificationWebservice.h"
#import "GDataXMLNode.h"

@implementation ClearPushNotificationWebservice
ClearPushNotificationWebservice* g_ClearPushNotificationWebservice;
+ (id)singleton
{
    if (g_ClearPushNotificationWebservice == nil) {
        g_ClearPushNotificationWebservice = [[ClearPushNotificationWebservice alloc] init];
    }
    return g_ClearPushNotificationWebservice;
}

- (id)doHandleTheData:(NSString* )data
{
    GDataXMLDocument* xmlDocument = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                        options:0
                                                                          error:nil];
    GDataXMLElement* rootElement = [xmlDocument rootElement];
    GDataXMLElement* stateElement = [[rootElement elementsForName:@"ns:return"]
                                     objectAtIndex:0];
    NSString* state = [stateElement stringValue];
    return state;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    if ([object isEqualToString:@"SUCCESS"]) {
        [self.delegate clearPushNotification:YES];
    }
    else if ([object isEqualToString:@"FALSE"])
    {
        [self.delegate clearPushNotification:NO];
    }
}
@end
