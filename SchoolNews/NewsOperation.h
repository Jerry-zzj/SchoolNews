//
//  NewsOperation.h
//  SchoolNews
//
//  Created by shuangchi on 12月17星期一.
//
//

#import <Foundation/Foundation.h>

@interface NewsOperation : NSOperation
{
    NSString* urlString_;
    NSString* finishedNotificationName_;
    NSArray* receiveNewses_;
}
- (id)initWithURL:(NSString* )urlString AndFinishedNotification:(NSString* )notificationName;
@end
