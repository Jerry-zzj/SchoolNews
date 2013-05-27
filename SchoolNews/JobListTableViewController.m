//
//  JobListTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月11星期四.
//
//

#import "JobListTableViewController.h"
#import "EmploymentData.h"
#import "PublicDefines.h"
#import "UsersInformation.h"
@interface JobListTableViewController ()

@end

@implementation JobListTableViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        type_ = @"招聘信息";
        self.title = @"就业服务-招聘信息";
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

- (NSString* )getSubFunctionCode
{
    return @"01";
}

- (NSString* )getNewerURLWithDate:(NSString* )date
{
    //NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getJobsListNewerDate?date=",date];
    NSString* urlString = GET_JOB_NEWER_DATE(date);
    return urlString;
}

- (NSString* )getEarlierURLWithDate:(NSString* )date
{
    //NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getJobsListEarlierDate?date=",date];
    NSString* urlString = GET_JOB_EARILER_DATE(date);
    return urlString;
}
@end
