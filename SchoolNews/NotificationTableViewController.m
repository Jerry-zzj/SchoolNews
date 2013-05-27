//
//  NotificationTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 12月29星期六.
//
//

#import "NotificationTableViewController.h"
#import "NotificationCell.h"
#import "NotificationObject.h"
#import "WebServiceFactory.h"
#import "NotificationBuffer.h"
#import "DataBaseOperating.h"
#import "NotificationWebService.h"
#import "PublicDefines.h"
#import "NotificationData.h"
@interface NotificationTableViewController ()

- (void)loadInitialNotifications;
- (void)doWebServiceWithLastDate:(NSString* )correctLastDateString;
- (void)addNotifications:(id )sender;

@end

@implementation NotificationTableViewController
{
    NSString* notificationTitle;
    NotificationWebService* notificationWebService;
    NSArray* types;
}
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        notificationWebService = (NotificationWebService* )[[WebServiceFactory singleton] produceTheWebService:NOTIFICATION_WEBSERVICE];
        notificationWebService.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(endUpdateWithWebService:)
                                                     name:NOTIFICATION_END_UPDATE_WITH_WEBSERVICE
                                                   object:nil];
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"NotificationSubtitle" ofType:@"plist"];
        types = [[NSArray alloc] initWithContentsOfFile:filePath];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setNotificationTableTitle:(NSString* )sender
{
    notificationTitle = [sender copy];
    NSDictionary* showData = [[NotificationData singleton] getNotificationForTitle:sender];
    if (showData == nil) {
        [self.tableView setHidden:YES];
        [self loadInitialNotifications];
    }
    else
    {
        self.showDataDictionary = showData;
        [self.tableView setHidden:NO];
    }
}

#pragma mark webservice delegate
- (void)getNotifications:(id)sender
{
    [[NotificationData singleton] addNotifications:sender ForTitle:notificationTitle];
    NSDictionary* notificationData = [[NotificationData singleton] getNotificationForTitle:notificationTitle];
    self.showDataDictionary = notificationData;
    [self.tableView setHidden:NO];
}

#pragma mark table DataSource
- (int )numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.showDataDictionary count];
}

- (int )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* notifications = [self.showDataDictionary objectForKey:key];
    return [notifications count];
}

- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*int section = [indexPath section];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* notifications = [self.showDataDictionary objectForKey:key];
    int row = [indexPath row];
    NotificationObject* notification = [notifications objectAtIndex:row];
    NSString* title = notification.title;
    
    CGSize tempSize = CGSizeMake(320, 1000);
    UIFont* font = [UIFont systemFontOfSize:17];
    CGSize size = [title sizeWithFont:font
                    constrainedToSize:tempSize
                        lineBreakMode:NSLineBreakByCharWrapping];
    return size.height + 40;*/
    return 77.5;
}


- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"NotificationCellIdentifier";
    NotificationCell* notificationCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (notificationCell == nil) {
        notificationCell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    int section = [indexPath section];
    int row = [indexPath row];
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSArray* notifications = [self.showDataDictionary objectForKey:key];
    NotificationObject* notification = [notifications objectAtIndex:row];
    notificationCell.notificationTitleLabel.text = notification.title;
    notificationCell.dateLabel.text = [[key description] substringToIndex:10];
    NSString* department = [NSString stringWithFormat:@"发布部门：%@",notification.department];
    notificationCell.departmentLabel.text = department;
    return notificationCell;
}

#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* notifications = [self.showDataDictionary objectForKey:key];
    NotificationObject* notification = [notifications objectAtIndex:row];
    [self.delegate selectTheNotification:notification];
}

#pragma mark template Method implementation
- (void)doneUpdateLoading:(id )sender
{
    [self addNotifications:sender];
}

- (void)doneLoadMore:(id )sender
{
    [self addNotifications:sender];
}

#pragma mark data update
- (void)updateTheData
{
    //根据第一条信息的日期进行比此日期更新的通知的更新
    NSDate* firstDate = [allKeys_ objectAtIndex:0];
    NSString* firstDateString = [[firstDate description] substringToIndex:19];
    NSString* firstDateStringWithouSpace = [firstDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    int typeNumber = [types indexOfObject:notificationTitle] + 1;
    NSString* urlString = GET_NEWER_NOTIFICATION(firstDateStringWithouSpace,typeNumber);
    //NSString* urlString = [NSString stringWithFormat:@"%@%@%@&type=%i",WEBSERVICE_DOMAIN,@"/axis2/services/NotificationService/getNewerNotificationWithoutContent?date=",firstDateStringWithouSpace,typeNumber];
    NSLog(@"%@",urlString);
    //notificationWebService = (NotificationWebService* )[[WebServiceFactory singleton] produceTheWebService:NOTIFICATION_WEBSERVICE];
    //notificationWebService.delegate = self;
    [notificationWebService setURLWithString:urlString];
    [notificationWebService getWebServiceData];
}

- (void)loadMoreData
{
    NSDate* lastDate = [allKeys_ lastObject];
    //NSArray* newsArray = [[NotificationBuffer singleton] getDataInBufferWithIdentifier:@"Notification"];
    NSArray* newsArray = nil;
    if (newsArray == nil) {
        NSString* lastDateString = [[lastDate description] substringToIndex:19];
        NSString* correctLastDateString = [lastDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [self doWebServiceWithLastDate:correctLastDateString];
        return;
    }
    NotificationObject* earliestNotificationsInBuffer = [newsArray lastObject];
    //NSString* test = earliestNotificationsInBuffer.title;
    NSDate* earliestDateInBuffer = earliestNotificationsInBuffer.date;
    NSArray* earliestNotificationsInSelfArray = [self.showDataDictionary objectForKey:[allKeys_ lastObject]];
    NotificationObject* earliestNotificationsInSelf = [earliestNotificationsInSelfArray lastObject];
    NSDate* earliestDateInSelf = earliestNotificationsInSelf.date;
    
    if ([earliestDateInBuffer earlierDate:earliestDateInSelf] == earliestDateInSelf) {
        [self doneLoadMore:newsArray];
    }
    else
    {
        //缓存区里的数据已过时，清空缓存区
        NSString* bufferName = [NSString stringWithFormat:@"Notification"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearBuffer"
                                                            object:bufferName];
        //通过webService获得更老的数据
        NSString* lastDateString = [[lastDate description] substringToIndex:19];
        NSString* correctLastDateString = [lastDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [self doWebServiceWithLastDate:correctLastDateString];
    }

}

- (void)doWebServiceWithLastDate:(NSString* )sender
{
    int typeNumber = [types indexOfObject:notificationTitle] + 1;
    NSString* urlString = GET_EARILER_NOTIFIcATION(sender,typeNumber);
    //NSString* urlString = [NSString stringWithFormat:@"%@%@%@&type=%i",WEBSERVICE_DOMAIN,@"/axis2/services/NotificationService/getEarlierNotificationWithoutContent?date=",sender,typeNumber];
    NSLog(@"%@",urlString);
    //notificationWebService = (NotificationWebService* )[[WebServiceFactory singleton] produceTheWebService:NOTIFICATION_WEBSERVICE];
    //notificationWebService.delegate = self;
    [notificationWebService setURLWithString:urlString];
    [notificationWebService getWebServiceData];
}

- (void)addNotifications:(id )sender
{
    NSArray* notifications = (NSArray* )sender;
    for (NotificationObject* notification in notifications) {
        NSDate* date = notification.date;
        NSMutableDictionary* oldShowDictionary = [NSMutableDictionary dictionaryWithDictionary:self.showDataDictionary];
        if ([allKeys_ containsObject:date]) {
            NSMutableArray* notifictionsInDate = [oldShowDictionary objectForKey:date];
            BOOL add = YES;
            for (NotificationObject* notificationInOld in notifictionsInDate) {
                if ([notificationInOld.ID isEqualToString:notification.ID]) {
                    add = NO;
                    break;
                }
            }
            if (add) {
                [notifictionsInDate addObject:notification];
            }
        }
        else
        {
            NSMutableArray* notificationsInDate = [NSMutableArray array];
            [notificationsInDate addObject:notification];
            [oldShowDictionary setObject:notificationsInDate forKey:date];
        }
        self.showDataDictionary = oldShowDictionary;
        [self.tableView setHidden:NO];
    }
}

- (void)loadInitialNotifications
{
    NSDate* today = [NSDate date];
    NSString* firstDateString = [[today description] substringToIndex:19];
    NSString* firstDateStringWithouSpace = [firstDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    int typeNumber = [types indexOfObject:notificationTitle] + 1;
    //NSString* urlString = [NSString stringWithFormat:@"%@%@%@&type=%i",WEBSERVICE_DOMAIN,@"/axis2/services/NotificationService/getEarlierNotificationWithoutContent?date=",firstDateStringWithouSpace,typeNumber];
    NSString* urlString = GET_EARILER_NOTIFIcATION(firstDateStringWithouSpace,typeNumber);
    NSLog(@"%@",urlString);
    [notificationWebService setURLWithString:urlString];
    [notificationWebService getWebServiceData];
}
@end
