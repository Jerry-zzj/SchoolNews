//
//  NewsTableViewController.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "NewsTableViewController.h"
#import "FirstRowImageCell.h"
#import "NewsCell.h"
#import "WebService.h"
#import "WebServiceFactory.h"
#import "NSDate-Compare.h"
#import "AboutTime.h"
#import "UIImageView+WebCache.h"

#define FIRST_ROW_IMAGE_HEIGHT                      170
#define NORmAL_ROW_HEIGHT                           75
#define SAVED_NEWS_NUMBER                           10      //保存在缓存区的新闻数目
#define MAX_TOP_NEWSES                              5

@interface NewsTableViewController ()

//- (void)endUpdateWithWebService:(NSNotification* )notification;
- (void)loadNewsTableViewTitle;//模板方法
- (void)loadInitialNews;//加载初始化新闻
//以下两个方法还没有实现
- (void)loadTopNews;//加载置顶新闻
- (void)doLoadTopNewsWebService;//模板方法，加载置顶新闻的webservice
//
- (void)registWebserviceFinishNotification;//模板方法，注册webservice收到数据时的通知
- (void)registNotificationWhenApplicationInBackground;//注册通知，当手机进入后台的时候调用
- (void)cellLoadFirstRowImage:(UITableViewCell* )sender; 
- (void)loadCellInformation:(UITableViewCell* )sender AtIndexpath:(NSIndexPath* )indexpath;
- (BOOL)judgeTheImageIsExitingInIndexPath:(NSIndexPath* )indexpath;
- (void)doWebServiceWithFirstDate:(NSString* )sender;
- (void)doWebServiceWithLastDate:(NSString* )sender;
- (void)doUpdateTheNews:(NSNotification* )sender;//模板方法，更新当天新闻
- (void)addNewNewsInToOldNewses:(NSDictionary* )newNewsDictionary;

@end

@implementation NewsTableViewController
@synthesize delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self loadNewsTableViewTitle];
        [self registWebserviceFinishNotification];
        //根据title加载新闻，
        //先从缓存区加载，若缓存区为空，这通过webservices加载
        [self loadInitialNews];
        
        //当手机进入后台时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(registNotificationWhenApplicationInBackground)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        // Custom initialization
    }
    return self;
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

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.showDataDictionary count] > 0) {
        [self.tableView setHidden:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.showDataDictionary count] == 0) {
        [self.tableView setHidden:YES];
    }
    else
    {
        [self.tableView setHidden:NO];
    }
}

#pragma mark tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [allKeys_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //第一块是置顶新闻，
    if (section == 0) {
        return 1;
    }
    //
    NSDate* date = [allKeys_ objectAtIndex:section];
    NSMutableArray* newsesInDate = [self.showDataDictionary objectForKey:date];
    return [newsesInDate count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    if (section == 0 && row == 0 &&
        [[allKeys_ objectAtIndex:0] isKindOfClass:NSClassFromString(@"NSString")])
    {
        
        if ([[allKeys_ objectAtIndex:0] isEqualToString:@"置顶"]) {
            return FIRST_ROW_IMAGE_HEIGHT;
        }
        else
        {
            return NORmAL_ROW_HEIGHT;
        }
    }
    else {
        return NORmAL_ROW_HEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *firstCellIdentifier = @"FirstImageRowCell";
    static NSString *withImageCellIdentifier = @"WithImageCell";
    static NSString *withoutImageCellIdentifier = @"withoutImageCell";
    int section = [indexPath section];
    int row = [indexPath row];
    if (section == 0 && row == 0 &&
        [[allKeys_ objectAtIndex:0] isKindOfClass:NSClassFromString(@"NSString")])
    {
        
        if ([[allKeys_ objectAtIndex:0] isEqualToString:@"置顶"]) {
            
            FirstRowImageCell* cell = (FirstRowImageCell* )[tableView dequeueReusableCellWithIdentifier:firstCellIdentifier];
            if (cell == nil) {
                cell = [[FirstRowImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCellIdentifier];
                cell.selectedDelegate = self;
            }
            //set first row image
            [self cellLoadFirstRowImage:cell];
            [self updateTheFootViewFrame];
            return cell;
        }
        
    }
    else {
        if ([self judgeTheImageIsExitingInIndexPath:indexPath]) {
            NewsCell* cell = (NewsCell* )[tableView dequeueReusableCellWithIdentifier:withImageCellIdentifier];
            if (cell == nil) {
                UINib* nib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:withImageCellIdentifier];
                cell = (NewsCell* )[tableView dequeueReusableCellWithIdentifier:withImageCellIdentifier];
            }
            //set news cell information
            [self loadCellInformation:cell AtIndexpath:indexPath];
            [self updateTheFootViewFrame];
            cell.titleLabel.adjustsFontSizeToFitWidth = NO;
            cell.bodyLabel.adjustsFontSizeToFitWidth = NO;
            return cell;

        }
        else
        {
            NewsCell* cell = (NewsCell* )[tableView dequeueReusableCellWithIdentifier:withoutImageCellIdentifier];
            if (cell == nil) {
                UINib* nib = [UINib nibWithNibName:@"NewsWithoutImageCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:withoutImageCellIdentifier];
                cell = (NewsCell* )[tableView dequeueReusableCellWithIdentifier:withoutImageCellIdentifier];
            }
            int section = [indexPath section];
            int row = [indexPath row];
            NSDate* key = [allKeys_ objectAtIndex:section];
            NSArray* newsesInKey = [self.showDataDictionary objectForKey:key];
            NewsObject* news = [newsesInKey objectAtIndex:row];
            cell.titleLabel.text = news.title;
            cell.bodyLabel.text = news.synopsis;
            cell.titleLabel.adjustsFontSizeToFitWidth = NO;
            cell.bodyLabel.adjustsFontSizeToFitWidth = NO;
            return cell;
        }
    }
    
    // Configure the cell...
    
    return nil;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSArray* newsesInKey = [self.showDataDictionary objectForKey:key];
    NewsObject* news = [newsesInKey objectAtIndex:row];
    
    //add the this kind of news to |showNewsQueue|
    NSMutableArray* showingNewsQueue = [NSMutableArray array];
    int showNewsIndex = 0;
    BOOL receiveTheShowIndex = NO;
    for (id key in allKeys_)
    {
        NSArray* newsInKey = [self.showDataDictionary objectForKey:key];
        for (NewsObject* new in newsInKey) {
            [showingNewsQueue addObject:new];
            if ([new isEqual:news]) {
                receiveTheShowIndex = YES;
            }
            if (!receiveTheShowIndex) {
                showNewsIndex ++;
            }
        }
    }

    NSDictionary* notificationObject = [NSDictionary dictionaryWithObjectsAndKeys:showingNewsQueue,@"ShowingNewsQueue",[NSNumber numberWithInt:showNewsIndex],@"ShowingIndex", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateNewsQueue" object:notificationObject];
    
    //show the selected news
    [self.delegate tableViewController:self selectedTheIndexPath:indexPath News:news];
}

#pragma mark firstSection selection
- (void)selectTheNews:(NewsObject* )sender
{
    NSMutableArray* showingNewsQueue = [NSMutableArray array];
    int showNewsIndex = 0;
    BOOL receiveTheShowIndex = NO;
    for (id key in allKeys_)
    {
        NSArray* newsInKey = [self.showDataDictionary objectForKey:key];
        for (NewsObject* new in newsInKey) {
            [showingNewsQueue addObject:new];
            if ([new isEqual:sender]) {
                receiveTheShowIndex = YES;
            }
            if (!receiveTheShowIndex) {
                showNewsIndex ++;
            }
        }
    }
    NSDictionary* notificationObject = [NSDictionary dictionaryWithObjectsAndKeys:showingNewsQueue,@"ShowingNewsQueue",[NSNumber numberWithInt:showNewsIndex],@"ShowingIndex", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateNewsQueue" object:notificationObject];
    
    //show the selected news
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.delegate tableViewController:self selectedTheIndexPath:indexPath News:sender];
}

#pragma mark update the Data
- (void)updateTheData
{
    //根据第一条信息的日期进行比此日期更早的新闻的更新
    NSDate* firstDate;
    if ([[allKeys_ objectAtIndex:0] isKindOfClass:NSClassFromString(@"NSString")]) {
        firstDate = [allKeys_ objectAtIndex:1];
    }
    else
    {
        firstDate = [allKeys_ objectAtIndex:0];
    }
    NSString* firstDateString = [[firstDate description] substringToIndex:19];
    NSString* firstDateStringWithouSpace = [firstDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    //NSString* firstDateString = @"2012-12-1";
    [self doWebServiceWithFirstDate:firstDateStringWithouSpace];
}
//模板方法，在子类中实现
- (void)doWebServiceWithFirstDate:(NSString* )sender
{
    
}

- (void)loadMoreData
{
    //得到最后的时间
    NSDate* notTopLastDate = [allKeys_ lastObject];
    NSArray* topNewses = [self.showDataDictionary objectForKey:@"置顶"];
    NSDate* topNewsLastDate = nil;
    for (NewsObject* news in topNewses) {
        if (topNewsLastDate == nil) {
            topNewsLastDate = news.date;
            continue;
        }
        if ([[topNewsLastDate earlierDate:news.date] isEqual:news.date]) {
            topNewsLastDate = news.date;
        }
    }
    
    NSDate* lastDate = topNewsLastDate == nil?notTopLastDate:[topNewsLastDate earlierDate:notTopLastDate];
    NSString* bufferName = [NSString stringWithFormat:@"News_%@",self.title];
    NSArray* newsArray = [[NewsBuffer singleton] getDataInBufferWithIdentifier:bufferName];
    if (newsArray == nil) {
        NSString* lastDateString = [[lastDate description] substringToIndex:19];
        NSString* correctLastDateString = [lastDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [self doWebServiceWithLastDate:correctLastDateString];
        return;
    }
    NewsObject* earliestNewsInBuffer = [newsArray lastObject];
    NSDate* earliestDateInBuffer = earliestNewsInBuffer.date;
    NSDate* earliestDateInSelf = [allKeys_ lastObject];
    
    if ([earliestDateInBuffer earlierDate:earliestDateInSelf] == earliestDateInBuffer &&
        ![earliestDateInBuffer isEqual:earliestDateInSelf]) {
        [self doneLoadMore:newsArray];
    }
    else
    {
        //缓存区里的数据已过时，清空缓存区
        NSString* bufferName = [NSString stringWithFormat:@"News_%@",self.title];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearBuffer"
                                                            object:bufferName];
        //通过webService获得更老的数据
        NSString* lastDateString = [[lastDate description] substringToIndex:19];
        NSString* correctLastDateString = [lastDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [self doWebServiceWithLastDate:correctLastDateString];
    }
}

//模板方法，在子类中实现
//通过webservice获得更古老的新闻
- (void)doWebServiceWithLastDate:(NSString* )sender
{
    
}

#pragma mark template Method implementation
//收到|YaowenReceiveNewsWebService|等通知时，调用的方法
- (void)doneUpdateLoading:(id )sender
{
    if (sender != nil)
    {
        NSDictionary* newsesDictionary = (NSDictionary* )sender;
        [self addNewNewsInToOldNewses:newsesDictionary];
    }
}

//收到|YaowenLoadMoreNewsFinished|等通知使调用的方法
- (void)doneLoadMore:(id )sender
{
    if (sender != nil) {
        NSDictionary* allNewses = (NSDictionary* )sender;
        [self addNewNewsInToOldNewses:allNewses];
    }
}


#pragma mark private
//------------------------------------------------------------------------------
- (void)loadNewsTableViewTitle//模板方法
{
    
}

- (void)registWebserviceFinishNotification
{
    
}

- (void)loadInitialNews//加载初始化新闻
{
    NSString* bufferName = [NSString stringWithFormat:@"News_%@",self.title];
    NSArray* newsArray = [[NewsBuffer singleton] getDataInBufferWithIdentifier:bufferName];
    if (newsArray == nil || [newsArray count] == 0) {
        //加载所有新闻
        self.showDataDictionary = [NSMutableDictionary dictionary];
        NSDate* today = [[AboutTime singleton] getCorrectDate:[NSDate date]];
        NSString* todayString = [[today description] substringToIndex:19];
        NSString* correctLastDateString = [todayString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [self doWebServiceWithLastDate:correctLastDateString];
        //加载置顶新闻
        [self loadTopNews];
        //待实现
        return;
    }
    else
    {
        NSMutableDictionary* newsDictionary = [NSMutableDictionary dictionary];
        for (NewsObject* news in newsArray) {
            BOOL top = news.top;
            if (top) {
                if ([newsDictionary objectForKey:@"置顶"] == nil) {
                    NSMutableArray* topNewses = [NSMutableArray array];
                    [topNewses addObject:news];
                    [newsDictionary setObject:topNewses forKey:@"置顶"];
                }
                else
                {
                    NSMutableArray* topNewses = [newsDictionary objectForKey:@"置顶"];
                    [topNewses addObject:news];
                }
            }
            else
            {
                NSDate* date = news.date;
                if ([[newsDictionary allKeys] containsObject:date]) {
                    NSMutableArray* array = [newsDictionary objectForKey:date];
                    [array addObject:news];
                }
                else
                {
                    NSMutableArray* array = [NSMutableArray array];
                    [array addObject:news];
                    [newsDictionary setObject:array forKey:date];
                }
            }
        }
        self.showDataDictionary = newsDictionary;
    }
}

- (void)registNotificationWhenApplicationInBackground//注册通知，当手机进入后台的时候调用
{
    NSDictionary* allNewsDictionary = self.showDataDictionary;
    NSArray* newsKeys = allKeys_;
    NSMutableArray* newsArray = [NSMutableArray array];
    int numberOfNews = 0;
    for (int index = 0; index < [newsKeys count]; index ++) {
        NSDate* date = [allKeys_ objectAtIndex:index];
        NSArray* newsInDate = [allNewsDictionary objectForKey:date];
        for (NewsObject* news in newsInDate) {
            [newsArray addObject:news];
            numberOfNews ++;
            if (numberOfNews == SAVED_NEWS_NUMBER) {
                break;
            }
        }
    }
    NSString* bufferName = [NSString stringWithFormat:@"News_%@",self.title];
    NSDictionary* toSavedNews = [NSDictionary dictionaryWithObjectsAndKeys:newsArray,bufferName, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveInNewsBuffer"
                                                        object:toSavedNews];
}
- (void)addNewNewsInToOldNewses:(NSDictionary* )newNewsDictionary
{
    
    NSArray* topNewses = [newNewsDictionary objectForKey:@"置顶"];
    NSArray* notTopNewses = [newNewsDictionary objectForKey:@"不置顶"];
    NSMutableDictionary* oldShowNews = [NSMutableDictionary dictionaryWithDictionary:self.showDataDictionary];
    //添加不置顶新闻
    for (NewsObject* news in notTopNewses) {
        NSDate* date = news.date;
        if ([[oldShowNews allKeys] containsObject:date]) {
            NSMutableArray* newsesInDate = [oldShowNews objectForKey:date];
            BOOL add = YES;
            for (NewsObject* oldNews in newsesInDate) {
                if ([oldNews.ID isEqualToString:news.ID]) {
                    add = NO;
                    break;
                }
            }
            if (add) {
                [newsesInDate addObject:news];
            }
        }
        else
        {
            NSMutableArray* newsesInDate = [NSMutableArray array];
            [newsesInDate addObject:news];
            [oldShowNews setObject:newsesInDate forKey:date];
        }
        
    }
    //添加置顶新闻
    for (NewsObject* news in topNewses) {
        if ([[oldShowNews objectForKey:@"置顶"] count] == 5) {
            
        }
        if ([oldShowNews objectForKey:@"置顶"] == nil) {
            NSMutableArray* topEmptyNews = [NSMutableArray array];
            [oldShowNews setObject:topEmptyNews forKey:@"置顶"];
        }
        NSMutableArray* oldTopNewses = [oldShowNews objectForKey:@"置顶"];
        BOOL haveExist = NO;
        for (NewsObject* oldTopNews in oldTopNewses) {
            if ([oldTopNews.ID isEqual:news.ID]) {
                haveExist = YES;
            }
        }
        if (!haveExist) {
            [oldTopNewses addObject:news];
        }
    }
    self.showDataDictionary = oldShowNews;
}

- (void)doUpdateTheNews:(NSNotification* )sender
{
    self.showDataDictionary = nil;
    NSDate* today = [[AboutTime singleton] getCorrectDate:[NSDate date]];
    NSString* todayString = [[today description] substringToIndex:19];
    NSString* correctLastDateString = [todayString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    [self doWebServiceWithLastDate:correctLastDateString];
    [self loadTopNews];
    
}

- (void)cellLoadFirstRowImage:(UITableViewCell* )sender
{
    FirstRowImageCell* cell = (FirstRowImageCell* )sender;
    //
    NSArray* topNewses = [self.showDataDictionary objectForKey:@"置顶"];
    [cell setNewses:topNewses];
    
}

- (void)loadCellInformation:(UITableViewCell* )sender AtIndexpath:(NSIndexPath* )indexpath
{
    NewsCell* cell = (NewsCell* )sender;
    //int row = [indexpath row];
    int section = [indexpath section];
    int row = [indexpath row];
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSArray* newsesInkey = [self.showDataDictionary objectForKey:key];
    NewsObject* newsInformation = [newsesInkey objectAtIndex:row];

    NSString* title = newsInformation.title;
    NSString* synopsis = newsInformation.synopsis;
    UIImage* image = newsInformation.synopsisImage;
    if (image == nil) {
        newsInformation.synopsisImagePath = [newsInformation.synopsisImagePath stringByReplacingOccurrencesOfString:@"%%25" withString:@"%%"];
        newsInformation.synopsisImagePath = [newsInformation.synopsisImagePath stringByReplacingOccurrencesOfString:@"%%20" withString:@" "];
        NSURL* netImageNameURL = [NSURL URLWithString:newsInformation.synopsisImagePath];
        NSLog(@"%@",newsInformation.synopsisImagePath);
        [cell.newsImageView setImageWithURL:netImageNameURL
                           placeholderImage:[UIImage imageNamed:@"placehorder.png"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            newsInformation.synopsisImage = image;
          CATransition* transtion = [CATransition animation];
          transtion.duration = 0.5;
          [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
          [transtion setType:kCATransitionFade];
          [cell.newsImageView.layer addAnimation:transtion forKey:@"transitionKey"];
          [cell.newsImageView setImage:image];

        }];
        newsInformation.synopsisImage = cell.newsImageView.image;
    }
    else
    {
        CATransition* transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transtion setType:kCATransitionFade];
        [cell.newsImageView.layer addAnimation:transtion forKey:@"transitionKey"];
        [cell.newsImageView setImage:image];
    }
    cell.titleLabel.text = title;
    cell.bodyLabel.text = synopsis;
}

- (BOOL)judgeTheImageIsExitingInIndexPath:(NSIndexPath* )indexpath
{
    int section = [indexpath section];
    int row = [indexpath row];
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSArray* newsesInkey = [self.showDataDictionary objectForKey:key];
    NewsObject* news = [newsesInkey objectAtIndex:row];
    NSString* imageURL = news.synopsisImagePath;
    UIImage* image = news.synopsisImage;
    if (imageURL == nil && image == nil) {
        return NO;
    }
    else
    {
        return YES;
    }
}

//将置顶属性为YES的新闻放在第一行，
- (void)sortTheKey
{
    BOOL haveTopNewsOrNot = NO;
    id topKey;
    for (id key in allKeys_)
    {
        if ([key isKindOfClass:NSClassFromString(@"NSString")]) {
            if ([key isEqualToString:@"置顶"]) {
                haveTopNewsOrNot = YES;
                topKey = key;
            }
        }
    }
    NSMutableArray* temlAllKeys = [NSMutableArray arrayWithArray:allKeys_];
    //将置顶的KEY移除
    if (haveTopNewsOrNot) {
        [temlAllKeys removeObject:topKey];
        //将剩下的Key排序
        NSArray* temp = [temlAllKeys sortedArrayUsingSelector:@selector(compare:)];
        //将置顶的Key插入到第一个位置
        [temlAllKeys removeAllObjects];
        [temlAllKeys addObjectsFromArray:temp];
        [temlAllKeys insertObject:topKey atIndex:0];
        allKeys_ = [NSArray arrayWithArray:temlAllKeys];
    }
    else
    {
        allKeys_ = [allKeys_ sortedArrayUsingSelector:@selector(compare:)];
    }
}

//以下两个方法还没有实现
- (void)loadTopNews//加载置顶新闻
{
    [self doLoadTopNewsWebService];
}

- (void)doLoadTopNewsWebService//模板方法，加载置顶新闻的webservice
{
    
}

@end
