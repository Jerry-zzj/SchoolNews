//
//  FunctionPositionEditViewController.h
//  SchoolNews
//
//  Created by Jerry on 3月20星期三.
//
//

#import <UIKit/UIKit.h>

@protocol FunctionPositionEditViewControllerDelegate <NSObject>

- (void)finishTheFunctionPositionEdit;

@end

@interface FunctionPositionEditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* tableView_;
}
+ (FunctionPositionEditViewController* )singleton;
@property (nonatomic,retain)id<FunctionPositionEditViewControllerDelegate> delegate;
@end
