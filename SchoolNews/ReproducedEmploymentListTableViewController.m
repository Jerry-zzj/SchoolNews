//
//  ReproducedEmploymentListTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月12星期五.
//
//

#import "ReproducedEmploymentListTableViewController.h"
#import "PublicDefines.h"

@interface ReproducedEmploymentListTableViewController ()

@end

@implementation ReproducedEmploymentListTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        type_ = @"信息转载";
        self.title = @"就业服务-信息转载";
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
    return @"03";
}

- (NSString* )getNewerURLWithDate:(NSString* )date
{
    //NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getReproducedListNewerDate?date=",date];
    NSString* urlString = GET_REPRODUCED_NEWER_DATE(date);
    //NSLog(@"%@",urlString);
    return urlString;
}

- (NSString* )getEarlierURLWithDate:(NSString* )date
{
    //NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/EmploymentService/getReproducedListEarlierDate?date=",date];
    NSString* urlString = GET_REPRODUCED_EARILER_DATE(date);
    //NSLog(@"%@",urlString);
    return urlString;
}
@end
