//
//  EmploymentCollectionCell.m
//  SchoolNews
//
//  Created by Jerry on 4月11星期四.
//
//

#import "EmploymentCollectionCell.h"
#import "EmploymentListTableViewController.h"
#import "JobListTableViewController.h"
#import "PracticeListTableViewController.h"
#import "EmployMentServiceViewController.h"
#import "ReproducedEmploymentListTableViewController.h"
@implementation EmploymentCollectionCell
{
    EmploymentListTableViewController* employmentListTableViewController;
    UIActivityIndicatorView* activityView;
    NSArray* types;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        [self addSubview:activityView];
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"EmploymentSubtitle" ofType:@"plist"];
        types = [NSArray arrayWithContentsOfFile:filePath];
    }
    return self;
}

- (void)setItem:(int)item
{
    NSString* type = [types objectAtIndex:item];
    [activityView startAnimating];
    if (employmentListTableViewController == nil) {
        if ([type isEqualToString:@"招聘信息"]) {
            employmentListTableViewController = [[JobListTableViewController alloc] initWithStyle:UITableViewStylePlain];
        }
        else if ([type isEqualToString:@"实习信息"])
        {
            employmentListTableViewController = [[PracticeListTableViewController alloc] initWithStyle:UITableViewStylePlain];
        }
        else if ([type isEqualToString:@"信息转载"])
        {
            employmentListTableViewController = [[ReproducedEmploymentListTableViewController alloc] initWithStyle:UITableViewStylePlain];
        }
        [employmentListTableViewController.tableView setFrame:self.bounds];
        employmentListTableViewController.delegate = [EmployMentServiceViewController singleton];
        [self addSubview:employmentListTableViewController.tableView];
    }
    else
    {
        [employmentListTableViewController setEmploymentTableType:type];
    }
    
}


- (void)clearTheData
{
    [activityView stopAnimating];
    employmentListTableViewController.showDataDictionary = nil;
}


@end
