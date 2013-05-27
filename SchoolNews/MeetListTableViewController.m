//
//  AllMeetListTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import "MeetListTableViewController.h"
#import "MeetObject.h"
#import "MeetBuffer.h"
#import "DataBaseOperating.h"
#import "WebServiceFactory.h"
#import "MeetWebService.h"
#import "MeetCell.h"
#import "SVProgressHUD.h"
#import "PublicDefines.h"
#import "NSDate-Compare.h"
#import "MeetData.h"
@interface MeetListTableViewController ()

- (MeetObject* )getMeetAtIndexPath:(NSIndexPath* )indexPath;

- (NSString* )doGetUpdateURL;

//收到加载会议的通知之后
- (void)loadTheMeet:(NSNotification* )sender;
//webservice收完数据之后
- (void)getMeetWithWebservice:(NSNotification* )notification;
@end

@implementation MeetListTableViewController
@synthesize week = week_;
@synthesize weekday = weekday_;
-(id)initWithStyle:(UITableViewStyle)style Frame:(CGRect)frame
{
    self = [super initWithStyle:style Frame:frame];
    if (self) {
        [MeetBuffer singleton];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getMeetWithWebservice:)
                                                     name:MEET_END_UPDATE_WITH_WEBSERVICE
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadTheMeet:)
                                                     name:@"ToLoadMeet"
                                                   object:nil];
        [self.tableView setFrame:frame];
        
    }
    return self;
}

- (void)updateTheDataWithWeek:(int )week Weekday:(NSString* )weekday
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (int )getWeek
{
    return week_;
}

- (int )getWeekday
{
    return weekday_;
}

#pragma mark table DataSource
- (int )numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allKeys_ count];
}

- (int )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSArray* meets = [self.showDataDictionary objectForKey:key];
    return [meets count];
}

/*- (NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate* date = [allKeys_ objectAtIndex:section];
    NSString* dateString = [[date description] substringWithRange:NSMakeRange(11, 8)];
    return dateString;
}*/

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [label setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:13]];
    NSDate* date = [allKeys_ objectAtIndex:section];
    NSString* dateString = [[date description] substringWithRange:NSMakeRange(11, 8)];
    [label setText:[NSString stringWithFormat:@"   %@",dateString]];
    return label;
}

- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*MeetObject* meet = [self getMeetAtIndexPath:indexPath];
    NSString* content = meet.content;
    
    CGSize tempSize = CGSizeMake(320, 1000);
    UIFont* font = [UIFont systemFontOfSize:17];
    CGSize size = [content sizeWithFont:font
                      constrainedToSize:tempSize
                          lineBreakMode:NSLineBreakByCharWrapping];
    if (size.height < 44) {
        return 44;
    }
    return size.height;*/
    return 44;
}


- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"MeetCellIdentifier";
    MeetCell* meetCell = (MeetCell* )[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (meetCell == nil) {
        meetCell = [[MeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    MeetObject* meet = [self getMeetAtIndexPath:indexPath];
    meetCell.textLabel.text = meet.content;
    [meetCell.textLabel setFont:[UIFont systemFontOfSize:12]];
    return meetCell;
}

#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetObject* meet = [self getMeetAtIndexPath:indexPath];
    [self.delegate selectTheMeet:meet];
}

#pragma mark data update
- (void)updateTheData
{
    //更新当天会议
    self.showDataDictionary = nil;
    NSString* urlString = [self doGetUpdateURL];
    WebService* notificationWebService = [[WebServiceFactory singleton] produceTheWebService:MEET_WEBSERVICE];
    [notificationWebService setURLWithString:urlString];
    [notificationWebService getWebServiceData];
}

- (MeetObject* )getMeetAtIndexPath:(NSIndexPath* )indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSArray* meets = [self.showDataDictionary objectForKey:key];
    MeetObject* meet = [meets objectAtIndex:row];
    return meet;
}

- (NSString* )doGetUpdateURL
{
    return nil;
}

- (void)loadTheMeet:(NSNotification* )sender
{
    NSDictionary* dictionary = [sender object];
    NSNumber* weekNumber = [dictionary objectForKey:@"Week"];
    if (weekNumber == nil) {
        week_ = 0;
    }
    else
    {
        week_ = [weekNumber intValue];
    }
    NSNumber* weekdayNumber = [dictionary objectForKey:@"Weekday"];
    if (weekdayNumber == nil) {
        weekday_ = 0;
    }
    else
    {
        weekday_ = [weekdayNumber intValue];
    }
    MeetData* meetsData = [MeetData singleton];
    NSArray* meets = [meetsData getMeetForWeek:week_ Weekday:weekday_];
    if (meets != nil && [meets count] > 0) {
        self.showDataDictionary = nil;
    }
    else
    {
        loading_ = YES;
        MeetListTableViewController* showMeetListTableView = [dictionary objectForKey:@"ShowMeetList"];
        if (showMeetListTableView == self) {
            [self updateTheData];
        }
        //[SVProgressHUD showWithStatus:@"加载中。。。"];
    }
}

//webservice收完数据之后
- (void)getMeetWithWebservice:(NSNotification* )notification
{
    //self.showDataDictionary = nil;
    NSArray* meets = (NSArray* )[notification object];
    if (meets != nil && loading_) {
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    }
    else if (meets == nil && loading_)
    {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }
    NSMutableDictionary* oldShowDictionary = [NSMutableDictionary dictionary];
    for (MeetObject* meet in meets) {
        NSDate* date = meet.date;
        //NSMutableDictionary* oldShowDictionary = [NSMutableDictionary dictionary];
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
    self.showDataDictionary = oldShowDictionary;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMeetFinish" object:nil];
}

//将置顶属性为YES的新闻放在第一行，
- (void)sortTheKey
{
    allKeys_ = [allKeys_ sortedArrayUsingSelector:@selector(otherCompare:)];
}
@end
