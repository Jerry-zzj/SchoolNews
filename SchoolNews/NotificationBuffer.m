//
//  NotificationBuffer.m
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import "NotificationBuffer.h"
#import "UsersInformation.h"
#import "NotificationObject.h"
#define BUFFER_NAME                     @"NotificationBuffer"
#define ARCHIVER_KEY                    [NSString stringWithFormat:@"%@_Notification",[UsersInformation singleton].accountName]
@interface NotificationBuffer(private)

//- (NSArray* )getNotificationFromNotificationData:(NSArray* )sender;

@end

@implementation NotificationBuffer
NotificationBuffer* g_Buffer;
+ (Buffer* )singleton
{
    if (g_Buffer == nil) {
        g_Buffer = [[NotificationBuffer alloc] init];
    }
    return g_Buffer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveTheDataInBuffer:)
                                                     name:@"SaveInNotificationBuffer"
                                                   object:nil];
    }
    return self;
}

//将数据保存在缓存区
- (void)saveTheDataInBuffer:(NSNotification* )sender
{
    NSArray* notifications = [sender object];
    //先读取归档里的内容
    NSArray* notificationsInOldBuffer = [self getDataInBufferWithIdentifier:@"Notification"];
    NSMutableArray* array = [NSMutableArray arrayWithArray:notificationsInOldBuffer];
    [array addObjectsFromArray:notifications];
    //将notification归档
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [NSString stringWithFormat:@"%@_Notification",[UsersInformation singleton].accountName];
    [archiver encodeObject:array forKey:ARCHIVER_KEY];
    [archiver finishEncoding];
    [data writeToFile:[self bufferFilePathWithIdentifier:BUFFER_NAME] atomically:YES];
}

- (id)getDataInBufferWithIdentifier:(NSString* )identifier
{
    if ([identifier isEqualToString:@"Notification"]) {
        NSString* bufferFilePath = [self bufferFilePathWithIdentifier:BUFFER_NAME];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:bufferFilePath]) {
            return nil;
        }
        
        NSData* data = [NSData dataWithContentsOfFile:bufferFilePath];
        NSKeyedUnarchiver* uncarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            //这里的|news|可能需要再次解析
        NSArray* notifications = [uncarchiver decodeObjectForKey:ARCHIVER_KEY];
        [uncarchiver finishDecoding];
        return notifications;
    }
    return nil;
}

/*- (NSArray* )getNotificationFromNotificationData:(NSArray* )sender
{
    NSMutableArray* notifications = [NSMutableArray array];
    for (NSData* object in sender) {
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:object];
        NotificationObject* notification = [unarchiver decodeObjectForKey:ARCHIVER_KEY];
        [notifications addObject:notification];
    }
    return notifications;
}*/
@end
