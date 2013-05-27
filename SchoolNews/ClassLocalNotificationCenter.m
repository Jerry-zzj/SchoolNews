//
//  ClassLocalNotificationCenter.m
//  SchoolNews
//
//  Created by Jerry on 5月24星期五.
//
//

#import "ClassLocalNotificationCenter.h"
#import "ClassObject.h"
@interface ClassLocalNotificationCenter(privateAPI)

- (void)initialClassTime;

@end

@implementation ClassLocalNotificationCenter
+ (id)singleton
{
    static ClassLocalNotificationCenter* g_ClassLocalNotificationCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_ClassLocalNotificationCenter = [[ClassLocalNotificationCenter alloc] init];
    });
    return g_ClassLocalNotificationCenter;
}

- (void)setClasses:(NSArray* )array
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

#pragma mark privateAPI
- (void)initialClassTime
{
    NSArray* classIndexs = [NSArray arrayWithObjects:@"第1节",@"第2节",@"第3节",@"第4节",@"第5节",@"第6节",@"第7节",@"第8节",@"第9节",@"第10节",@"第11节", nil];
    NSArray* classTimeDates = [NSArray arrayWithObjects:@"8:10",@"9:00",@"10:00",@"10:50",@"11:40",@"13:30",@"14:20",@"15:20",@"16:10",@"18:30",@"19:20",@"20:10",nil];
}

@end
