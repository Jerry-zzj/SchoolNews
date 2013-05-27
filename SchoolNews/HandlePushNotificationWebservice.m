//
//  HandlePushNotificationWebservice.m
//  SchoolNews
//
//  Created by Jerry on 3月8星期五.
//
//

#import "HandlePushNotificationWebservice.h"
#import "GDataXMLNode.h"

@implementation HandlePushNotificationWebservice
HandlePushNotificationWebservice* g_HandlePushNotificationWebservice;
+ (id)singleton
{
    if (g_HandlePushNotificationWebservice == nil) {
        g_HandlePushNotificationWebservice = [[HandlePushNotificationWebservice alloc] init];
    }
    return g_HandlePushNotificationWebservice;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:FINISH_HANDLE_PUSHNOTIFICATION
                                                        object:object];
}
@end
