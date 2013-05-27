//
//  ContactInformationViewController.m
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContactInformationViewController.h"
#import "AddressBook.h"
#import "SVProgressHUD.h"
#import "PhoneNumberCell.h"
#import "MessageViewController.h"
#import "ContactsDictionaryTransform.h"
//------------------------------------------------------------------------------
@interface ContactInformationViewController (Private)

- (void)loadNavigationBarButton;
- (void)addContactToLocalAddressBook;
- (BOOL)addContactToLocalAddressBookWithoutModify;
- (BOOL)addContactToLocalAddressBookWithModify:(NSString* )name;
- (BOOL)replaceTheContactToLocalAddressBook:(NSString* )name;

- (NSDictionary* )getNameDictionary;
- (NSDictionary* )getOrganizationDictionary;
- (NSDictionary* )getPhoneDictioary;
- (NSDictionary* )getEmailDictionary;
- (NSDictionary* )getURLDictionary;
- (NSDictionary* )getNoteString;

- (void)backToContacts;
@end
//------------------------------------------------------------------------------
@implementation ContactInformationViewController

- (id)initWithContact:(NSDictionary* )dictionary
{
    self = [super init];
    if (self)
    {
        contact_ = [NSDictionary dictionaryWithDictionary:dictionary];
        NSArray* allKeys = [NSArray arrayWithObjects:@"姓名",@"部门",@"职务",@"办公室地址",@"办公室电话1",@"办公室电话2",@"移动",@"移动短号",@"电信",@"电信短号",@"联通",@"联通短号",@"传真",@"邮箱",@"QQ",@"家庭电话",@"家庭住址",nil];
        NSMutableArray* temp = [NSMutableArray array];
        for (NSString* key in allKeys) {
            if ([[contact_ allKeys] containsObject:key]) {
                [temp addObject:key];
            }
        }
        keys_ = [NSArray arrayWithArray:temp];
        self.tableView = [[TouchEventTableView alloc] initWithFrame:self.tableView.frame
                                                              style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [(TouchEventTableView* )self.tableView setMoveDelegate:self];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.tableView.style = UITableViewStyleGrouped;
        ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigationBarButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keys_ count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [keys_ objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"ContactInformationCell";
    PhoneNumberCell* cell = (PhoneNumberCell* )[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PhoneNumberCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.delegate = self;
    }
    int section = [indexPath section];
    NSString* key = [keys_ objectAtIndex:section];
    NSString* content = [contact_ objectForKey:key];
    if ([key isEqualToString:@"办公室电话1"] || [key isEqualToString:@"办公室电话2"] ||
        [key isEqualToString:@"移动"] || [key isEqualToString:@"移动短号"] ||
        [key isEqualToString:@"电信"] || [key isEqualToString:@"电信短号"] ||
        [key isEqualToString:@"联通"] || [key isEqualToString:@"联通短号"] ||
        [key isEqualToString:@"家庭电话"]) {
        cell.phoneNumberOrNot = YES;
    }
    else
    {
        cell.phoneNumberOrNot = NO;
    }
    cell.textLabel.text = content;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*int section = [indexPath section];
    NSString* key = [keys_ objectAtIndex:section];
    NSString* content = [contact_ objectForKey:key];
    BOOL phoneNumber = [content judgeAllNumber];
    if (phoneNumber) {
        UIActionSheet* actionsheet = [[UIActionSheet alloc] initWithTitle:@"选项"
                                                                 delegate:self
                                                        cancelButtonTitle:@"返回"
                                                   destructiveButtonTitle:@"拨打"
                                                        otherButtonTitles:nil];
        [actionsheet showFromTabBar:self.tabBarController.tabBar];
        selectedNumber_ = [content copy];
    }*/
}

#pragma mark
- (void)touchMoveToLeft
{
    
}

- (void)touchMoveToRight
{
    [self backToContacts];
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* toAddedPersonName = [contact_ objectForKey:@"姓名"];
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self addContactToLocalAddressBookWithModify:toAddedPersonName];
            break;
        case 2:
            [self addContactToLocalAddressBookWithoutModify];
            break;
        case 3:
            [self replaceTheContactToLocalAddressBook:toAddedPersonName];
            break;
        default:
            break;
    }
}

#pragma mark PhoneNumberCell Delegate
- (void)callThePhoneNumber:(NSString *)sender
{
    NSString* urlString = [NSString stringWithFormat:@"tel://%@",sender];
    NSURL* telURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:telURL];
}

- (void)messageThePhoneNumber:(NSString *)sender
{
    MessageViewController* messageViewController = [MessageViewController singleton];
    [messageViewController setType:Message];
    NSArray* recipents = [[NSArray alloc] initWithObjects:sender, nil];
    [messageViewController setRecipients:recipents];
    [self presentViewController:messageViewController.messageComposeViewController animated:YES completion:nil];
}
/*#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString* telURLString = [NSString stringWithFormat:@"tel://%@",selectedNumber_];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telURLString]];
    }
}*/

//------------------------------------------------------------------------------
#pragma mark private method
- (void)loadNavigationBarButton
{
    /*UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"下载.png"]
                                                                    style:UIBarButtonItemStyleDone target:self
                                                                   action:@selector(addContactToLocalAddressBook)];*/
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 2, 44, 44)];
    [button setImage:[UIImage imageNamed:@"下载.png"] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(addContactToLocalAddressBook)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)addContactToLocalAddressBook
{
    //在添加前先判断通讯录里是否存在这个人
    NSString* toAddedPersonName = [contact_ objectForKey:@"姓名"];
    BOOL exit = [[AddressBook singleton] personExitInAdressBook:toAddedPersonName];
    if (exit) {
        NSString* message = [NSString stringWithFormat:@"您的通讯录中存在%@",toAddedPersonName];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"合并",@"不合并",@"替换", nil];
        [alert show];
    }
    else
    {
        [self addContactToLocalAddressBookWithoutModify];
    }
}

- (BOOL)addContactToLocalAddressBookWithoutModify
{
    NSDictionary* toAddContactDictionary = [[ContactsDictionaryTransform singleton] getContractFromContractDictionary:contact_];
    NSDictionary* nameDictionary = [toAddContactDictionary objectForKey:@"姓名"];
    NSDictionary* organizationDictionary = [toAddContactDictionary objectForKey:@"公司"];
    NSDictionary* phoneDictionary = [toAddContactDictionary objectForKey:@"电话"];
    NSDictionary* emailDictionary = [toAddContactDictionary objectForKey:@"邮箱"];
    NSDictionary* urlDictionary = [toAddContactDictionary objectForKey:@"网址"];
    NSString* note;
    BOOL saveState = [[AddressBook singleton] addNewContactWithName:nameDictionary
                                                       Organization:organizationDictionary
                                                              Phone:phoneDictionary
                                                              Email:emailDictionary
                                                                URL:urlDictionary
                                                               Note:note];
    if (saveState) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功！"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"添加失败!"];
    }
    return saveState;
    
}

- (BOOL)addContactToLocalAddressBookWithModify:(NSString* )name
{
    //NSDictionary* nameDictionary = [self getNameDictionary];
    NSDictionary* toAddContactDictionary = [[ContactsDictionaryTransform singleton] getContractFromContractDictionary:contact_];
    NSDictionary* organizationDictionary = [toAddContactDictionary objectForKey:@"公司"];
    NSDictionary* phoneDictionary = [toAddContactDictionary objectForKey:@"电话"];
    NSDictionary* emailDictionary = [toAddContactDictionary objectForKey:@"邮箱"];
    NSDictionary* urlDictionary = [toAddContactDictionary objectForKey:@"网址"];
    NSString* note;
    BOOL saveState = [[AddressBook singleton] AddContractInformation:name
                                                   WithOriganization:organizationDictionary
                                                               Phone:phoneDictionary
                                                               Email:emailDictionary
                                                                 URL:urlDictionary
                                                                Note:note];
    if (saveState) {
        [SVProgressHUD showSuccessWithStatus:@"合并成功！"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"合并失败!"];
    }
    return saveState;
}

- (BOOL)replaceTheContactToLocalAddressBook:(NSString* )name
{
    NSDictionary* toAddContactDictionary = [[ContactsDictionaryTransform singleton] getContractFromContractDictionary:contact_];
    NSDictionary* organizationDictionary = [toAddContactDictionary objectForKey:@"公司"];
    NSDictionary* phoneDictionary = [toAddContactDictionary objectForKey:@"电话"];
    NSDictionary* emailDictionary = [toAddContactDictionary objectForKey:@"邮箱"];
    NSDictionary* urlDictionary = [toAddContactDictionary objectForKey:@"网址"];
    NSString* note;
    BOOL saveState = [[AddressBook singleton] replaceContactInformation:name
                                                      WithOriganization:organizationDictionary
                                                                  Phone:phoneDictionary
                                                                  Email:emailDictionary
                                                                    URL:urlDictionary
                                                                   Note:note];
    if (saveState) {
        [SVProgressHUD showSuccessWithStatus:@"替换成功！"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"替换失败!"];
    }
    return saveState;

}

- (void)backToContacts
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
