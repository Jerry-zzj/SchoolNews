//
//  CampusHotlineTableViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "CampusHotlineTableViewController.h"
#import "DataBaseOperating.h"
#import "PublicDefines.h"
@interface CampusHotlineTableViewController ()

@end

@implementation CampusHotlineTableViewController
@synthesize selectHotlineDelegate;
CampusHotlineTableViewController* g_CampusHotlineTableViewController;
+ (CampusHotlineTableViewController* )singleton
{
    if (g_CampusHotlineTableViewController == nil) {
        g_CampusHotlineTableViewController = [[CampusHotlineTableViewController alloc] init];
    }
    return g_CampusHotlineTableViewController;
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped Frame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    if (self)
    {
        NSDictionary* allContacts = [[DataBaseOperating singleton] getCampusHotline];
        self.showDataDictionary = allContacts;
    }
    return self;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [allKeys_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* department = [allKeys_ objectAtIndex:section];
    NSArray* contacts = [self.showDataDictionary objectForKey:department];
    return [contacts count];
}

- (NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* department = [allKeys_ objectAtIndex:section];
    return department;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    int section = [indexPath section];
    NSString* department = [allKeys_ objectAtIndex:section];
    NSArray* contacts = [self.showDataDictionary objectForKey:department];
    int row = [indexPath row];
    NSDictionary* contact = [contacts objectAtIndex:row];
    NSString* name = [contact objectForKey:@"HotlineName"];
    NSString* phoneNumber = [contact objectForKey:@"PhoneNumber"];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = phoneNumber;
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
    int section = [indexPath section];
    int row = [indexPath row];
    NSString* department = [allKeys_ objectAtIndex:section];
    NSArray* contacts = [self.showDataDictionary objectForKey:department];
    NSDictionary* contact = [contacts objectAtIndex:row];
    [self.selectHotlineDelegate selectTheHotline:contact];
}
@end
