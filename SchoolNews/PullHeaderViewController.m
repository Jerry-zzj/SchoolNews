//
//  PullHeaderViewController.m
//  SchoolNews
//
//  Created by Jerry on 3月19星期二.
//
//

#import "PullHeaderViewController.h"
#import "UsersInformation.h"
#import "PublicDefines.h"
@interface PullHeaderViewController (PrivateAPI)

//初始化页面元素
- (void)loadElementInView;
//进入设置界面
- (void)goToSettingView;
//进入增加订阅界面
- (void)goToAddSubscriptionView;
//进入编辑界面
- (void)goToEditingState:(UIButton* )sender;

@end

@implementation PullHeaderViewController
@synthesize delegate;
PullHeaderViewController* g_PullHeaderViewController;
+ (PullHeaderViewController* )singleton
{
    if (g_PullHeaderViewController == nil) {
        g_PullHeaderViewController = [[PullHeaderViewController alloc] init];
    }
    return g_PullHeaderViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [self.view setFrame:CGRectMake(0, 0, 320 - 73 - PULL_VIEW_RESPONSE_WIDTH, 80)];
    UIImageView* backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage* backgroundImage = [UIImage imageNamed:@"小灰色纹理.png"];
    [backgroundView setImage:backgroundImage];
    [self.view addSubview:backgroundView];
    [self loadElementInView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[UsersInformation singleton] removeObserver:self
                                      forKeyPath:@"accountName"
                                         context:nil];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accountName"]) {
        NSString* text = [NSString stringWithFormat:@"%@,欢迎您！",[UsersInformation singleton].accountName];
        [nameLabel_ setText:text];
    }
}

#pragma mark private API
- (void)loadElementInView
{
    avatorImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    UIImage* image = [UIImage imageNamed:@"头像.png"];
    [avatorImageView_ setImage:image];
    UIImageView* avatorBackground = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 64, 64)];
    [avatorBackground setImage:[UIImage imageNamed:@"头像背景.png"]];
    [self.view addSubview:avatorBackground];
    [self.view addSubview:avatorImageView_];
    
    nameLabel_ = [[UILabel alloc] init];
    [nameLabel_ setFrame:CGRectMake(82, 5, 50, 35)];
    [nameLabel_ setBackgroundColor:[UIColor clearColor]];
    [nameLabel_ setFont:[UIFont systemFontOfSize:12]];
    [nameLabel_ setNumberOfLines:2];
    NSString* name = [UsersInformation singleton].accountName;
    NSString* nameLabelText;
    if (!name) {
        nameLabelText = @"还没有登录哦";
    }
    else
    {
        nameLabelText = [NSString stringWithFormat:@"欢迎您：%@老师！",name];
    }
    [nameLabel_ setText:nameLabelText];
    [self.view addSubview:nameLabel_];
    
    UIButton* settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(145, 9, 65, 27.5)];
    [settingButton addTarget:self
                      action:@selector(goToSettingView)
            forControlEvents:UIControlEventTouchUpInside];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"设置.png"] forState:UIControlStateNormal];
    //[settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [self.view addSubview:settingButton];
    
    UIButton* addSubscription = [UIButton buttonWithType:UIButtonTypeCustom];
    [addSubscription setFrame:CGRectMake(145, 45.5, 65, 27.5)];
    [addSubscription addTarget:self
                        action:@selector(goToAddSubscriptionView)
              forControlEvents:UIControlEventTouchUpInside];
    //[addSubscription setTitle:@"+订阅" forState:UIControlStateNormal];
    [addSubscription setImage:[UIImage imageNamed:@"订阅.png"] forState:UIControlStateNormal];
    [self.view addSubview:addSubscription];
    
    /*UIButton* editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editButton setFrame:CGRectMake(90, 68.4, 45, 26.6)];
    [editButton addTarget:self
                   action:@selector(goToEditingState:)
         forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.view addSubview:editButton];*/
}

//进入设置界面
- (void)goToSettingView
{
    [self.delegate chooseTheFunctionGotoSettingView];
}
//进入增加订阅界面
- (void)goToAddSubscriptionView
{
    [self.delegate chooseTheFunctionGotoAddSubscriptionView];
}
//进入编辑界面
- (void)goToEditingState:(UIButton* )sender
{
    [self.delegate chooseChangeTheEditState];
}
@end
