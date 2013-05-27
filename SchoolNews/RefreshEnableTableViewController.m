//
//  RefreshEnableTableViewController.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "RefreshEnableTableViewController.h"
#import "NSDate-Compare.h"

@interface RefreshEnableTableViewController ()

- (void)updateTheFootViewFrame;
- (void)sortTheKey;

- (void)updateTableViewDataSource;//当下拉时调用的函数
//- (void)doneUpdateLoadingTableViewData;//调用此函数时，下拉动画结束（一般通过|doneUpdateLoading:|调用）
- (void)doneUpdateLoading:(id )sender;//处理下拉时接受到的数据

- (void)loadMoreTableViewDataSource;//当上拉加载时调用的函数
//- (void)doneLoadMoreLoadingTableViewData;//调用此函数时，上拉加载动画结束（一般通过|doneLoadMore:|调用）
- (void)doneLoadMore:(id )sender;//处理上拉加载时接受到的数据，并调用|doneLoadMoreLoadingTableViewData|

- (void)applicationGotoBackground;//当程序进入后台

@end

@implementation RefreshEnableTableViewController
@synthesize showDataDictionary;
@synthesize allKeys = allKeys_;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //[self.tableView setFrame:frame];
        [self addObserver:self
               forKeyPath:@"showDataDictionary"
                  options:0
                  context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationGotoBackground)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        drop_ = DropNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    EGORefreshTableHeaderView* view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,0 - self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.delegate = self;
    [self.tableView addSubview:view];
    refreshTableHeaderView_ = view;
    
    EGORefreshTableFootView* footView = [[EGORefreshTableFootView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    footView.delegate = self;
    [self.tableView addSubview:footView];
    refreshTableFootView_ = footView;    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)notificationDoneUpdateLoading:(NSNotification* )notification
{
    
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"showDataDictionary"
                 context:nil];
}

- (void)goToDragDownState
{
    [self.tableView setContentOffset:CGPointMake(0, -80)
                            animated:YES];
}

- (void)goToDragUpState
{
    float height = self.tableView.bounds.size.height;
    float contentHeight = self.tableView.contentSize.height;
    [self.tableView setContentOffset:CGPointMake(0, contentHeight - height + 80)
                            animated:YES];
}
//------------------------------------------------------------------------------
#pragma mark data update
//update tableview data
- (void)updateTableViewDataSource
{
    reloading_ = YES;
    //do your things
    NSLog(@"beging update loading");
    [self updateTheData];
    //[NSThread sleepForTimeInterval:3];
    //[self performSelector:@selector(doneUpdateLoadingTableViewData) withObject:nil afterDelay:3.0];
    //[self performSelectorOnMainThread:@selector(doneUpdateLoadingTableViewData) withObject:nil waitUntilDone:NO];
}


// end update tableView data
- (void)doneUpdateLoadingTableViewData
{
    reloading_ = NO;
    NSLog(@"end update loading");
    [refreshTableHeaderView_ egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
}

//load more tableview data
- (void)loadMoreTableViewDataSource
{
    reloading_ = YES;
    //do your things to load more tableview data
    //[NSThread sleepForTimeInterval:3];
    [self loadMoreData];
    //[self performSelectorOnMainThread:@selector(doneLoadMoreLoadingTableViewData) withObject:nil waitUntilDone:NO];
}

//end load more tableview data
/*- (void)doneLoadMoreLoadingTableViewData
{
    reloading_ = NO;
    NSLog(@"end loadMore loading");
    [refreshTableFootView_ egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}*/

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	drop_ = DropDown;
	//[self updateTableViewDataSource];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self updateTableViewDataSource];
    });
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return reloading_; // should return if data source model is reloading
}

#pragma mark -
#pragma mark EGORefreshTableFootDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerLoadMore:(EGORefreshTableFootView*)view
{
    //[self loadMoreTableViewDataSource];
    drop_ = DropUp;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadMoreTableViewDataSource];
    });
	//[self performSelector:@selector(doneLoadMoreLoadingTableViewData) withObject:nil afterDelay:3.0];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoadingMore:(EGORefreshTableFootView*)view
{
    return reloading_;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    if (scrollView.contentOffset.y < 0)
    {
        [refreshTableHeaderView_ egoRefreshScrollViewDidScroll:scrollView];
    }
    else if (scrollView.contentOffset.y > self.tableView.contentSize.height - self.tableView.bounds.size.height)
    {
        [refreshTableFootView_ egoRefreshScrollViewDidScroll:scrollView];
    }
    [self updateTheFootViewFrame];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0)
    {
        [refreshTableHeaderView_ egoRefreshScrollViewDidEndDragging:scrollView];
    }
	else if (scrollView.contentOffset.y > self.tableView.contentSize.height - self.tableView.bounds.size.height)
    {
        [refreshTableFootView_ egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    if (scrollView.contentOffset.y < 0)
    {
        [refreshTableHeaderView_ egoRefreshScrollViewDidEndDragging:scrollView];
    }
	else if (scrollView.contentOffset.y > self.tableView.contentSize.height - self.tableView.bounds.size.height)
    {
        [refreshTableFootView_ egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
}

//------------------------------------------------------------------------------
#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"showDataDictionary"]) {
        allKeys_ = [self.showDataDictionary allKeys];
        [self sortTheKey];
        [self.tableView reloadData];
    }
}

//------------------------------------------------------------------------------

#pragma mark template method
- (void)doneUpdateLoading:(id )sender
{
    
}

- (void)doneLoadMore:(id )sender
{
    
}
#pragma mark private
- (void)updateTheFootViewFrame
{
    //NSLog(@"contentSize height:%g",self.tableView.contentSize.height);
    float y;
    if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
        y = self.tableView.frame.size.height;
    }
    else {
        y = self.tableView.contentSize.height;
    }
    [refreshTableFootView_ setFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height)];
}

- (void)updateTheData
{
    
}

- (void)loadMoreData
{
    
}

- (void)sortTheKey
{
    allKeys_  = [allKeys_ sortedArrayUsingSelector:@selector(compare:)];
}

- (void)endUpdateWithWebService:(NSNotification* )notification
{
    id data = [notification object];
    if (drop_ == DropDown) {
        dispatch_async(dispatch_get_main_queue(), ^{
            reloading_ = NO;
            NSLog(@"end update loading");
            [refreshTableHeaderView_ egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
            [self doneUpdateLoading:data];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            reloading_ = NO;
            NSLog(@"end loadMore loading");
            [refreshTableFootView_ egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
        [self doneLoadMore:data];
    }
}

//当程序进入后台时调用
- (void)applicationGotoBackground
{
    
}
@end
