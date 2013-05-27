//
//  TouchMoveWebView.h
//  SchoolNews
//
//  Created by Jerry on 4月12星期五.
//
//

#import <UIKit/UIKit.h>

@protocol TouchMoveWebViewMovedelegate <NSObject>

- (void)swipToLeft;
- (void)swipToRight;

@end
@interface TouchMoveWebView : UIWebView
@property (nonatomic,retain)id<TouchMoveWebViewMovedelegate> swipDelegate;
@end
