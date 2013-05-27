//
//  RemotePushNotification.h
//  SchoolNews
//
//  Created by Jerry on 3月5星期二.
//
//

#import <Foundation/Foundation.h>

@interface RemotePushNotificationObject : NSObject<NSCoding,NSCopying>
@property (nonatomic,retain)NSString* ID;
@property (nonatomic,retain)NSString* title;
@property (nonatomic,retain)NSString* type;
@property (nonatomic,retain)NSString* contentID;
- (NSDictionary* )changeToDictiontion;
- (RemotePushNotificationObject* )initWithDictionary:(NSDictionary* )sender;
@end
