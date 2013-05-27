
//
//  EmploymentShowViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月11星期四.
//
//

#import "EmploymentShowViewController.h"
#import "EmploymentWebservice.h"
#import "PublicDefines.h"
#import "AboutLabel.h"
#import "TouchEventTableView.h"
#import "EmploymentCompanyHeaderView.h"
@interface EmploymentShowViewController ()

- (void)loadInitialInformation;
- (NSDictionary* )getDataForIndexPath:(NSIndexPath* )indexpath;
- (void)clickTheHeaderButton:(UIButton* )sender;
- (void)dictionart:(NSMutableDictionary* )dictionary setobject:(id )object ForKey:(NSString* )key;
- (void)loadNavigationBackBarButton;
- (void)popSelf;

@end

@implementation EmploymentShowViewController
{
    JobObject* job;
    BOOL showCompanySynopsis;
    int showJobs;
    EmploymentWebservice* webservice;
    NSMutableArray* buttonArray;
}
- (id)initWithEmployment:(JobObject* )sender
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        job = sender;
        showCompanySynopsis = NO;
        showJobs = 0;
        buttonArray = [NSMutableArray array];
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

- (void)loadView
{
    TouchEventTableView* touchEnableTableView = [[TouchEventTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    [touchEnableTableView setBackgroundView:nil];
    [touchEnableTableView setBackgroundColor:[UIColor colorWithRed:230.0 / 255.0
                                                             green:244.0 / 255.0
                                                              blue:253 / 255.0
                                                             alpha:1]];
    touchEnableTableView.dataSource = self;
    touchEnableTableView.delegate = self;
    touchEnableTableView.moveDelegate = self;
    self.tableView = touchEnableTableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInitialInformation];
    [self loadNavigationBackBarButton];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark move delegate
- (void)touchMoveToRight
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchMoveToLeft
{
    
}

#pragma mark tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [job.job count] + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 6;
            break;
        case 0:
            if (showCompanySynopsis) {
                return 1;
            }
            else
            {
                return 0;
            }
            break;
        default:
            if (showJobs == section) {
                return [[job.job objectForKey:[[job.job allKeys] objectAtIndex:section - 2]] count];
            }
            else
            {
                return 0;
            }
            break;
    }
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 60;
    }
    if (section == 1) {
        return 0;
    }
    else
    {
        return 33;
    }
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != 1) {
        return 0;
    }
    else
    {
        return 30;
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行为公司简介时
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSString* companyIntroduction = job.companyIntroduction;
        float height = [AboutLabel getHeightWithFontSize:14 Width:280 Text:companyIntroduction];
        return height;
    }
    else
    {
        return 44;
    }
}

- (NSString* )tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return @"公司提供的职务";
    }
    return nil;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
    if (section == 0) {
        EmploymentCompanyHeaderView* view = [EmploymentCompanyHeaderView singleton];
        view.delegate = self;
        [view setCompanyName:job.company];
        [view setOpen:showCompanySynopsis];
        return view;
    }
    if (section == 1) {
        return nil;
    }
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20, 0, 280, 38)];
    [button setTag:section];
    [button addTarget:self
               action:@selector(clickTheHeaderButton:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([tableView numberOfRowsInSection:section] == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"横向.png"] forState:UIControlStateNormal];
    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"展开.png"] forState:UIControlStateNormal];
    }
    NSString* jobName = [[job.job allKeys] objectAtIndex:section - 2];
    [button setTitle:jobName forState:UIControlStateNormal];
    [view addSubview:button];
    return view;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString* firstIdentifier = @"FirstCellIdentifier";
    static NSString* identifier = @"CellIdentifier";
    UITableViewCell* cell;
    cell = (UITableViewCell* )[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor colorWithRed:230.0 / 255.0
                                                 green:244.0 / 255.0
                                                  blue:253 / 255.0
                                                 alpha:1]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary* dictionary = [self getDataForIndexPath:indexPath];
    NSString* name = [[dictionary allKeys] objectAtIndex:0];
    NSString* detail = [dictionary objectForKey:name];
    /*cell.textLabel.text = name;
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    cell.detailTextLabel.text = detail;*/
    
    if ([name isEqualToString:@"单位简介"]) {
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@:",detail];
        cell.detailTextLabel.text = nil;
    }
    else
    {
        cell.textLabel.text = name;
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        if ([detail length] > 15) {
        }
        [cell.detailTextLabel setNumberOfLines:2];
        cell.detailTextLabel.text = detail;
    }
    return cell;
}

#pragma tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark webservice delegate
- (void)finishGetEmploymentData:(id)sender
{
    NSArray* employments = (NSArray* )sender;
    for (JobObject* object in employments) {
        [job absorbTheJob:object];
    }
    [self.tableView reloadData];
}

#pragma mark headView Delegate
- (void)clickTheShowButton:(UIButton* )sender
{
    showCompanySynopsis = !showCompanySynopsis;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (showCompanySynopsis) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark private
- (void)loadInitialInformation
{
    if ([job.job count] == 0) {
        webservice = [[EmploymentWebservice alloc] init];
        webservice.delegate = self;
        NSString* urlString;
        if ([job.type isEqualToString:@"招聘信息"]) {
            urlString = [NSString stringWithFormat:@"%@/axis2/services/EmploymentService/getJobsTotalInformationForID?ID=%@",WEBSERVICE_DOMAIN,job.ID];
        }
        else if ([job.type isEqualToString:@"实习信息"])
        {
            urlString = [NSString stringWithFormat:@"%@/axis2/services/EmploymentService/getPracticeTotalInformationForID?ID=%@",WEBSERVICE_DOMAIN,job.ID];
        }
        [webservice setURLWithString:urlString];
        [webservice getWebServiceData];
    }
    else
    {
        [self.tableView reloadData];
    }
}

- (NSDictionary* )getDataForIndexPath:(NSIndexPath* )indexpath
{
    int section = indexpath.section;
    int row = indexpath.row;
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    if (section == 0)
    {
        [self dictionart:result setobject:job.companyIntroduction ForKey:@"单位简介"];
        
    }
    else if (section == 1)
    {
        switch (row) {
            /*case 0:
                [self dictionart:result setobject:job.company ForKey:@"用人单位名称"];
                break;*/
            case 0:
                [self dictionart:result setobject:job.industry ForKey:@"所属行业"];
                break;
            case 1:
                [self dictionart:result setobject:job.companyNature ForKey:@"单位性质"];
                break;
            case 2:
                [self dictionart:result setobject:job.companyType ForKey:@"机构类型"];
                break;
            case 3:
                [self dictionart:result setobject:job.companyAdd ForKey:@"单位地址"];
                break;
            case 4:
                [self dictionart:result setobject:job.companyContact ForKey:@"单位联系人"];
                break;
            case 5:
                [self dictionart:result setobject:job.contactPhone ForKey:@"联系电话"];
                break;
            default:
                break;
        }
    }
    else if (section > 1)
    {
        NSString* jobName = [[job.job allKeys] objectAtIndex:section - 2];
        NSDictionary* jobs = [job.job objectForKey:jobName];
        NSString* object;
        switch (row) {
            case 0:
                object = [jobs objectForKey:@"职位名称"];
                [self dictionart:result setobject:object ForKey:@"职位名称"];
                break;
            case 1:
                object = [jobs objectForKey:@"需求人数"];
                [self dictionart:result setobject:object ForKey:@"需求人数"];
                break;
            case 2:
                object = [jobs objectForKey:@"工作类型"];
                [self dictionart:result setobject:object ForKey:@"工作类型"];
                break;
            case 3:
                object = [jobs objectForKey:@"聘用方式"];
                [self dictionart:result setobject:object ForKey:@"聘用方式"];
                break;
            case 4:
                object = [jobs objectForKey:@"薪水"];
                [self dictionart:result setobject:object ForKey:@"薪水"];
                break;
            case 5:
                object = [jobs objectForKey:@"截止日期"];
                [self dictionart:result setobject:object ForKey:@"截止日期"];
                break;
            default:
                break;
        }
    }
    return result;
}

- (void)dictionart:(NSMutableDictionary* )dictionary setobject:(id )object ForKey:(NSString* )key
{
    if (object != nil) {
        [dictionary setObject:object forKey:key];
    }
    else
    {
        [dictionary setObject:@" " forKey:key];
    }
}

- (void)clickTheHeaderButton:(UIButton* )sender
{
    //[sender setImage:[UIImage imageNamed:@"展开.png"] forState:UIControlStateNormal];
    int tag = sender.tag;
    if (tag == showJobs) {
        showJobs = 0;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        int temp = showJobs;
        showJobs = 0;
        if (temp > 1) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:temp] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        showJobs = tag;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:showJobs] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:showJobs] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)loadNavigationBackBarButton
{
    UIBarButtonItem* barbutton = [[UIBarButtonItem alloc] initWithTitle:job.type
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(popSelf)];
    [self.navigationItem setLeftBarButtonItem:barbutton];
    //[self.navigationItem.backBarButtonItem setTitle:job.type];
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
