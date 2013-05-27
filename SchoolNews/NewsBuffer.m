//
//  NewsBuffer.m
//  SchoolNews
//
//  Created by Jerry on 12月27星期四.
//
//

#import "NewsBuffer.h"
#import "NewsObject.h"


#define ARCHIVING_KEY                               @"archivingNews"
#define NEWS_YAOWEN_BUFFRT_FILENAME                 @"News_Yaowen_Buffer"

@interface NewsBuffer(private)

@end

@implementation NewsBuffer
NewsBuffer* g_NewsBuffer;
+ (Buffer* )singleton
{
    if (g_NewsBuffer == nil) {
        g_NewsBuffer = [[NewsBuffer alloc] init];
    }
    return g_NewsBuffer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveTheDataInBuffer:)
                                                     name:@"SaveInNewsBuffer"
                                                   object:nil];
    }
    return self;
}

- (id)getDataInBufferWithIdentifier:(NSString* )identifier
{
    NSString* bufferFilePath = [self bufferFilePathWithIdentifier:identifier];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bufferFilePath]) {
        return nil;
    }
    
    NSData* data = [NSData dataWithContentsOfFile:bufferFilePath];
    NSKeyedUnarchiver* uncarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //这里的|news|可能需要再次解析
    NSArray* news = [uncarchiver decodeObjectForKey:ARCHIVING_KEY];
    [uncarchiver finishDecoding];
    return news;
}

#pragma mark private
- (void)saveTheDataInBuffer:(NSNotification* )sender//保存当前最新的10条新闻到缓存区
{
    
    NSDictionary* senderDictionary = [sender object];
    NSString* bufferName = [[senderDictionary allKeys] objectAtIndex:0];
    NSArray* toSavedNews = [senderDictionary objectForKey:bufferName];
    
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:toSavedNews forKey:ARCHIVING_KEY];
    [archiver finishEncoding];
    [data writeToFile:[self bufferFilePathWithIdentifier:bufferName] atomically:YES];
}

- (void)clearTheDataInBuffer:(NSNotification* )sender//清空缓存区数据
{
    NSString* bufferName = [sender object];
    NSString* bufferFilePath = [self bufferFilePathWithIdentifier:bufferName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:bufferFilePath]) {
        [fileManager removeItemAtPath:bufferFilePath error:nil];
    }
}
@end
