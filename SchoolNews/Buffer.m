//
//  Buffer.m
//  SchoolNews
//
//  Created by Jerry on 12月27星期四.
//
//

#import "Buffer.h"

@interface Buffer (private)

//- (void)doSaveTheData:(id)dataSender ToBuffer:(NSString* )bufferName;//模板方法，将数据保存在缓存区

@end

@implementation Buffer

Buffer* g_Buffer;
+ (Buffer* )singleton
{
    if (g_Buffer == nil) {
        g_Buffer = [[Buffer alloc] init];
    }
    return g_Buffer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearTheDataInBuffer:)
                                                     name:@"ClearBuffer"
                                                   object:nil];
    }
    return self;
}

- (id)getDataInBufferWithIdentifier:(NSString* )identifier
{
    return nil;
}

//获得缓存区地址
- (NSString* )bufferFilePathWithIdentifier:(NSString* )sender
{
    NSArray* paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    NSString* bufferPath = [documentPath stringByAppendingPathComponent:sender];
    return bufferPath;
}

#pragma mark private

//将数据保存在缓存区
- (void)saveTheDataInBuffer:(NSNotification *)sender
{
    
}

//清空缓存区数据
- (void)clearTheDataInBuffer:(NSNotification* )sender
{
    NSString* bufferfileName = [sender object];
    NSString* bufferFilePath = [self bufferFilePathWithIdentifier:bufferfileName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:bufferFilePath]) {
        [fileManager removeItemAtPath:bufferFilePath error:nil];
    }
}
@end
