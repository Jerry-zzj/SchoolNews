//
//  UserSettingViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import "UserSettingTableViewController.h"
#import "UsersInformation.h"

@interface UserSettingTableViewController ()

- (void)loadSettingDictionary;
- (void)machinCell:(UITableViewCell* )cell InIndexPath:(NSIndexPath* )indexPath;
- (id)getTextAtIndexPath:(NSIndexPath* )sender;
- (NSString* )getUserName;
- (NSString* )getVersion;
- (void)changeTheSwitch:(UISwitch* )sender;

@end

@implementation UserSettingTableViewController
@synthesize delegate;
UserSettingTableViewController* g_UserSettingTableViewController;
+ (UserSettingTableViewController* )singleton
{
    if (g_UserSettingTableViewController == nil) {
        g_UserSettingTableViewController = [[UserSettingTableViewController alloc] init];
    }
    return g_UserSettingTableViewController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        [[UsersInformation singleton] addObserver:self
                                       forKeyPath:@"accountName"
                                          options:0
                                          context:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSettingDictionary];
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
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* objects = [settingDictionary_ objectForKey:key];
    return [objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [self machinCell:cell InIndexPath:indexPath];
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
    NSString* string = [self getTextAtIndexPath:indexPath];
    [self.delegate selectTheIdentifier:string];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accountName"]) {
        [self.tableView reloadData];
    }
    else if ([keyPath isEqualToString:@"TextSize"])
    {
        [self.tableView reloadData];
    }
}

#pragma mark TextSizeTableView delegate
- (void)selectedTheFontName:(NSString *)sender
{
    fontSizeText_ = [sender copy];
}

#pragma mark private
- (void)loadSettingDictionary
{
    NSArray* firstSection = [NSArray arrayWithObjects:@"用户名",@"自动登录", nil];
    NSArray* secondSection = [NSArray arrayWithObjects:@"清理缓存", nil];
    //NSArray* thirdSection = [NSArray arrayWithObjects:@"字号", nil];
    NSArray* thirdSection = [NSArray arrayWithObjects:@"新闻栏目", nil];
    NSArray* forthSection = [NSArray arrayWithObjects:@"版本号", nil];
    NSArray* fifthSection = [NSArray arrayWithObjects:@"消息中心", nil];
    settingDictionary_ = [[NSDictionary alloc] initWithObjectsAndKeys:firstSection,@"账户信息",secondSection,@"缓存",thirdSection,@"新闻设置",forthSection,@"软件相关",fifthSection,@"消息", nil];
    allKeys_ = [NSArray arrayWithObjects:@"账户信息",@"缓存",@"新闻设置",@"软件相关",@"消息", nil];
}


- (void)machinCell:(UITableViewCell* )cell InIndexPath:(NSIndexPath* )indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    NSString* leftText = [self getTextAtIndexPath:indexPath];
    cell.textLabel.text = leftText;
    if (section == 0 && row == 0) {
        cell.detailTextLabel.text = [self getUserName];
    }
    else if (section == 0 && row == 1)
    {
        UISwitch* loginSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(220, 10, 100, 20)];
        [cell addSubview:loginSwitch];
        [loginSwitch addTarget:self
                        action:@selector(changeTheSwitch:)
              forControlEvents:UIControlEventValueChanged];
        loginSwitch.on = [UsersInformation singleton].autoLogin;
    }
    else if (section == 2 && row == 0)
    {
        cell.detailTextLabel.text = fontSizeText_;
    }
    else if (section == 3 && row == 0)
    {
        cell.detailTextLabel.text = [self getVersion];
    }
}

- (id)getTextAtIndexPath:(NSIndexPath* )sender
{
    int section = [sender section];
    int row = [sender row];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* array = [settingDictionary_ objectForKey:key];
    return [array objectAtIndex:row];
}

- (NSString* )getUserName
{
    if ([UsersInformation singleton].accountName == nil) {
        return @"未登录";
    }
    else
    {
        return [UsersInformation singleton].accountName;
    }
}

- (NSString* )getVersion
{
    return [UsersInformation singleton].version;
}

- (void)changeTheSwitch:(UISwitch *)sender
{
    [UsersInformation singleton].autoLogin = sender.on;
}
@end
