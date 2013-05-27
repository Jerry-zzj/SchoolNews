//
//  ShowNewsQueue.m
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import "ShowNewsQueue.h"

@interface ShowNewsQueue(private)

- (void)updateTheNewsQueue:(NSNotification* )sender;

@end

@implementation ShowNewsQueue
@synthesize showingIndex;
@synthesize newsQueue;
ShowNewsQueue* g_ShowNewsQueue;
+ (ShowNewsQueue* )singleton
{
    if (g_ShowNewsQueue == nil) {
        g_ShowNewsQueue = [[ShowNewsQueue alloc] init];
    }
    return g_ShowNewsQueue;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTheNewsQueue:)
                                                     name:@"UpdateNewsQueue"
                                                   object:nil];
    }
    return self;
}

- (NewsObject* )nextNews
{
    self.showingIndex ++;
    NSLog(@"%i",self.showingIndex);
    if (self.showingIndex >= [self.newsQueue count]) {
        return nil;
    }
    NewsObject* news = [self.newsQueue objectAtIndex:self.showingIndex];
    return news;
}

- (void)updateTheNewsQueue:(NSNotification* )sender
{
    NSDictionary* object = [sender object];
    NSMutableArray* showingNewsQueue = [object objectForKey:@"ShowingNewsQueue"];
    NSNumber* index = [object objectForKey:@"ShowingIndex"];
    self.showingIndex = [index intValue];
    self.newsQueue = showingNewsQueue;
}


@end
