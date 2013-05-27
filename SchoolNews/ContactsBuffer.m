//
//  ContactsBuffer.m
//  SchoolNews
//
//  Created by Jerry on 1月3星期四.
//
//

#import "ContactsBuffer.h"
#define ARCHIVER_KEY                                    @"Contacts"
#define BUFFER_NAME                                     @"ContactBuffer"
@implementation ContactsBuffer
ContactsBuffer* g_ContactsBuffer;
+ (Buffer* )singleton
{
    if (g_ContactsBuffer == nil) {
        g_ContactsBuffer = [[ContactsBuffer alloc] init];
    }
    return g_ContactsBuffer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveTheDataInBuffer:)
                                                     name:@"SaveInContactBuffer"
                                                   object:nil];
    }
    return self;
}

- (void)saveTheDataInBuffer:(NSNotification* )sender
{
    NSArray* contactsAndDepartment = [sender object];
    //将contacts归档
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:contactsAndDepartment forKey:ARCHIVER_KEY];
    [archiver finishEncoding];
    [data writeToFile:[self bufferFilePathWithIdentifier:BUFFER_NAME] atomically:YES];
}


- (id)getDataInBufferWithIdentifier:(NSString* )identifier
{
    if ([identifier isEqualToString:@"Contact"]) {
        NSString* bufferFilePath = [self bufferFilePathWithIdentifier:BUFFER_NAME];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:bufferFilePath]) {
            return nil;
        }
        
        NSData* data = [NSData dataWithContentsOfFile:bufferFilePath];
        NSKeyedUnarchiver* uncarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray* contactsAndDepartments = [uncarchiver decodeObjectForKey:ARCHIVER_KEY];
        [uncarchiver finishDecoding];
        return contactsAndDepartments;
    }
    return nil;
}

@end
