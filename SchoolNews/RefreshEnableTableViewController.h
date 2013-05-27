//
//  RefreshEnableTableViewController.h
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFootView.h"
typedef enum{
    DropDown,
    DropUp,
    DropNone
}Drop;
@class EGORefreshTableHeaderView;
@class EGORefreshTableFootView;
@interface RefreshEnableTableViewController : UITableViewController<EGORefreshTableHeaderDelegate,EGORefreshTableFootDelegate>
{
    EGORefreshTableHeaderView* refreshTableHeaderView_;
    BOOL reloading_;
    EGORefreshTableFootView* refreshTableFootView_;
    NSArray* allKeys_;
    Drop drop_;
}

@property (nonatomic,strong) NSDictionary* showDataDictionary;
@property (nonatomic,retain) NSArray* allKeys;
- (id)initWithStyle:(UITableViewStyle)style;

- (void)updateTheData;
- (void)loadMoreData;
- (void)notificationDoneUpdateLoading:(NSNotification* )notification;


- (void)updateTheFootViewFrame;

//code to drag
- (void)goToDragDownState;
- (void)goToDragUpState;
//
//Template Method
- (void)doneUpdateLoading:(id )sender;

- (void)doneLoadMore:(id )sender;
//
@end