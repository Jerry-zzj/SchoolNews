//
//  MeetShowViewController.m
//  SchoolNews
//
//  Created by Jerry on 1月10星期四.
//
//

#import "MeetShowViewController.h"
#import "WebServiceFactory.h"
#import "MeetShowWebService.h"
#import "PublicDefines.h"
#import "MeetData.h"
@interface MeetShowViewController (private)

- (void)loadTheMeetInformationWithMeet:(MeetObject* )sender;

- (void)toShowTheMeet;

@end

@implementation MeetShowViewController
- (id)initWithShowMeet:(MeetObject* )meet
{
    self = [super init];
    if (self) {
        showTableView_ = [[FixedSequenceTableViewController alloc] initWithStyle:UITableViewStyleGrouped Frame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
        showTableView_.touchMoveDelegate = self;
        [self addChildViewController:showTableView_];
        [self.view addSubview:showTableView_.tableView];
        [self addObserver:self
               forKeyPath:@"meet_"
                  options:0
                  context:nil];
        [self loadTheMeetInformationWithMeet:meet];

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"meet_"];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"meet_"]) {
        [self toShowTheMeet];
    }
}

#pragma mark webservice callback
- (void)loadTheMeet:(id)sender
{
    MeetObject* meet = (MeetObject* )sender;
    [self setValue:sender forKeyPath:@"meet_"];
    NSString* weekday = meet.weekDay;
    NSArray* weekdayArray = [NSArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日", nil];
    int weekdayInt = [weekdayArray indexOfObject:weekday] + 1;
    int week = meet.week;
    NSDictionary* notificationObject = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:weekdayInt],@"weekday",[NSNumber numberWithInt:week],@"week",meet,@"meet", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAMeet" object:notificationObject];
    //
    /*meet_.week = meet.week;
    meet_.place = meet.place;
    meet_.weekDay = meet.weekDay;
    meet_.content = meet.content;
    meet_.host = meet.host;
    meet_.executiveDepartments = meet.executiveDepartments;
    meet_.participants = meet.participants;*/
    [self setValue:meet forKeyPath:@"meet_"];
}


#pragma move touch
- (void)moveToLeft
{

}

- (void)moveToRight
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark private
- (void)loadTheMeetInformationWithMeet:(MeetObject* )sender
{
    NSString* senderID = sender.ID;
    NSArray* weekdayArray = [NSArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日", nil];
    int weekday = [weekdayArray indexOfObject:sender.weekDay] + 1;
    int week = sender.week;
    MeetObject* meetFromMeetData = [[MeetData singleton] getMeetForID:senderID AndWeek:week AndWeekday:weekday];
    if (meetFromMeetData.executiveDepartments == nil && meetFromMeetData.host == nil && meetFromMeetData.participants == nil) {
        //数据补全，webservice获取
        NSString* urlString = [NSString stringWithFormat:@"%@/axis2/services/MeetService/getMeetWithID?ID=%@",WEBSERVICE_DOMAIN,sender.ID];
        WebService* meetShowWebService = [[WebServiceFactory singleton] produceTheWebService:MEET_SHOW_WEBSERVICE];
        [(MeetShowWebService* )meetShowWebService setDelegate:self];
        [meetShowWebService setURLWithString:urlString];
        [meetShowWebService getWebServiceData];
    }
    else
    {
        [self setValue:meetFromMeetData forKeyPath:@"meet_"];
    }
}

- (void)toShowTheMeet
{
    NSArray* weekdayArray = [NSArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日", nil];
    NSMutableDictionary* toShowData = [NSMutableDictionary dictionary];
    NSMutableArray* tempAllKeys = [NSMutableArray array];
    if (meet_.date != nil) {
        NSString* dateString = [[meet_.date description] substringToIndex:10];
        int weekDay = [meet_.weekDay intValue];
        NSString* date = [NSString stringWithFormat:@"%@  %@",dateString,[weekdayArray objectAtIndex:weekDay - 1]];
        [toShowData setValue:date forKey:@"日期:"];
        [tempAllKeys addObject:@"日期:"];
        
        NSString* timeString = [[meet_.date description] substringWithRange:NSMakeRange(11, 8)];
        [toShowData setValue:timeString forKey:@"时间:"];
        [tempAllKeys addObject:@"时间:"];
    }
    if (meet_.place != nil) {
        NSString* place = meet_.place;
        [toShowData setValue:place forKey:@"地点:"];
        [tempAllKeys addObject:@"地点:"];
    }
    if (meet_.content != nil) {
        NSString* content = meet_.content;
        [toShowData setValue:content forKey:@"内容:"];
        [tempAllKeys addObject:@"内容:"];
    }
    if (meet_.host != nil) {
        NSString* host = meet_.host;
        [toShowData setValue:host forKey:@"主持人:"];
        [tempAllKeys addObject:@"主持人:"];
    }
    if (meet_.executiveDepartments != nil) {
        NSString* executiveDepartment = meet_.executiveDepartments;
        [toShowData setValue:executiveDepartment forKey:@"执行部门:"];
        [tempAllKeys addObject:@"执行部门:"];
    }
    if (meet_.participants != nil) {
        NSString* participants = meet_.participants;
        [toShowData setValue:participants forKey:@"参与者:"];
        [tempAllKeys addObject:@"参与者:"];
    }
    showTableView_.fixedSequence = tempAllKeys;
    NSDictionary* senderDictionary = [NSDictionary dictionaryWithObjectsAndKeys:toShowData,meet_.date, nil];
    showTableView_.showDataDictionary = senderDictionary;
}

@end
