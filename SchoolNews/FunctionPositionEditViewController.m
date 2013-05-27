//
//  FunctionPositionEditViewController.m
//  SchoolNews
//
//  Created by Jerry on 3月20星期三.
//
//

#import "FunctionPositionEditViewController.h"
#import "PublicDefines.h"
#import "FunctionPosition.h"
#import "FunctionViewController.h"
#import "PullView.h"
#import "MoreFunctionPullViewController.h"
#import "SchoolNewsTabBarController.h"
#import "PullViewCell.h"
@interface FunctionPositionEditViewController (PrivateAPI)

- (void)loadNavigation;
- (void)loadTableView;
- (void)finishEdit;
- (FunctionViewController* )viewControllerAtIndex:(NSIndexPath* )indexPath;
- (void)moveCellWithPositionDictionary:(NSDictionary* )sender;

@end

@implementation FunctionPositionEditViewController
@synthesize delegate;
FunctionPositionEditViewController* g_FunctionPositionEditViewController;
+ (FunctionPositionEditViewController* )singleton
{
    if (g_FunctionPositionEditViewController == nil) {
        g_FunctionPositionEditViewController = [FunctionPositionEditViewController alloc];
    }
    return g_FunctionPositionEditViewController;
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
    [self loadNavigation];
    [self loadTableView];
    [[FunctionPosition singleton] addObserver:[SchoolNewsTabBarController singleton]
                                   forKeyPath:@"inTabbarViewControllers"
                                      options:0
                                      context:nil];
    [[FunctionPosition singleton] addObserver:[MoreFunctionPullViewController singleton]
                                   forKeyPath:@"inPullViewControllers"
                                      options:0
                                      context:nil];
	// Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[FunctionPosition singleton] removeObserver:[SchoolNewsTabBarController singleton]
                                      forKeyPath:@"inTabbarViewControllers"];
    [[FunctionPosition singleton] removeObserver:[MoreFunctionPullViewController singleton]
                                      forKeyPath:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView DataSource
- (int )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* array;
    switch (section) {
        case 0:
            //在TabBar上
            array = [FunctionPosition singleton].inTabbarViewControllers;
            break;
        case 1:
            //订阅的栏目
            array = [FunctionPosition singleton].inPullViewControllers;
            break;
        case 2:
            //没有订阅的栏目
            array = [FunctionPosition singleton].notShowViewControllers;
            break;
        default:
            break;
    }
    return [array count];
}

- (NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"主界面菜单";
            break;
        case 1:
            return @"在服务中心";
            break;
        case 2:
            return @"不在服务中心";
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"CellIdentifier";
    PullViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PullViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    FunctionViewController* functionViewController = [self viewControllerAtIndex:indexPath];
    cell.image = functionViewController.iconImage;
    cell.functionName = functionViewController.title;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 3)) {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    FunctionViewController* sourceViewController = [self viewControllerAtIndex:sourceIndexPath];

    int sourceRow = sourceIndexPath.row;
    NSMutableArray* sourceArray;
    switch (sourceIndexPath.section) {
        case 0:
            sourceArray = [FunctionPosition singleton].inTabbarViewControllers;
            break;
        case 1:
            sourceArray = [FunctionPosition singleton].inPullViewControllers;
            break;
        case 2:
            sourceArray = [FunctionPosition singleton].notShowViewControllers;
            break;
        default:
            break;
    }
    [sourceArray removeObjectAtIndex:sourceRow];
    
    int destinationRow = destinationIndexPath.row;
    NSMutableArray* destinationArray;
    switch (destinationIndexPath.section) {
        case 0:
        {
            destinationArray = [FunctionPosition singleton].inTabbarViewControllers;
            if (destinationRow == [destinationArray count]) {
                destinationRow --;
            }
            NSIndexPath* newDestinationIndexPath = [NSIndexPath indexPathForRow:destinationRow inSection:0];
            FunctionViewController* destinationViewController = [self viewControllerAtIndex:newDestinationIndexPath];
            [destinationArray replaceObjectAtIndex:destinationRow withObject:sourceViewController];
            [sourceArray insertObject:destinationViewController atIndex:sourceRow];
            //[tableView_ beginUpdates];
            NSDictionary* positioDictionary = [NSDictionary dictionaryWithObjectsAndKeys:newDestinationIndexPath,@"From",sourceIndexPath,@"To", nil];
            [self performSelector:@selector(moveCellWithPositionDictionary:) withObject:positioDictionary afterDelay:0.2];
            //[tableView moveRowAtIndexPath:newDestinationIndexPath toIndexPath:sourceIndexPath];
            //[tableView moveRowAtIndexPath:newDestinationIndexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:sourceIndexPath.section]];
            //[tableView_ endUpdates];
            return;
        }
            break;
        case 1:
            destinationArray = [FunctionPosition singleton].inPullViewControllers;
            [destinationArray insertObject:sourceViewController atIndex:destinationRow];
            break;
        case 2:
            destinationArray = [FunctionPosition singleton].notShowViewControllers;
            [destinationArray insertObject:sourceViewController atIndex:destinationRow];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"end edit");
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"will edit");
}

#pragma mark private API
- (void)loadNavigation
{
    UINavigationBar* navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"编辑订阅服务"];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(finishEdit)];
    [navigationItem setRightBarButtonItem:rightButton];
    [navigationBar pushNavigationItem:navigationItem animated:YES];
    [self.view addSubview:navigationBar];
}

- (void)loadTableView
{
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)
                                              style:UITableViewStylePlain];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.editing = YES;
    [self.view addSubview:tableView_];
}

- (void)finishEdit
{
    //[PullView singleton].frame = CGRectMake(-200, 0, 320, 460);
    [self dismissViewControllerAnimated:YES completion:NULL];
    [[PullView singleton] pullViewToShow:NO];
    //完成编辑，做出相应处理
    NSMutableArray* intabBarViewControllers = [FunctionPosition singleton].inTabbarViewControllers;
    [[FunctionPosition singleton] setValue:intabBarViewControllers
                                forKeyPath:@"inTabbarViewControllers"];
    
    NSMutableArray* inPullViewViewControllers = [FunctionPosition singleton].inPullViewControllers;
    [[FunctionPosition singleton] setValue:inPullViewViewControllers
                                forKeyPath:@"inPullViewControllers"];
}

- (FunctionViewController* )viewControllerAtIndex:(NSIndexPath* )indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    NSArray* array;
    switch (section) {
        case 0:
            //在TabBar上
            array = [FunctionPosition singleton].inTabbarViewControllers;
            break;
        case 1:
            //订阅的栏目
            array = [FunctionPosition singleton].inPullViewControllers;
            break;
        case 2:
            //没有订阅的栏目
            array = [FunctionPosition singleton].notShowViewControllers;
            break;
        default:
            break;
    }
    FunctionViewController* functionViewController = [array objectAtIndex:row];
    return functionViewController;
}

- (void)moveCellWithPositionDictionary:(NSDictionary* )sender
{
    NSIndexPath* fromIndex = [sender objectForKey:@"From"];
    NSIndexPath* toIndex = [sender objectForKey:@"To"];
    [tableView_ moveRowAtIndexPath:[NSIndexPath indexPathForRow:fromIndex.row + 1 inSection:fromIndex.section] toIndexPath:toIndex];

}
@end
