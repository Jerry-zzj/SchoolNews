//
//  RouteTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月25星期四.
//
//

#import "RouteTableViewController.h"

#import "RouteCell.h"
#import <QuartzCore/QuartzCore.h>

@interface RouteTableViewController ()

- (void)loadSectionView;

@end

@implementation RouteTableViewController
{
    NSArray* showData_;
    UIView* sectionView_;
    NSMutableDictionary* openDictionary_;
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

- (void)setShowData:(NSArray* )sender
{
    if (showData_ != nil) {
        showData_ = nil;
    }
    showData_ = sender;
    if (openDictionary_ != nil) {
        openDictionary_ = nil;
    }
    openDictionary_ = [NSMutableDictionary dictionary];
    for (int index = 0; index < [showData_ count]; index ++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [openDictionary_ setObject:[NSNumber numberWithBool:NO] forKey:indexPath];
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [showData_ count];
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (sectionView_ == nil) {
        [self loadSectionView];
    }
    return sectionView_;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber* openNumber = [openDictionary_ objectForKey:indexPath];
    if ([openNumber boolValue]) {
        return 120;
    }
    else
    {
        return 40;
    }
}

- (float )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    int row = [indexPath row];
    NSDictionary* information = [showData_ objectAtIndex:row];
    NSString* line = [information objectForKey:@"线路"];
    NSString* route = [information objectForKey:@"路线"];
    NSString* time = [information objectForKey:@"时间"];
    NSString* comment = [information objectForKey:@"备注"];
    NSString* detailRoute = [information objectForKey:@"具体路线"];
    [cell setLine:line
            Route:route
             Time:time
          Comment:comment
      DetailRoute:detailRoute];
    NSNumber* openNumber = [openDictionary_ objectForKey:indexPath];
    if ([openNumber boolValue]) {
        [cell setShow:YES];
    }
    else
    {
        [cell setShow:NO];
    }

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
    NSNumber* openNumber = [openDictionary_ objectForKey:indexPath];
    BOOL openStateNow = ![openNumber boolValue];
    [openDictionary_ setObject:[NSNumber numberWithBool:openStateNow] forKey:indexPath];
    NSArray* array = [NSArray arrayWithObject:indexPath];
    [tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark private API
- (void)loadSectionView
{
    sectionView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    //CALayer* backGroundLayer = [[CALayer alloc] init];
    //[backGroundLayer setFrame:sectionView_.bounds];
    UIImage* image = [UIImage imageNamed:@"表格名称背景.png"];
    //[backGroundLayer setContents:(id)image.CGImage];
    [sectionView_ setBackgroundColor:[UIColor colorWithPatternImage:image]];
    //[sectionView_.layer insertSublayer:backGroundLayer atIndex:0];
    
    UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [lineLabel setTextAlignment:NSTextAlignmentLeft];
    [lineLabel setText:@"线路"];
    [lineLabel setBackgroundColor:[UIColor clearColor]];
    [lineLabel setFont:[UIFont systemFontOfSize:14]];
    [sectionView_ addSubview:lineLabel];
    
    UILabel* routeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 145, 40)];
    [routeLabel setTextAlignment:NSTextAlignmentLeft];
    [routeLabel setText:@"路线"];
    [routeLabel setBackgroundColor:[UIColor clearColor]];
    [routeLabel setFont:[UIFont systemFontOfSize:14]];
    [sectionView_ addSubview:routeLabel];
    
    UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 0, 45, 40)];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setText:@"时间"];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:14]];
    [sectionView_ addSubview:timeLabel];
    
    UILabel* commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 70, 40)];
    [commentLabel setTextAlignment:NSTextAlignmentLeft];
    [commentLabel setText:@"备注"];
    [commentLabel setBackgroundColor:[UIColor clearColor]];
    [commentLabel setFont:[UIFont systemFontOfSize:14]];
    [sectionView_ addSubview:commentLabel];
    
    
}

@end
