//
//  GroupViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "GroupViewController.h"
#import "DataBaseOperating.h"
#import "ContactsTableViewController.h"
#import "PublicDefines.h"
#define GROUP_BUTTON_WIDTH                          177
#define GRoUP_BUTTON_HEIGHT                         40
#define GROUP_DISTANCE                              2
@interface GroupViewController ()


@end

@implementation GroupViewController
{
    NSMutableArray* groupNames_;
}
@synthesize delegate;
GroupViewController* g_GroupViewController;
+ (GroupViewController* )singleton
{
    if (g_GroupViewController == nil) {
        g_GroupViewController = [[GroupViewController alloc] init];
    }
    return g_GroupViewController;
}

- (id)init
{
    self = [super init];
    if (self) {
        groupNames_ = [[NSMutableArray alloc] init];
    }
    return self;
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
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 177, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    tableView_ = [[UITableView alloc] initWithFrame:self.view.frame
                                              style:UITableViewStylePlain];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    [self.view addSubview:tableView_];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"allKeys_"]) {
        ContactsTableViewController* contactsTableViewController = (ContactsTableViewController* )object;
        NSArray* allKeys = [contactsTableViewController getAllDepartmentSorted];
        if ([groupNames_ count] > 0) {
            [groupNames_ removeAllObjects];
        }
        [groupNames_ addObjectsFromArray:allKeys];
        [groupNames_ insertObject:@"所有人" atIndex:0];
        [tableView_ reloadData];
    }
}

#pragma mark UITableView DataSource
- (int )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groupNames_ count];
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请选择部门";
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    int row = [indexPath row];
    cell.textLabel.text = [groupNames_ objectAtIndex:row];
    return cell;
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    NSString* groupName = [groupNames_ objectAtIndex:row];
    [self.delegate selectTheGroup:groupName];
}

#pragma mark private

@end
