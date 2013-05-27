//
//  NewsTableViewController.h
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "RefreshEnableTableViewController.h"
#import "NewsObject.h"
#import "NewsBuffer.h"
#import "NewsWebService.h"
#import "FirstRowImageCell.h"
@class NewsTableViewController;
@protocol NewsTableViewControllerDelegate<NSObject>

- (void)tableViewController:(NewsTableViewController* )tableViewController selectedTheIndexPath:(NSIndexPath* )indexpath News:(NewsObject* )news;

@end
@interface NewsTableViewController : RefreshEnableTableViewController<FirstRowImageCellDelegate>
@property (nonatomic,assign)id<NewsTableViewControllerDelegate> delegate;
@end
