//
//  FunctionViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月19星期三.
//
//

#import <UIKit/UIKit.h>
#import "SubFunctionViewController.h"
#import "TouchEnableView.h"
#import "FunctionPosition.h"
#import "RemoteNotificationCenter.h"
typedef enum{
    Normal,
    SubFunction
}Mode;
@class SubFunctionViewController;
@interface FunctionViewController : UIViewController<SubFunctionViewControllerDelegate,SubFunctionViewControllerDataSource,TouchEnabelViewDelegate>
{
    Mode mode_;
    TouchEnableView* dragView_;
    UIView* subFunctionLocationView_;
    SubFunctionViewController* subfunctionViewController_;
    TouchEnableView* maskView_;
    
}
@property (nonatomic,assign)int badgeNumber;
//@property (nonatomic,retain)UIImage* notInTabBarImage;
@property (nonatomic,retain)UIImage* iconImage;
@property (nonatomic,retain)NSMutableArray* subFunction;
@property (nonatomic,retain)NSString* functionCode;
//选择二级菜单
- (void)selectTheSubFunction:(id)sender;
//
//- (void)setSubFunctionMode:(Mode )sender;
- (void)transformToMode:(Mode )sender;
//初始化正常界面
- (void)loadNormalMode;
//初始化二级菜单界面
- (void)initialSubFunctions;
//隐藏Tabbar
- (void)hideTabBar;
//展示TabBar
- (void)showTabBar;
//更新二级菜单
- (void)updateTheSubFunctionViewController;
//处理推送消息
- (void)handleThePushNotification;
@end
