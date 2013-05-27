//
//  CustomViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月18星期二.
//
//

#import "CustomNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Scale.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.delegate = self;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage* tempImage = [UIImage imageNamed:@"蓝色导航.png"];
    UIImage* image = [tempImage scaleToSize:CGSizeMake(320, 44)];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor colorWithRed:38.0 / 255.0
                                                   green:124.0 /255.0
                                                    blue:178.0 /255.0
                                                   alpha:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
