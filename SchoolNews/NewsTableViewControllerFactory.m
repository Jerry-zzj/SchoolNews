//
//  NewsTableViewControllerFactory.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "NewsTableViewControllerFactory.h"
#import "YaowenTableViewController.h"
#import "ZonggeNewsTableViewController.h"
@implementation NewsTableViewControllerFactory

NewsTableViewControllerFactory* g_NewsTableViewControllerFactory;
+ (NewsTableViewControllerFactory* )singleton
{
    if (g_NewsTableViewControllerFactory == nil) {
        g_NewsTableViewControllerFactory = [[NewsTableViewControllerFactory alloc] init];
    }
    return g_NewsTableViewControllerFactory;
}

- (NewsTableViewController* )produceTheNewsTableViewWithIdentifier:(NSString* )identifier
{
    if ([identifier isEqualToString:@"传媒要闻"]) {
        return [YaowenTableViewController singleton];
    }
    else if([identifier isEqualToString:@"综合新闻"])
    {
        return [ZonggeNewsTableViewController singleton];
    }
    return nil;

}
@end
