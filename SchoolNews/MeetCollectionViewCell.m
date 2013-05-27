//
//  MeetCollectionViewCell.m
//  SchoolNews
//
//  Created by Jerry on 3月25星期一.
//
//

#import "MeetCollectionViewCell.h"
#import "MeetsData.h"
#import "PublicDefines.h"
#import "MeetObject.h"
#import <QuartzCore/QuartzCore.h>
#import "MeetsViewController.h"

@interface MeetCollectionViewCell(privateAPI)

- (void)addDateTableHeaderView;

@end

@implementation MeetCollectionViewCell
{
    MeetListTableViewController* meetListTableViewController;
    UILabel* weekdayLabel_;
    UILabel* noMeetingLabel_;
    UIActivityIndicatorView* activityView;
    MeetWebService* meetWebservice;
}
@synthesize savedWeek;
@synthesize savedWeekday;
#define WEEKDAY_LABEL_HEIGHT                            30
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        weekdayLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, self.bounds.size.width, WEEKDAY_LABEL_HEIGHT)];
        [weekdayLabel_ setTextAlignment:NSTextAlignmentCenter];
        [weekdayLabel_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:weekdayLabel_];
        meetListTableViewController = [[MeetListTableViewController alloc]
                                       initWithStyle:UITableViewStylePlain
                                               Frame:CGRectMake(0, WEEKDAY_LABEL_HEIGHT - 6, self.bounds.size.width, self.bounds.size.height - WEEKDAY_LABEL_HEIGHT)];
        UIImageView* tableBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-3, WEEKDAY_LABEL_HEIGHT - 10, self.bounds.size.width + 12, self.bounds.size.height - WEEKDAY_LABEL_HEIGHT + 15)];
        UIImage* backgroundImage = [UIImage imageNamed:@"会议内容背景-4.png"];
        [tableBackgroundImageView setImage:backgroundImage];
        [self.contentView addSubview:tableBackgroundImageView];
        [meetListTableViewController.tableView setBackgroundView:nil];
        [meetListTableViewController.tableView setBackgroundColor:[UIColor clearColor]];
        [meetListTableViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        meetListTableViewController.view.layer.cornerRadius = 6;
        meetListTableViewController.view.layer.masksToBounds = YES;
        //meetListTableViewController.view.userInteractionEnabled = NO;
        meetListTableViewController.delegate = [MeetsViewController singleton];
        [self.contentView addSubview:meetListTableViewController.view];
        
        meetWebservice = [[MeetWebService alloc] init];
        
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:activityView];
        [activityView stopAnimating];
    }
    return self;
}

- (void)setWeek:(int )week AndWeekday:(int )weekday
{
    self.savedWeek = week;
    self.savedWeekday = weekday;
    NSArray* weekdayArray = [NSArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日", nil];
    NSString* title = [NSString stringWithFormat:@"%@",[weekdayArray objectAtIndex:weekday - 1]];
    [weekdayLabel_ setText:title];
    [weekdayLabel_ setFont:[UIFont systemFontOfSize:13]];
    [weekdayLabel_ setTextColor:[UIColor whiteColor]];
    NSDictionary* meetsDictionary = [[MeetsData singleton] getMeetDataForWeek:week AndWeekday:weekday];
    if (meetsDictionary == nil) {
        //会议数据为空
        [activityView startAnimating];
        meetWebservice.delegate = self;
        NSString* urlString = [NSString stringWithFormat:@"%@/axis2/services/MeetService/getMeetJustContent?week=%i&weekday=%i",WEBSERVICE_DOMAIN,week,weekday];
        [meetWebservice setURLWithString:urlString];
        [meetWebservice getWebServiceData];
    }
    else
    {
        meetListTableViewController.showDataDictionary = meetsDictionary;
        [self addDateTableHeaderView];
    }
}

- (void)clearData
{
    [weekdayLabel_ setText:@""];
    meetListTableViewController.showDataDictionary = nil;
}

- (void)refreshData
{
    [meetListTableViewController.tableView reloadData];
}

#pragma mark meetwebservice delegate
- (void)finishGetMeetData:(id)sender
{
    NSArray* meets = (NSArray* )sender;
    NSMutableDictionary* oldShowDictionary = [NSMutableDictionary dictionary];
    for (MeetObject* meet in meets) {
        NSDate* date = meet.date;
        if ([[oldShowDictionary allKeys] containsObject:date]) {
            NSMutableArray* meetsInDate = [oldShowDictionary objectForKey:date];
            BOOL add = YES;
            for (MeetObject* meetInOld in meetsInDate) {
                if ([meetInOld.ID isEqualToString:meet.ID]) {
                    add = NO;
                    break;
                }
            }
            if (add) {
                [meetsInDate addObject:meet];
            }
        }
        else
        {
            NSMutableArray* meetsInDate = [NSMutableArray array];
            [meetsInDate addObject:meet];
            [oldShowDictionary setObject:meetsInDate forKey:date];
        }
    }
    [[MeetsData singleton] setMeetData:oldShowDictionary ForWeek:self.savedWeek Weekday:self.savedWeekday];
    meetListTableViewController.showDataDictionary = oldShowDictionary;
    [self addDateTableHeaderView];
    [activityView stopAnimating];
}

//增加日期，同时判断是否有会议
- (void)addDateTableHeaderView
{
    NSDictionary* meetData = meetListTableViewController.showDataDictionary;
    if ([meetData count] == 0) {
        //没有会议;
        if (noMeetingLabel_ == nil) {
            noMeetingLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, 30)];
            [noMeetingLabel_ setText:@"今天没有会议"];
            [noMeetingLabel_ setTextAlignment:NSTextAlignmentCenter];
            [noMeetingLabel_ setTextColor:[UIColor whiteColor]];
            [noMeetingLabel_ setBackgroundColor:[UIColor clearColor]];
            [noMeetingLabel_ setHighlighted:YES];
            [self addSubview:noMeetingLabel_];
        }
        else
        {
            noMeetingLabel_.hidden = NO;
        }
    }
    else
    {
        if (noMeetingLabel_ != nil) {
            noMeetingLabel_.hidden = YES;
        }
    }
    NSDate* date = [[MeetsData singleton] getDateForWeek:self.savedWeek
                                                 weekDay:self.savedWeekday];
    NSString* dateString = [[date description] substringToIndex:10];
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setText:dateString];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setFont:[UIFont systemFontOfSize:13]];
    [meetListTableViewController.tableView setTableHeaderView:headerLabel];
}

@end
