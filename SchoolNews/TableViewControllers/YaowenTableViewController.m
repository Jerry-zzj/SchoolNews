//
//  YaowenTableViewController.m
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YaowenTableViewController.h"
#import "DataBaseOperating.h"
#import "WebServiceFactory.h"
#import "PublicDefines.h"
@interface YaowenTableViewController ()

@end

@implementation YaowenTableViewController
YaowenTableViewController* g_YaowenTableViewController;
+ (YaowenTableViewController* )singleton
{
    if (g_YaowenTableViewController == nil) {
        g_YaowenTableViewController = [[YaowenTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return g_YaowenTableViewController;
}

- (void)registWebserviceFinishNotification
{
    //在WebService更新完之后
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endUpdateWithWebService:)
                                                 name:YAOWEN_END_UPDATE_WITH_WEBSERVICE
                                               object:nil];
    //刷新新闻数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doUpdateTheNews:)//模板方法
                                                 name:@"YaowenUpdate"
                                               object:nil];
}

- (void)loadNewsTableViewTitle//模板方法
{
    self.title = @"要闻";
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
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/NewsService/getNewerNews?function=新闻&subtitle=要闻&date=",sender];
    NSLog(@"%@",urlString);
    WebService* yaowenWebService = [[WebServiceFactory singleton] produceTheWebService:YAOWEN_NEWS_WEBSERVICE];
    [yaowenWebService setURLWithString:urlString];
    [yaowenWebService getWebServiceData];
}

//模板方法，当缓存区没有数据时，通过webservice加载
- (void)doWebServiceWithLastDate:(NSString* )sender
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/NewsService/getEarlierNews?function=新闻&subtitle=要闻&date=",sender];//加载更多的新闻的URL
    WebService* yaowenWebService = [[WebServiceFactory singleton] produceTheWebService:YAOWEN_NEWS_WEBSERVICE];
    [yaowenWebService setURLWithString:urlString];
    [yaowenWebService getWebServiceData];
}

//模板方法，加载置顶新闻的webservice
- (void)doLoadTopNewsWebService
{
    NSString* urlString = TOP_NEWS_WEBSERVICE_URL(self.title);
    WebService* yaowenGetTopNewsService = [[WebServiceFactory singleton] produceTheWebService:YAOWEN_NEWS_WEBSERVICE];
    [yaowenGetTopNewsService setURLWithString:urlString];
    [yaowenGetTopNewsService getWebServiceData];
}
@end
