//
//  RemotePushNotificationWebService.m
//  SchoolNews
//
//  Created by Jerry on 3月5星期二.
//
//

#import "RemotePushNotificationWebService.h"
#import "GDataXMLNode.h"
#import "RemotePushNotificationObject.h"
@implementation RemotePushNotificationWebService
RemotePushNotificationWebService* g_RemotePushNotificationWebService;
+ (id)singleton
{
    if (g_RemotePushNotificationWebService == nil) {
        g_RemotePushNotificationWebService = [[RemotePushNotificationWebService alloc] init];
    }
    return g_RemotePushNotificationWebService;
}

- (id)doHandleTheData:(NSString* )data
{
    GDataXMLDocument* xmlDocument = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                        options:0
                                                                          error:nil];
    GDataXMLElement* rootElement = [xmlDocument rootElement];
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSLog(@"%@",[temp stringValue]);
    NSArray* remotePushNotificationsXML = [temp elementsForName:@"RemoteNotification"];
    NSMutableArray* remotePushNotification = [[NSMutableArray alloc] init];
    for (GDataXMLElement* element in remotePushNotificationsXML) {
        RemotePushNotificationObject* pushNotification = [[RemotePushNotificationObject alloc] init];
        //ID
        GDataXMLElement* idElement = [[element elementsForName:@"ID"] objectAtIndex:0];
        pushNotification.ID = [idElement stringValue];
        //Title
        GDataXMLElement* titleElement = [[element elementsForName:@"Title"] objectAtIndex:0];
        pushNotification.title = [titleElement stringValue];
        //Type
        GDataXMLElement* typeElement = [[element elementsForName:@"Type"] objectAtIndex:0];
        pushNotification.type = [typeElement stringValue];
        //ContentID
        GDataXMLElement* contentIDElement = [[element elementsForName:@"ContentID"] objectAtIndex:0];
        pushNotification.contentID = [contentIDElement stringValue];
        
        [remotePushNotification addObject:pushNotification];
    }
    return remotePushNotification;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:GET_REMOTE_PUSH_NOTIFICATION
      //                                                  object:object];
    [self.delegate getAllRemotePushNotificationAboutDevice:object];
}
@end
