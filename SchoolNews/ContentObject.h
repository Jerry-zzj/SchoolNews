//
//  ContentObject.h
//  SchoolNews
//
//  Created by Jerry on 4月12星期五.
//
//

#import <Foundation/Foundation.h>
#import "NotificationContentWebService.h"
#import "ReproduceEmploymentContentWebservice.h"
#import "NewsShowWebService.h"

@class JobObject;
@class NotificationObject;
@class NewsObject;
@class WebService;
@interface ContentObject : NSObject<NotificationContentWebServiceDelegate,ReproduceEmploymentContentWebserviceDelegate,NewsShowWebServiceDelegate>
@property (nonatomic,retain)NSString* ID;
@property (nonatomic,retain)WebService* webservice;
@property (nonatomic,retain)NSString* title;
@property (nonatomic,retain)NSString* type;
@property (nonatomic,retain)NSDate* releaseDate;
@property (nonatomic,retain)NSString* releaseDepartment;
@property (nonatomic,retain)NSString* webContent;
@property (nonatomic,retain)NSString* newsFrom;
@property (nonatomic,retain)id sourceObject;

- (id)initWithJob:(JobObject* )sender;
- (id)initWithNotification:(NotificationObject* )sender;
- (id)initWithNews:(NewsObject* )sender;
@end
