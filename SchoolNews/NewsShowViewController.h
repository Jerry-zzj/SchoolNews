//
//  NewsShowViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import <UIKit/UIKit.h>
#import "ShowNewsQueue.h"
#import "NewsShowWebService.h"
#import "NewsWebViewController.h"
@interface NewsShowViewController : UIViewController<NewsShowWebServiceDelegate,NewsWebViewControllerDataSource,NewsWebViewControllerDelegate>
{
    NewsWebViewController* newsWebViewController_;
}
@property (nonatomic, retain)NewsObject* news;

- (id)initWithNews:(NewsObject* )newsSender;
//+ (NewsShowViewController* )singleton;
@end
