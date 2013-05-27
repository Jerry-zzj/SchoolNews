//
//  NewsTableViewControllerFactory.h
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsTableViewController;
@interface NewsTableViewControllerFactory : NSObject

+ (NewsTableViewControllerFactory* )singleton;
- (NewsTableViewController* )produceTheNewsTableViewWithIdentifier:(NSString* )identifier;

@end
