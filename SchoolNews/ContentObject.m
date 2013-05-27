//
//  ContentObject.m
//  SchoolNews
//
//  Created by Jerry on 4月12星期五.
//
//

#import "ContentObject.h"
#import "JobObject.h"
#import "NotificationObject.h"
#import "NewsObject.h"
#import "NotificationContentWebService.h"
#import "NewsShowWebService.h"
#import "ReproduceEmploymentContentWebservice.h"

@implementation ContentObject
@synthesize title;
@synthesize ID;
@synthesize type;
@synthesize webservice;
@synthesize releaseDate;
@synthesize releaseDepartment;
@synthesize webContent;
@synthesize newsFrom;
@synthesize sourceObject;

- (void)setContent:(NSString *)sender
{
    if (sourceObject != nil) {
        [sourceObject setValue:sender forKeyPath:@"content"];
    }
}

//以招聘信息进行初始化
- (id)initWithJob:(JobObject* )sender
{
    self = [super init];
    if (self) {
        self.ID = sender.ID;
        self.title = sender.title;
        self.type = sender.type;
        self.webContent = sender.content;
        if (!self.webContent) {
            self.webservice = [[ReproduceEmploymentContentWebservice alloc] init];
            [(ReproduceEmploymentContentWebservice* )self.webservice setDelegate:self];
            NSString* urlString = [NSString stringWithFormat:@"http://cmccapp.zjicm.edu.cn/axis2/services/EmploymentService/getReproducedTotalInformationForID?ID=%@",self.ID];
            [webservice setURLWithString:urlString];
        }
        self.releaseDate = sender.date;
        self.releaseDepartment = sender.releasePerson;
        self.sourceObject = sender;
    }
    return self;
}

//以通知进行初始化
- (id)initWithNotification:(NotificationObject* )sender
{
    self = [super init];
    if (self) {
        self.ID = sender.ID;
        self.title = sender.title;
        self.type = sender.type;
        self.webContent = sender.content;
        if (!self.webContent) {
            self.webservice = [[NotificationContentWebService alloc] init];
            [(NotificationContentWebService*)self.webservice setDelegate:self];
            NSString* urlString = [NSString stringWithFormat:@"http://cmccapp.zjicm.edu.cn/axis2/services/NotificationService/getNotificationContentWithID?ID=%@",self.ID];
            [self.webservice setURLWithString:urlString];
            [self.webservice getWebServiceData];
        }
        self.releaseDate = sender.date;
        self.releaseDepartment = sender.department;
        self.sourceObject = sender;
    }
    return self;
}

//以新闻进行初始化
- (id)initWithNews:(NewsObject* )sender
{
    self = [super init];
    if (self) {
        self.ID = sender.ID;
        self.title = sender.title;
        self.type = sender.subtitle;
        self.webContent = sender.content;
        if (!self.webContent) {
            self.webservice = [[NewsShowWebService alloc] init];
            NSString* urlString = [NSString stringWithFormat:@"http://cmccapp.zjicm.edu.cn/axis2/services/NewsService/getNewsContent?ID=%@",self.ID];
            [webservice setURLWithString:urlString];
            [webservice getWebServiceData];
        }
        self.releaseDate = sender.date;
        self.releaseDepartment = sender.department;
        self.sourceObject = sender;
    }
    return self;
}

#pragma mark NotificationContent Webservice Delegate
- (void)getNotificationContent:(id)sender
{
    self.webContent = sender;
}

#pragma mark JobContent webservice delegate
- (void)getReproduceEmploymentContent:(id)sender
{
    self.webContent = sender;
}

#pragma mark NewsContent webservice delegate
- (void)loadTheNews:(id)sender
{
    self.webContent = sender;
}
@end
