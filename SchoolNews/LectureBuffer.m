//
//  LectureBuffer.m
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import "LectureBuffer.h"
#define ARCHIVER_KEY                                    @"Lecture"
#define BUFFER_NAME                                     @"Lecture"
@implementation LectureBuffer
LectureBuffer* g_LectureBuffer;
+ (Buffer* )singleton
{
    if (g_LectureBuffer == nil) {
        g_LectureBuffer = [[LectureBuffer alloc] init];
    }
    return g_LectureBuffer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveTheDataInBuffer:)
                                                     name:@"SaveInLectureBuffer"
                                                   object:nil];
    }
    return self;
}

- (void)saveTheDataInBuffer:(NSNotification* )sender
{
    NSArray* lectures = [sender object];
    
    //先读取归档里的内容
    NSArray* lecturesInOldBuffer = [self getDataInBufferWithIdentifier:@"Lecture"];
    NSMutableArray* array = [NSMutableArray arrayWithArray:lecturesInOldBuffer];
    [array addObjectsFromArray:lectures];
    //
    //将notification归档
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:ARCHIVER_KEY];
    [archiver finishEncoding];
    [data writeToFile:[self bufferFilePathWithIdentifier:BUFFER_NAME] atomically:YES];
}


- (id)getDataInBufferWithIdentifier:(NSString* )identifier
{
    if ([identifier isEqualToString:@"Lecture"]) {
        NSString* bufferFilePath = [self bufferFilePathWithIdentifier:BUFFER_NAME];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:bufferFilePath]) {
            return nil;
        }
        
        NSData* data = [NSData dataWithContentsOfFile:bufferFilePath];
        NSKeyedUnarchiver* uncarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //这里的|news|可能需要再次解析
        NSArray* lectures = [uncarchiver decodeObjectForKey:ARCHIVER_KEY];
        [uncarchiver finishDecoding];
        return lectures;
    }
    return nil;
}

@end
