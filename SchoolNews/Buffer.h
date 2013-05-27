//
//  Buffer.h
//  SchoolNews
//
//  Created by Jerry on 12月27星期四.
//
//

#import <Foundation/Foundation.h>

@interface Buffer : NSObject
{
    BOOL couldClear_;
}
+ (Buffer* )singleton;
- (id)getDataInBufferWithIdentifier:(NSString* )identifier;
- (NSString* )bufferFilePathWithIdentifier:(NSString* )sender;//获得数据库地址
- (void)clearTheDataInBuffer:(NSNotification* )sender;//清空缓存区数据
- (void)saveTheDataInBuffer:(NSNotification* )sender;//保存数据到缓存区
@end
