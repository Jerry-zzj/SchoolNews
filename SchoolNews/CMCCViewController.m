//
//  CMCCViewController.m
//  SchoolNews
//
//  Created by Jerry on 5月3星期五.
//
//

#import "CMCCViewController.h"

@interface CMCCViewController ()

@end

@implementation CMCCViewController
CMCCViewController* g_CMCCViewController;
+ (id)singleton
{
    if (g_CMCCViewController == nil) {
        g_CMCCViewController = [[CMCCViewController alloc] init];
    }
    return g_CMCCViewController;
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

@end
