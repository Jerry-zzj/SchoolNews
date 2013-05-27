//
//  EmploymentListTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月10星期三.
//
//

#import "EmploymentListTableViewController.h"
#import "WebServiceFactory.h"
#import "EmploymentData.h"
#import "JobObject.h"
#import "EmploymentCell.h"
#import "UsersInformation.h"

@interface EmploymentListTableViewController ()

- (void)loadInitialEmployment;
- (void)doWebServiceWithLastDate:(NSString* )correctLastDateString;
- (void)addEmployments:(id )sender;
- (NSString* )getNewerURLWithDate:(NSString* )date;
- (NSString* )getEarlierURLWithDate:(NSString* )date;

@end

@implementation EmploymentListTableViewController
{
    EmploymentWebservice* webservice;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        webservice = (EmploymentWebservice* )[[WebServiceFactory singleton] produceTheWebService:EMPLOYMENT_WEBSERVICE];
        webservice.delegate = self;
        
        /*[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(endUpdateWithWebService:)
                                                     name:NOTIFICATION_END_UPDATE_WITH_WEBSERVICE
                                                   object:nil];*/
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInitialEmployment];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[UsersInformation singleton].userRightFunctionSet containsObject:self.title]) {
        if ([self.view.subviews containsObject:coverImageView_]) {
            [coverImageView_ removeFromSuperview];
        }
        coverImageView_ = nil;
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        if (coverImageView_ == nil) {
            coverImageView_ = [[UIImageView alloc] initWithFrame:self.view.bounds];
            [coverImageView_ setImage:[UIImage imageNamed:@"登录界面蓝.png"]];
        }
        if (![self.view.subviews containsObject:coverImageView_]) {
            [self.view addSubview:coverImageView_];
        }
        self.tableView.scrollEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setEmploymentTableType:(NSString* )sender
{
    NSDictionary* showData = [[EmploymentData singleton] getDataForType:sender];
    if (showData == nil) {
        [self.tableView setHidden:YES];
        [self loadInitialEmployment];
    }
    else
    {
        self.showDataDictionary = showData;
        [self.tableView setHidden:NO];
    }
}

- (NSString* )getType
{
    return type_;
}

#pragma mark SubFunction Procorol
- (NSString* )getSubFunctionCode
{
    return nil;
}
#pragma mark webservice delegate
- (void)finishGetEmploymentData:(id)sender
{
    [self performSelector:@selector(endUpdateWithWebService:) withObject:nil];
    [[EmploymentData singleton] addEmploymentDatas:sender ForType:type_];
    NSDictionary* employmentData = [[EmploymentData singleton] getDataForType:type_];
    self.showDataDictionary = employmentData;
    [self.tableView setHidden:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.showDataDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* notifications = [self.showDataDictionary objectForKey:key];
    return [notifications count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"NotificationCellIdentifier";
    EmploymentCell* employmentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (employmentCell == nil) {
        employmentCell = [[EmploymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    int section = [indexPath section];
    int row = [indexPath row];
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSArray* employments = [self.showDataDictionary objectForKey:key];
    JobObject* job = [employments objectAtIndex:row];
    employmentCell.jobTitleLabel.text = job.title;
    employmentCell.dateLabel.text = [[key description] substringToIndex:10];
    NSString* department = [NSString stringWithFormat:@"发布部门：%@",job.releasePerson];
    employmentCell.departmentLabel.text = department;
    return employmentCell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    int section = [indexPath section];
    int row = [indexPath row];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* jobs = [self.showDataDictionary objectForKey:key];
    JobObject* job = [jobs objectAtIndex:row];
    [self.delegate selectTheEmployment:job];
}

#pragma mark template method implenmentation
- (void)doneUpdateLoading:(id )sender
{
    [self addEmployments:sender];
}

- (void)doneLoadMore:(id )sender
{
    [self addEmployments:sender];
}

#pragma mark data update
- (void)updateTheData
{
    //根据第一条信息的日期进行比此日期更早的新闻的更新
    NSDate* firstDate = [allKeys_ objectAtIndex:0];
    NSString* firstDateString = [[firstDate description] substringToIndex:19];
    NSString* firstDateStringWithouSpace = [firstDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString* urlString = [self getNewerURLWithDate:firstDateStringWithouSpace];
    NSLog(@"%@",urlString);
    [webservice setURLWithString:urlString];
    [webservice getWebServiceData];
}

- (void)loadMoreData
{
    NSDate* lastDate = [allKeys_ lastObject];
    //NSArray* newsArray = [[NotificationBuffer singleton] getDataInBufferWithIdentifier:@"Notification"];
    NSArray* jobArrays = nil;
    if (jobArrays == nil) {
        NSString* lastDateString = [[lastDate description] substringToIndex:19];
        NSString* correctLastDateString = [lastDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [self doWebServiceWithLastDate:correctLastDateString];
        return;
    }
    JobObject* earliestJobInBuffer = [jobArrays lastObject];
    //NSString* test = earliestNotificationsInBuffer.title;
    NSDate* earliestDateInBuffer = earliestJobInBuffer.date;
    NSArray* earliestNotificationsInSelfArray = [self.showDataDictionary objectForKey:[allKeys_ lastObject]];
    JobObject* earliestJobInSelf = [earliestNotificationsInSelfArray lastObject];
    NSDate* earliestDateInSelf = earliestJobInSelf.date;
    
    if ([earliestDateInBuffer earlierDate:earliestDateInSelf] == earliestDateInSelf) {
        [self doneLoadMore:jobArrays];
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
    NSString* urlString = [self getEarlierURLWithDate:sender];
    NSLog(@"%@",urlString);
    [webservice setURLWithString:urlString];
    [webservice getWebServiceData];
}

- (void)addEmployments:(id )sender
{
    NSArray* jobs = (NSArray* )sender;
    for (JobObject* job in jobs) {
        NSDate* date = job.date;
        NSMutableDictionary* oldShowDictionary = [NSMutableDictionary dictionaryWithDictionary:self.showDataDictionary];
        if ([allKeys_ containsObject:date]) {
            NSMutableArray* jobsInDate = [oldShowDictionary objectForKey:date];
            BOOL add = YES;
            for (JobObject* jobInOld in jobsInDate) {
                if ([jobInOld.ID isEqualToString:job.ID]) {
                    add = NO;
                    break;
                }
            }
            if (add) {
                [jobsInDate addObject:job];
            }
        }
        else
        {
            NSMutableArray* jobsInDate = [NSMutableArray array];
            [jobsInDate addObject:job];
            [oldShowDictionary setObject:jobsInDate forKey:date];
        }
        self.showDataDictionary = oldShowDictionary;
        [self.tableView setHidden:NO];
    }
}

- (NSString* )getNewerURLWithDate:(NSString* )date
{
    return nil;
}

- (NSString* )getEarlierURLWithDate:(NSString* )date
{
    return nil;
}

- (void)loadInitialEmployment;
{
    NSDate* today = [NSDate date];
    NSString* firstDateString = [[today description] substringToIndex:19];
    NSString* firstDateStringWithouSpace = [firstDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString* urlString = [self getEarlierURLWithDate:firstDateStringWithouSpace];
    [webservice setURLWithString:urlString];
    [webservice getWebServiceData];
}


@end
