//
//  ShowNewsQueue.h
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import <Foundation/Foundation.h>
#import "NewsObject.h"
@interface ShowNewsQueue : NSObject
{
    
}
@property (nonatomic,assign)int showingIndex;
@property (nonatomic,retain)NSMutableArray* newsQueue;

+ (ShowNewsQueue* )singleton;
- (NewsObject* )nextNews;
@end
