//
//  PersonalMeetViewController.m
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import "PersonalMeetViewController.h"
#import "UsersInformation.h"
#import "PublicDefines.h"
@interface PersonalMeetViewController ()

@end

@implementation PersonalMeetViewController

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

- (NSString* )doGetUpdateURL
{
    NSString* urlString = [NSString stringWithFormat:@"%@/axis2/services/MeetService/getMeetJustContentWithAccountName?week=%i&weekday=%i&accountName=%@",WEBSERVICE_DOMAIN,week_,weekday_,[UsersInformation singleton].accountName];
    return urlString;
}


@end
