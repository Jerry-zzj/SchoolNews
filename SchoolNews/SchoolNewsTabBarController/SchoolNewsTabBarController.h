//
//  SchoolNewsTabBarController.h
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullView.h"
#import "FunctionViewController.h"
#import "TouchEnableView.h"
#import "SubFunctionViewController.h"
@interface SchoolNewsTabBarController : UITabBarController<PullViewDelegate,TouchEnabelViewDelegate,SubFunctionViewControllerDelegate>
{
    NSMutableArray* nameIndexArray_;
    TouchEnableView* topView_;
}
@property (nonatomic,assign)UIViewController* lastSelectedViewController;
+ (SchoolNewsTabBarController* )singleton;
- (void)setLastTabBarItem:(FunctionViewController* )sender;
- (void)setTabBarHidden:(BOOL )hiddenSender Animated:(BOOL )animatedSender;
- (void)moveTabBarControllerToRight;
- (void)moveTabBarControllerToNormal;
@end
