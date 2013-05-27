//
//  AllMeetViewController.m
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import "AllMeetViewController.h"
#import "PublicDefines.h"
@interface AllMeetViewController ()

@end

@implementation AllMeetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[MeetData singleton].delegate = self;
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
    //NSString* a = [dictionary objectForKey:self.weekday];
    NSString* urlString = [NSString stringWithFormat:@"%@/axis2/services/MeetService/getMeetJustContent?week=%i&weekday=%i",WEBSERVICE_DOMAIN,self.week,weekday_];
    return urlString;
}

- (void)meetDataChanged:(NSMutableDictionary *)sender
{
    self.showDataDictionary = sender;
}

@end
