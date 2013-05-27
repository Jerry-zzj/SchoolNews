//
//  ContactsTableViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "ContactsTableViewController.h"
#import "DataBaseOperating.h"
#import "WebServiceFactory.h"
#import "ContactsBuffer.h"
#import "GroupViewController.h"
#import "SVProgressHUD.h"
#import "TouchEventTableView.h"
#import "ContactsDictionaryTransform.h"
#import "AddressBook.h"
#import "PublicDefines.h"
@interface ContactsTableViewController (private)

- (BOOL)getdateFromBuffer;
- (void)receiveContactsDataWithWebservice;
- (void)updateTableView:(NSNotification* )sender;
- (void)loadContactsData;
- (void)loadSearchBar;
- (void)handleTheSearchBarText:(NSString* )sender;
- (void)updateTheContacts:(NSNotification* )sender;
- (void)sendFinishedAddOneDepartmentNotification:(NSNumber* )sender;
@end

@implementation ContactsTableViewController
@synthesize seletPersonDelegate;
@synthesize allContacts;
@synthesize contactSearchBar;
ContactsTableViewController* g_ContactsTableViewController;
+ (ContactsTableViewController* )singleton
{
    if (g_ContactsTableViewController == nil) {
        g_ContactsTableViewController = [[ContactsTableViewController alloc] initWithStyle:UITableViewStyleGrouped Frame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    }
    return g_ContactsTableViewController;
}

- (id)initWithStyle:(UITableViewStyle)style Frame:(CGRect)frame
{
    self = [super initWithStyle:style Frame:frame];
    if (self)
    {
        //NSDictionary* allContacts = [[DataBaseOperating singleton] getContacts];
        //self.showDataDictionary = allContacts;
        //注册通知，使当收到|ReceiveContactsData|通知时刷新页面
        [(TouchEventTableView* )self.tableView setTouchDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTableView:)
                                                     name:@"ReceiveContactsData"
                                                   object:nil];
        [self addObserver:[GroupViewController singleton]
               forKeyPath:@"allKeys_"
                  options:0
                  context:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadContactsData)
                                                     name:@"ContactsLogin"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTheContacts:)
                                                     name:@"UpdateTheContacts"
                                                   object:nil];
        [self loadSearchBar];
    }
    return self;
}

- (NSArray* )getAllDepartmentSorted
{
    return allKeys_;
}

- (BOOL)addContactsToLocalAddressBook
{
    BOOL success = YES;
    for (NSString* department in allKeys_) {
        NSArray* contacts = [allContacts objectForKey:department];
        for (NSDictionary* contact in contacts) {
            NSDictionary* toAddContact = [[ContactsDictionaryTransform singleton] getContractFromContractDictionary:contact];
            NSDictionary* organizationDictionary = [toAddContact objectForKey:@"公司"];
            NSDictionary* phoneDictionary = [toAddContact objectForKey:@"电话"];
            NSDictionary* emailDictionary = [toAddContact objectForKey:@"邮箱"];
            NSDictionary* urlDictionary = [toAddContact objectForKey:@"网址"];
            BOOL statue = [[AddressBook singleton] addContactInformation:[contact objectForKey:@"姓名"]
                                                       WithOriganization:organizationDictionary
                                                                   Phone:phoneDictionary
                                                                   Email:emailDictionary
                                                                     URL:urlDictionary
                                                                    Note:nil
                                                                 InGroup:department];
            if (!statue) {
                NSString* message = [NSString stringWithFormat:@"添加%@失败",[contact objectForKey:@"姓名"]];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                success = NO;
            }
            NSNumber* allToAddedContacts = [NSNumber numberWithInt:[contacts count]];
            NSDictionary* information = [NSDictionary dictionaryWithObjectsAndKeys:allToAddedContacts,@"ToAddContacts",department,@"Department", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishOneContactAdded"
                                                                object:information];
        }
        [self performSelectorOnMainThread:@selector(sendFinishedAddOneDepartmentNotification:) withObject:[NSNumber numberWithBool:success] waitUntilDone:NO];
        /*[[NSNotificationCenter defaultCenter] postNotificationName:@"FinishAddOneDepartment"
                                                            object:[NSNumber numberWithBool:success]];*/
    }
    /*[[NSNotificationCenter defaultCenter] postNotificationName:@"finishAddAllContactsIntoLocal"
                                                        object:[NSNumber numberWithBool:success]];*/
    return YES;
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
    if (section == 0) {
        NSLog(@"%@",department);
        NSLog(@"%i",[contacts count]);
    }
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
    NSString* name = [contact objectForKey:@"姓名"];
    NSString* job = [contact objectForKey:@"职务"];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = job;
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
    [self.seletPersonDelegate selectThePerson:contact];
}

#pragma mark SearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self handleTheSearchBarText:searchText];
    if (![searchBar isEqual:@""]) {
        [self.contactSearchBar setShowsCancelButton:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.contactSearchBar setShowsCancelButton:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.contactSearchBar setShowsCancelButton:NO];
}

#pragma mark TableViewTouch Delegate
- (void)touchDownInTableView
{
    [self.contactSearchBar resignFirstResponder];
}

#pragma mark private
- (void)receiveContactsDataWithWebservice
{
    WebService* webservice = [[WebServiceFactory singleton] produceTheWebService:CONTACTS_WEBSERVICE];
    NSString* urlString = [NSString stringWithFormat:@"%@/axis2/services/ContactsService/getAllContacts",WEBSERVICE_DOMAIN];
    [webservice setURLWithString:urlString];
    [webservice getWebServiceData];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
}

- (void)updateTableView:(NSNotification* )sender
{
    NSArray* departmentsAndContacts = [sender object];
    NSDictionary* contacts = [departmentsAndContacts objectAtIndex:1];
    NSArray* departments = [departmentsAndContacts objectAtIndex:0];
    tempAllKeys_ = [departments copy];
    self.showDataDictionary = contacts;
    self.allContacts = contacts;
    if (contacts == nil) {
        //[SVProgressHUD showWithStatus:@"加载失败!"];
        [SVProgressHUD dismiss];
    }
    else
    {
        //[SVProgressHUD showWithStatus:@"加载成功!"];
        [SVProgressHUD dismiss];
    }
}

- (void)sendFinishedAddOneDepartmentNotification:(NSNumber* )sender;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishAddOneDepartment"
                                                        object:sender];
}

- (BOOL)getdateFromBuffer
{
    Buffer* buffer = [ContactsBuffer singleton];
    NSArray* data = [buffer getDataInBufferWithIdentifier:@"Contact"];
    if (data == nil) {
        return NO;
    }
    else
    {
        NSArray* allDepartment = [data objectAtIndex:0];
        NSDictionary* allContactsInBuffer = [data objectAtIndex:1];
        tempAllKeys_ = [allDepartment copy];
        self.showDataDictionary = allContactsInBuffer;
        self.allContacts = allContactsInBuffer;

        return YES;
    }
}

- (void)loadContactsData
{
    if (self.showDataDictionary == nil) {
        if (![self getdateFromBuffer] && self.showDataDictionary == nil) {
            [self receiveContactsDataWithWebservice];
        }
    }
}

- (void)loadSearchBar
{
    self.contactSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.contactSearchBar.placeholder = @"输入要查询的人名";
    self.contactSearchBar.delegate = self;
    self.contactSearchBar.showsCancelButton = NO;
    [self.view addSubview:self.contactSearchBar];
    self.tableView.tableHeaderView = self.contactSearchBar;
}

- (void)handleTheSearchBarText:(NSString* )sender
{
    if ([sender isEqualToString:@""]) {
        self.showDataDictionary = allContacts;
    }
    else
    {
        NSMutableDictionary* searchResult = [NSMutableDictionary dictionary];
        for (NSString* key in [allContacts allKeys])
        {
            NSArray* persons = [allContacts objectForKey:key];
            for (NSDictionary* person in persons)
            {
                NSString* name = [person objectForKey:@"姓名"];
                if ([name rangeOfString:sender options:0].length > 0)
                {
                    if ([[searchResult allKeys] containsObject:key])
                    {
                        NSMutableArray* array = [searchResult objectForKey:key];
                        [array addObject:person];
                    }
                    else
                    {
                        NSMutableArray* array = [NSMutableArray array];
                        [array addObject:person];
                        [searchResult setObject:array forKey:key];
                    }
                }
            }
        }
        self.showDataDictionary = searchResult;
    }
}

//链接Webservice，更新通讯录
- (void)updateTheContacts:(NSNotification* )sender;
{
    [self receiveContactsDataWithWebservice];
}

- (void)sortTheKey
{
    if ([allKeys_ count] > 1) {
        [self setValue:[tempAllKeys_ copy] forKeyPath:@"allKeys_"];
    }
}

@end
