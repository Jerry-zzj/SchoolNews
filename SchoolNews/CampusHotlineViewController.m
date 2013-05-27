//
//  CampusHotlineViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "CampusHotlineViewController.h"
#import "UIImage+Scale.h"
#import "PublicDefines.h"
@interface CampusHotlineViewController ()

- (void)loadCampusHotlineTableViewController;

@end

@implementation CampusHotlineViewController
@synthesize selectedHotline;
CampusHotlineViewController* g_CampusHotlineViewController;
+ (CampusHotlineViewController* )singleton
{
    if (g_CampusHotlineViewController == nil) {
        g_CampusHotlineViewController = [[CampusHotlineViewController alloc] init];
    }
    return g_CampusHotlineViewController;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"校内热线";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self loadCampusHotlineTableViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    //NSLog(@"%@",NSStringFromCGRect(campusHotlineTableViewController_.tableView.frame));
    if (campusHotlineTableViewController_ == nil) {
        [self loadCampusHotlineTableViewController];
    }
}

#pragma mark touch move
- (void)moveToRight
{
    
}

- (void)moveToLeft
{
    
}

- (void)selectTheHotline:(NSDictionary *)hotline
{
    self.selectedHotline = hotline;
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"操作"
                                                             delegate:self
                                                    cancelButtonTitle:@"返回"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拨打", nil];
    //[actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet showInView:self.view];
}

#pragma mark actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        NSString* phoneNumber = [self.selectedHotline objectForKey:@"PhoneNumber"];
        NSString* telURLString = [NSString stringWithFormat:@"tel://%@",phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telURLString]];
    }
    else if (buttonIndex == 1)
    {
        
    }
}

#pragma mark private
- (void)loadCampusHotlineTableViewController
{
    campusHotlineTableViewController_ = [CampusHotlineTableViewController singleton];
    [campusHotlineTableViewController_.tableView setFrame:self.view.bounds];
    campusHotlineTableViewController_.selectHotlineDelegate = self;
    campusHotlineTableViewController_.touchMoveDelegate = self;
    [self addChildViewController:campusHotlineTableViewController_];
    [self.view addSubview:campusHotlineTableViewController_.tableView];
    //NSLog(@"%@",NSStringFromCGRect(campusHotlineTableViewController_.tableView.frame));
    //NSLog(@"%@",NSStringFromCGRect(self.view.bounds));

}
@end
