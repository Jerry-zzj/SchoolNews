//
//  MeetBuffer.m
//  SchoolNews
//
//  Created by Jerry on 12月28星期五.
//
//

#import "MeetBuffer.h"
#import "UsersInformation.h"
#define ARCHIVER_KEY                    [NSString stringWithFormat:@"%@_%@",[UsersInformation singleton].accountName,bufferName]
@interface MeetBuffer(private)

- (void)saveTheData:(id)dataSender ToBuffer:(NSString* )bufferName;

@end
@implementation MeetBuffer
MeetBuffer* g_MeetBuffer;
+ (Buffer* )singleton
{
    if (g_MeetBuffer == nil) {
        g_MeetBuffer = [[MeetBuffer alloc] init];
    }
    return g_MeetBuffer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveTheDataInBuffer:)
                                                     name:@"SaveInMeetBuffer"
                                                   object:nil];
    }
    return self;
}

- (id)getDataInBufferWithIdentifier:(NSString* )identifier
{
    NSString* bufferName = [NSString stringWithFormat:@"%@_%@",[UsersInformation singleton].accountName,identifier];
    NSString* meetBufferPath = [self bufferFilePathWithIdentifier:bufferName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:meetBufferPath]) {
        return nil;
    }
    NSData* data = [[NSData alloc] initWithContentsOfFile:meetBufferPath];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray* meets = [unarchiver decodeObjectForKey:ARCHIVER_KEY];
    return meets;
}

- (void)clearTheDataInBuffer:(NSNotification* )sender//清空缓存区数据
{
    
}

#pragma mark private
//将数据保存在缓存区
- (void)saveTheData:(id)dataSender ToBuffer:(NSString* )bufferName
{
    NSArray* array = (NSArray* )dataSender;
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:ARCHIVER_KEY];
    [archiver finishEncoding];
    [data writeToFile:[self bufferFilePathWithIdentifier:bufferName] atomically:YES];
}

//将数据保存在缓存区
- (void)saveTheDataInBuffer:(NSNotification* )sender
{
    NSDictionary* seeingMeet = [sender object];
    NSArray* allKeys = [seeingMeet allKeys];
    for (NSString* key in allKeys) {
        NSArray* meetArray = [seeingMeet objectForKey:key];
        NSString* bufferFilePath = [self bufferFilePathWithIdentifier:key];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:bufferFilePath]) {
            [self saveTheData:meetArray ToBuffer:key];
        }
    }
}

@end
