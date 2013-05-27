//
//  TouchEventTableView.h
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import <UIKit/UIKit.h>
@protocol TouchEventTableViewMoveDelegate<UITableViewDelegate,UIGestureRecognizerDelegate>

- (void)touchMoveToRight;
- (void)touchMoveToLeft;
@end
@protocol TouchEventTableViewTouchDelegate <NSObject>

@optional
- (void)touchDownInTableView;


@end

@interface TouchEventTableView : UITableView
{
    CGPoint touchBeginPoint_;
}
@property (nonatomic, assign)id<TouchEventTableViewMoveDelegate> moveDelegate;
@property (nonatomic, assign)id<TouchEventTableViewTouchDelegate> touchDelegate;
@end
