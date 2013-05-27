//
//  CustomWebView.h
//  SchoolNews
//
//  Created by Jerry on 1月29星期二.
//
//

#import <UIKit/UIKit.h>
@protocol CustomWebViewDelegate<NSObject>

- (void)swipToLeft;
- (void)swipToRight;

@end
@interface CustomWebView : UIWebView

@property (nonatomic,assign)id<CustomWebViewDelegate> swipDelegate;
@end
