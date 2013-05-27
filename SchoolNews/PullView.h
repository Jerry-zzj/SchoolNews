//
//  PullView.h
//  SchoolNews
//
//  Created by Jerry on 3月19星期二.
//
//

#import <UIKit/UIKit.h>
@protocol PullViewDelegate<NSObject>

- (void)pullViewMoveDistance:(float )distance;
- (void)pullViewHidden;
- (void)pullViewShowTotal;

@end

@interface PullView : UIView
{
}
@property (nonatomic,assign)id<PullViewDelegate> delegate;
+ (PullView* )singleton;
- (void)pullViewToHidden:(BOOL)animation;
- (void)pullViewToShow:(BOOL)animation;
- (BOOL)moreFunctionShow;
- (void)movePullViewDistance:(float)distanceSender animated:(BOOL)animated;
@end
