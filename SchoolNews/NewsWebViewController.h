//
//  NewsWebViewController.h
//  SchoolNews
//
//  Created by Jerry on 1月23星期三.
//
//

#import <UIKit/UIKit.h>
#import "CustomWebView.h"
#import "NewsObject.h"
@protocol NewsWebViewControllerDelegate<NSObject>

- (void)touchMoveToLeft;
- (void)touchMoveToRight;

@end

@protocol NewsWebViewControllerDataSource <NSObject>

- (NewsObject* )newsWebViewShowNews;

@end

@interface NewsWebViewController : UIViewController<CustomWebViewDelegate>
{
    CustomWebView* newsWebView_;
    NSString* content_;
    //float fontSize_;
    float titleSize_;
    float releaseSize_;
    float contentSize_;
}
@property (nonatomic,assign)id<NewsWebViewControllerDelegate> touchMoveDelegate;
@property (nonatomic,assign)id<NewsWebViewControllerDataSource> newsDataSource;
- (NewsWebViewController* )singleton;
- (void)setContent:(NSString* )sender;
@end
