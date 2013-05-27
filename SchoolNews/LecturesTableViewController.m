//
//  LecturesTableViewController.m
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import "LecturesTableViewController.h"
#import "LectureCell.h"
#import "LectureObject.h"
#import "AboutLabel.h"
#import "WebServiceFactory.h"
#import "LectureBuffer.h"
#import "LectureWebService.h"
#import "DataBaseOperating.h"
#import "PublicDefines.h"

@interface LecturesTableViewController ()

- (id)getDataAtIndexpath:(NSIndexPath* )sender;
- (void)doWebServiceWithLastDate:(NSString* )correctLastDateString;
- (void)addLectures:(id )sender;
- (NSDictionary* )getDataWithBuffer;
- (void)loadInitialLecture;

@end

@implementation LecturesTableViewController
@synthesize delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSDictionary* dataInBuffer = [self getDataWithBuffer];
        if (dataInBuffer != nil) {
            self.showDataDictionary = dataInBuffer;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(endUpdateWithWebService:)
                                                     name:LECTURE_END_UPDATE_WITH_WEBSERVICE
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInitialLecture];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table DataSource
- (int )numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allKeys_ count];
}

- (int )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDate* date = [allKeys_ objectAtIndex:section];
    NSArray* lecturesInDate = [self.showDataDictionary objectForKey:date];
    return [lecturesInDate count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*LectureObject* lecture = [self getDataAtIndexpath:indexPath];
    float titleHeight = [AboutLabel getHeightWithFontSize:17 Width:280 Text:lecture.title];
    float introductionHeight = [AboutLabel getHeightWithFontSize:14 Width:280 Text:lecture.lecturesIntroduction];
    return titleHeight + introductionHeight;*/
    return 77.5;
}

/*- (NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate* date = [allKeys_ objectAtIndex:section];
    NSString* dateString = [[date description]substringToIndex:19];
    return dateString;
}*/

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"LectureCellIdentifier";
    LectureCell* cell = (LectureCell* )[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = (LectureCell* )[[LectureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    LectureObject* lecture = [self getDataAtIndexpath:indexPath];
    NSString* title = lecture.title;
    //NSString* introduction = lecture.lecturesIntroduction;
    cell.titleLabel.text = title;
    cell.dateLabel.text = [[lecture.date description] substringToIndex:10];
    cell.underTaker.text = lecture.underTaker;
    return cell;
}

#pragma mark delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LectureObject* lecture = [self getDataAtIndexpath:indexPath];
    [self.delegate selectLecture:lecture];
}

#pragma mark template method implementation
- (void)doneUpdateLoading:(id )sender
{
    [self addLectures:sender];
}

- (void)doneLoadMore:(id )sender
{
    [self addLectures:sender];
}

#pragma mark data update
- (void)updateTheData
{
    //根据第一条信息的日期进行比此日期更早的新闻的更新
    NSDate* firstDate = [allKeys_ objectAtIndex:0];
    NSString* firstDateString = [[firstDate description] substringToIndex:19];
    NSString* firstDateStringWithouSpace = [firstDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/LectureService/getNewerLecture?date=",firstDateStringWithouSpace];
    NSLog(@"%@",urlString);
    WebService* lectureWebService = [[WebServiceFactory singleton] produceTheWebService:LECTURE_WEBSERVICE];
    [lectureWebService setURLWithString:urlString];
    [lectureWebService getWebServiceData];
}

- (void)loadMoreData
{
    NSDate* lastDate = [allKeys_ lastObject];
    NSArray* newsArray = [[LectureBuffer singleton] getDataInBufferWithIdentifier:@"Lecture"];
    if (newsArray == nil || [newsArray count] == 0) {
        NSString* lastDateString = [[lastDate description] substringToIndex:19];
        NSString* correctLastDateString = [lastDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [self doWebServiceWithLastDate:correctLastDateString];
        return;
    }
    LectureObject* earliestLectureInBuffer = [newsArray lastObject];
    NSDate* earliestDateInBuffer = earliestLectureInBuffer.date;
    LectureObject* earliestLectureInSelf = [[self.showDataDictionary objectForKey:[allKeys_ lastObject]] lastObject];
    NSDate* earliestDateInSelf = earliestLectureInSelf.date;
    
    if ([earliestDateInBuffer earlierDate:earliestDateInSelf] == earliestDateInBuffer) {
        [self doneLoadMore:newsArray];
    }
    else
    {
        //缓存区里的数据已过时，清空缓存区
        NSString* bufferName = [NSString stringWithFormat:@"Lecture"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearBuffer"
                                                            object:bufferName];
        //通过webService获得更老的数据
        NSString* lastDateString = [[lastDate description] substringToIndex:19];
        NSString* correctLastDateString = [lastDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [self doWebServiceWithLastDate:correctLastDateString];
    }
    
}

- (void)doWebServiceWithLastDate:(NSString* )sender
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN,@"/axis2/services/LectureService/getEarlierLecture?date=",sender];
    //NSLog(@"%@",urlString);
    WebService* lectureWebService = [[WebServiceFactory singleton] produceTheWebService:LECTURE_WEBSERVICE];
    [lectureWebService setURLWithString:urlString];
    [lectureWebService getWebServiceData];
}

- (void)addLectures:(id )sender
{
    NSArray* lectures = (NSArray* )sender;
    for (LectureObject* lecture in lectures) {
        NSDate* date = lecture.date;
        NSMutableDictionary* oldShowDictionary = [NSMutableDictionary dictionaryWithDictionary:self.showDataDictionary];
        if ([allKeys_ containsObject:date]) {
            NSMutableArray* lecturesInDate = [oldShowDictionary objectForKey:date];
            BOOL add = YES;
            for (LectureObject* lectureInOld in lecturesInDate) {
                if ([lectureInOld.ID isEqualToString:lecture.ID]) {
                    add = NO;
                    break;
                }
            }
            if (add) {
                [lecturesInDate addObject:lecture];
            }
        }
        else
        {
            NSMutableArray* lecturesInDate = [NSMutableArray array];
            [lecturesInDate addObject:lecture];
            [oldShowDictionary setObject:lecturesInDate forKey:date];
        }
        self.showDataDictionary = oldShowDictionary;
    }
}
#pragma mark private
- (id)getDataAtIndexpath:(NSIndexPath* )sender
{
    int section = [sender section];
    int row = [sender row];
    
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSArray* lectures = [self.showDataDictionary objectForKey:key];
    LectureObject* lecture = [lectures objectAtIndex:row];
    return lecture;
}

- (NSDictionary* )getDataWithBuffer
{
    NSArray* lecturesArray = [[LectureBuffer singleton] getDataInBufferWithIdentifier:@"Lecture"];
    NSMutableDictionary* LectureDictionary = [NSMutableDictionary dictionary];
    if ([lecturesArray count] > 0) {
        for (LectureObject* object in lecturesArray) {
            NSDate* date = object.date;
            if ([[LectureDictionary allKeys] containsObject:date]) {
                NSMutableArray* lectures = [LectureDictionary objectForKey:date];
                [lectures addObject:object];
            }
            else
            {
                NSMutableArray* lectures = [NSMutableArray array];
                [lectures addObject:object];
                [LectureDictionary setObject:lectures forKey:date];
            }
        }
    }
    else
    {
        return nil;
    }
    return LectureDictionary;
}

- (void)loadInitialLecture
{
    NSDate* date = [NSDate date];
    NSString* tempDateString = [[date description] substringToIndex:19];
    NSString* dateString = [tempDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    [self doWebServiceWithLastDate:dateString];
}
@end
