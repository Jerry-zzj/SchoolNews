//
//  LecturesShowViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月17星期一.
//
//

#import "LecturesShowViewController.h"
#import "LectureObject.h"
#import "PublicDefines.h"
@interface LecturesShowViewController ()

@end

@implementation LecturesShowViewController
@synthesize showLecture;
- (id)initWithShowLecture:(LectureObject* )lecture
{
    self = [super init];
    if (self) {
        showTableView_ = [[FixedSequenceTableViewController alloc] initWithStyle:UITableViewStyleGrouped Frame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
        showTableView_.fixedSequence = [NSArray arrayWithObjects:@"标题",@"日期",@"承办单位",@"地点",@"讲座人",@"讲座人简介",@"内容",nil];
        showTableView_.touchMoveDelegate = self;
        NSDate* date = lecture.date;
        NSString* dateString = [date description];
        NSDictionary* showDictionary = [NSDictionary dictionaryWithObjectsAndKeys:lecture.title,@"标题",dateString,@"日期",lecture.underTaker,@"承办单位",lecture.place,@"地点",lecture.lecturer,@"讲座人",lecture.lecturerIntroduction,@"讲座人简介",lecture.lecturesIntroduction,@"内容",nil];
        NSDictionary* sender = [NSDictionary dictionaryWithObjectsAndKeys:showDictionary,lecture.date, nil];
        showTableView_.showDataDictionary = sender;
        [self addChildViewController:showTableView_];
        [self.view addSubview:showTableView_.tableView];
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

#pragma move touch
- (void)moveToLeft
{
    
}

- (void)moveToRight
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
