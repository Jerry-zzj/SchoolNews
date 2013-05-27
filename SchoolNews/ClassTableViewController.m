//
//  ClassTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "ClassTableViewController.h"
#import "ClassObject.h"
#import "ClassCell.h"
@interface ClassTableViewController ()

- (ClassObject* )getClassAtIndexPath:(NSIndexPath* )sender;
- (void)loadHeadView;

@end

@implementation ClassTableViewController
{
    NSDictionary* dictionary_;
    UIView* headerView_;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:NSClassFromString(@"ClassCell") forCellReuseIdentifier:@"Cell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setClasses:(NSDictionary* )sender
{
    if (dictionary_) {
        dictionary_ = nil;
    }
    dictionary_ = sender;
    [self.tableView reloadData];
}

- (void)clear
{
    dictionary_ = nil;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return nil;
    }
    if (headerView_ == nil) {
        [self loadHeadView];
    }
    return headerView_;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 0;
    }
    return 44;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray* classes = nil;
    switch (section) {
        case 0:
            classes = [dictionary_ objectForKey:@"上午"];
            break;
        case 1:
            classes = [dictionary_ objectForKey:@"下午"];
            break;
        case 2:
            classes = [dictionary_ objectForKey:@"下午"];
            break;
        default:
            break;
    }
    if (classes != nil) {
        return [classes count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ClassCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ClassObject* class = [self getClassAtIndexPath:indexPath];
    [cell setClass:class];
    // Configure the cell...
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark private API
- (ClassObject* )getClassAtIndexPath:(NSIndexPath* )sender
{
    NSArray* classes = nil;
    int section = [sender section];
    switch (section) {
        case 0:
            classes = [dictionary_ objectForKey:@"上午"];
            break;
        case 1:
            classes = [dictionary_ objectForKey:@"下午"];
            break;
        case 2:
            classes = [dictionary_ objectForKey:@"下午"];
            break;
        default:
            break;
    }
    if (classes == nil) {
        return nil;
    }
    else
    {
        int row = [sender row];
        return [classes objectAtIndex:row];
    }
}

- (void)loadHeadView
{
    headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [headerView_ setBackgroundColor:[UIColor colorWithRed:230.0 / 255.0
                                                    green:244.0 / 255.0
                                                     blue:253 / 255.0
                                                    alpha:1]];
    
    UILabel* classTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 44)];
    [classTimeLabel setBackgroundColor:[UIColor clearColor]];
    [classTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [classTimeLabel setTextColor:[UIColor blackColor]];
    [classTimeLabel setText:@"课时"];
    [headerView_ addSubview:classTimeLabel];
    
    UILabel* classNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, 44)];
    [classNameLabel setBackgroundColor:[UIColor clearColor]];
    [classNameLabel setFont:[UIFont systemFontOfSize:12]];
    [classNameLabel setNumberOfLines:3];
    [classNameLabel setTextAlignment:NSTextAlignmentCenter];
    [classNameLabel setTextColor:[UIColor blackColor]];
    [classNameLabel setText:@"课程"];
    [headerView_ addSubview:classNameLabel];
    
    UILabel* classroomNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 100, 44)];
    [classroomNameLabel setBackgroundColor:[UIColor clearColor]];
    [classroomNameLabel setFont:[UIFont systemFontOfSize:12]];
    [classroomNameLabel setNumberOfLines:2];
    [classroomNameLabel setTextAlignment:NSTextAlignmentCenter];
    [classroomNameLabel setTextColor:[UIColor blackColor]];
    [classroomNameLabel setText:@"教室"];
    [headerView_ addSubview:classroomNameLabel];
    
    UILabel* teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 50, 44)];
    [teacherNameLabel setBackgroundColor:[UIColor clearColor]];
    [teacherNameLabel setFont:[UIFont systemFontOfSize:12]];
    [teacherNameLabel setTextAlignment:NSTextAlignmentRight];
    [teacherNameLabel setTextColor:[UIColor blackColor]];
    [teacherNameLabel setText:@"教师"];
    [headerView_ addSubview:teacherNameLabel];
}

@end
