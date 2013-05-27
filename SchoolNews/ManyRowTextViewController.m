//
//  ManyRowTextViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月20星期四.
//
//

#import "ManyRowTextViewController.h"

@interface ManyRowTextViewController ()

@end

@implementation ManyRowTextViewController
@synthesize textArray;
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

- (int )numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allKeys_ count];
}

- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    
    
}
@end
