//
//  NotificationCollectionCell.m
//  SchoolNews
//
//  Created by Jerry on 3月28星期四.
//
//

#import "NotificationCollectionCell.h"
#import "NotificationTableViewController.h"
#import "NotificationViewController.h"
@implementation NotificationCollectionCell
{
    NotificationTableViewController* notificationTableViewController;
    UIActivityIndicatorView* activityView;
    NSArray* types;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        [self addSubview:activityView];
        notificationTableViewController = [[NotificationTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [notificationTableViewController.tableView setFrame:self.bounds];
        notificationTableViewController.delegate = [NotificationViewController singleton];
        [self addSubview:notificationTableViewController.tableView];
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"NotificationSubtitle" ofType:@"plist"];
        types = [NSArray arrayWithContentsOfFile:filePath];
    }
    return self;
}

- (void)setItem:(int)item
{
    NSString* type = [types objectAtIndex:item];
    [activityView startAnimating];
    [notificationTableViewController setNotificationTableTitle:type];
}


- (void)clearTheData
{
    [activityView stopAnimating];
    notificationTableViewController.showDataDictionary = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)refreshTheTableView
{
    [notificationTableViewController goToDragDownState];
}

@end
