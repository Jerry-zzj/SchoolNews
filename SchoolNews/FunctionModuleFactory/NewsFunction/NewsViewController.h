//
//  NewsViewController.h
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubtitleViewController.h"
#import "NewsTableViewController.h"
#import "FunctionViewController.h"
//@class SubtitleView;
@protocol NewsViewControllerDelegate <NSObject>

@end

@class SubtitleViewController;
@interface NewsViewController : FunctionViewController<SubtitleViewControllerDelegate,UIScrollViewDelegate,NewsTableViewControllerDelegate>
{
    SubtitleViewController* subtitleViewController_;
    NSArray* allsubtitleTableViewArray_;
    NSMutableDictionary* showSubtitleTableViewDictionary_;
    UIScrollView* newsBackgoundScrollView_;
}
+ (NewsViewController* )singleton;
- (void)selectTheNews:(NewsObject* )sender;
@end
