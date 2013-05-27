//
//  PracticeListTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月11星期四.
//
//

#import "PracticeListTableViewController.h"
#import "PublicDefines.h"
@interface PracticeListTableViewController ()

@end

@implementation PracticeListTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        type_ = @"实习信息";
        self.title = @"就业服务-实习信息";
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
    return @"02";
}

- (NSString* )getNewerURLWithDate:(NSString* )date
{
    //NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getPracticeListNewerDate?date=",date];
    NSString* urlString = GET_PRACTICE_NEWER_DATE(date);
    NSLog(@"%@",urlString);
    return urlString;
}

- (NSString* )getEarlierURLWithDate:(NSString* )date
{
    //NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getPracticeListEarlierDate?date=",date];
    NSString* urlString = GET_PRACTICE_EARILER_DATE(date);
    NSLog(@"%@",urlString);
    return urlString;
}
@end
