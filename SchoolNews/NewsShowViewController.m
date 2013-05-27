//
//  NewsShowViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import "NewsShowViewController.h"
#import "WebServiceFactory.h"
#import "NewsShowWebService.h"
#import "NewsWebViewController.h"
#import "PublicDefines.h"
@interface NewsShowViewController ()

- (void)backToNewsList;
- (void)goToNextNews;
- (void)updateTheNews;
- (void)loadThenavigationBarReturnButton;
- (void)loadTheZoomButton;

- (void)enlarge;
- (void)narrow;
@end

@implementation NewsShowViewController
@synthesize news;
NewsShowViewController* g_NewsShowViewController;

- (id)initWithNews:(NewsObject* )newsSender
{
    self = [super init];
    if (self) {
        self.news = newsSender;
        [self updateTheNews];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTheZoomButton];
    //[self loadThenavigationBarReturnButton];
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [self loadThenavigationBarReturnButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    newsWebViewController_ = nil;
    [super viewDidUnload];
}

#pragma mark NewsWebViewDelegate
- (void)touchMoveToLeft
{
    [self goToNextNews];
}

- (void)touchMoveToRight
{
    [self backToNewsList];
}

#pragma NewsWebViewDataSource
- (NewsObject* )newsWebViewShowNews
{
    return self.news;
}

#pragma mark webservice delegate
- (void)loadTheNews:(id)sender
{
    NSString* newsContent = (NSString* )sender;
    self.news.content = newsContent;
    [self.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    newsWebViewController_ = [[NewsWebViewController alloc] init];
    newsWebViewController_.touchMoveDelegate = self;
    newsWebViewController_.newsDataSource = self;
    [newsWebViewController_ setContent:newsContent];
    [newsWebViewController_.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    [self.view addSubview:newsWebViewController_.view];
    //NSLog(@"%@",NSStringFromCGRect(newsWebViewController_.view.frame));
}



#pragma mark private method
- (void)backToNewsList
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goToNextNews
{
    NewsObject* nextNews = [[ShowNewsQueue singleton] nextNews];
    if (nextNews != nil)
    {
        NewsShowViewController* nextNewsShowViewController = [[NewsShowViewController alloc] initWithNews:nextNews];
        [self.navigationController pushViewController:nextNewsShowViewController animated:YES];
    }
    else
    {
        [self backToNewsList];
    }
}

- (void)updateTheNews
{
    //判断news是否是完整的
    if (self.news.content == nil) {
        //news里面没有内容，通过webservice获取
        NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/NewsService/getNewsContent?ID=",news.ID];
        WebService* newsShowWebService = [[WebServiceFactory singleton] produceTheWebService:NEWS_SHOW_NEWS_WEBSERVICE];
        [(NewsShowWebService* )newsShowWebService setDelegate:self];
        [newsShowWebService setURLWithString:urlString];
        [newsShowWebService getWebServiceData];
    }
    else
    {
        //news里面有内容，直接加载
        [self.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        
        newsWebViewController_ = [[NewsWebViewController alloc] init];
        newsWebViewController_.touchMoveDelegate = self;
        newsWebViewController_.newsDataSource = self;
        [newsWebViewController_ setContent:news.content];
        [newsWebViewController_.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        [self.view addSubview:newsWebViewController_.view];
        //NSLog(@"%@",NSStringFromCGRect(newsWebViewController_.view.frame));
    }
}

- (void)loadThenavigationBarReturnButton
{
    
    NSString* title = self.news.subtitle;
    UIBarButtonItem* returnButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(backToNewsList)];
    self.navigationItem.leftBarButtonItem = returnButton;
}

- (void)loadTheZoomButton
{
    UIButton* enlargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [enlargeButton setFrame:CGRectMake(40, 7, 30, 30)];
    [enlargeButton setImage:[UIImage imageNamed:@"放大.png"] forState:UIControlStateNormal];
    [enlargeButton addTarget:self action:@selector(enlarge) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* narrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [narrowButton setFrame:CGRectMake(0, 7, 30, 30)];
    [narrowButton setImage:[UIImage imageNamed:@"缩小.png"] forState:UIControlStateNormal];
    [narrowButton addTarget:self action:@selector(narrow) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [buttonView addSubview:enlargeButton];
    [buttonView addSubview:narrowButton];
    
    UIBarButtonItem* zoomBarButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    self.navigationItem.rightBarButtonItem = zoomBarButton;
    
    
}

- (void)enlarge
{
    //发送放大通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToEnlargeTheWebView" object:nil];
}

- (void)narrow
{
    //发送缩小通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToNarrowTheWebView" object:nil];
}

@end
