//
//  ZonggeNewsTableViewController.m
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZonggeNewsTableViewController.h"
#import "DataBaseOperating.h"
#import "WebServiceFactory.h"
#import "ZongheNewsWebService.h"
#import "PublicDefines.h"
@interface ZonggeNewsTableViewController ()

@end

@implementation ZonggeNewsTableViewController
ZonggeNewsTableViewController* g_ZonggeNewsTableViewController;
+ (ZonggeNewsTableViewController* )singleton
{
    if (g_ZonggeNewsTableViewController == nil) {
        g_ZonggeNewsTableViewController = [[ZonggeNewsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return g_ZonggeNewsTableViewController;
}

- (void)registWebserviceFinishNotification
{
    //在WebService更新完之后
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endUpdateWithWebService:)
                                                 name:ZONGHE_END_UPDATE_WITH_WEBSERVICE
                                               object:nil];
    //刷新新闻数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doUpdateTheNews:)//模板方法
                                                 name:@"ZongheUpdate"
                                               object:nil];
}

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSArray* temp = [[DataBaseOperating singleton] getNewsForFunction:@"新闻" Subtitle:@"综合"];
        NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:temp,@"2", nil];
        self.showDataDictionary = dictionary;
    }
    return self;
}*/

- (void)loadNewsTableViewTitle//模板方法
{
    self.title = @"综合";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark update the Data
//模板方法，根据最新的时间进行webservice刷新
- (void )doWebServiceWithFirstDate:(NSString* )sender
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/NewsService/getNewerNews?function=新闻&subtitle=综合&date=",sender];
    NSLog(@"%@",urlString);
    WebService* yaowenWebService = [[WebServiceFactory singleton] produceTheWebService:ZONGHE_NEWS_WEBSERVICE];
    [yaowenWebService setURLWithString:urlString];
    [yaowenWebService getWebServiceData];
}

//模板方法，当缓存区没有数据时，通过webservice加载
- (void)doWebServiceWithLastDate:(NSString* )sender
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/NewsService/getEarlierNews?function=新闻&subtitle=综合&date=",sender];//加载更多的新闻的URL
    WebService* yaowenWebService = [[WebServiceFactory singleton] produceTheWebService:ZONGHE_NEWS_WEBSERVICE];
    [yaowenWebService setURLWithString:urlString];
    [yaowenWebService getWebServiceData];
}
//模板方法，加载置顶新闻的webservice
- (void)doLoadTopNewsWebService
{
    NSString* urlString = TOP_NEWS_WEBSERVICE_URL(self.title);
    WebService* yaowenGetTopNewsService = [[WebServiceFactory singleton] produceTheWebService:ZONGHE_NEWS_WEBSERVICE];
    [yaowenGetTopNewsService setURLWithString:urlString];
    [yaowenGetTopNewsService getWebServiceData];
}
@end
