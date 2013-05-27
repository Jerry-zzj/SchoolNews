//
//  PullHeaderViewController.h
//  SchoolNews
//
//  Created by Jerry on 3月19星期二.
//
//

#import <UIKit/UIKit.h>
@protocol PullHeaderViewControllerDelegate<NSObject>

- (void)chooseTheFunctionGotoSettingView;
- (void)chooseTheFunctionGotoAddSubscriptionView;
- (void)chooseChangeTheEditState;

@end
@interface PullHeaderViewController : UIViewController
{
    UILabel* nameLabel_;
    UIImageView* avatorImageView_;
}
@property (nonatomic,retain)id<PullHeaderViewControllerDelegate> delegate;
+ (PullHeaderViewController* )singleton;
@end
