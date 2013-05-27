//
//  ContentShowWebViewController.h
//  SchoolNews
//
//  Created by Jerry on 4月12星期五.
//
//

#import <UIKit/UIKit.h>
#import "TouchMoveWebView.h"
@class ContentObject;
@interface ContentShowWebViewController : UIViewController<TouchMoveWebViewMovedelegate>
//@property (nonatomic,retain)ContentObject* contentObject;
- (id)initWithContentObject:(ContentObject* )sender;

- (void)setZoomEnable:(BOOL )sender;
@end
