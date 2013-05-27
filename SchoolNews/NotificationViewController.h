//
//  NotificationViewController.h
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "FunctionViewController.h"
#import "NotificationCollectionViewController.h"
#import "NotificationObject.h"
#import "LoginViewController.h"
#import "SubtitleViewController.h"
#import "NotificationTableViewController.h"
@interface NotificationViewController : FunctionViewController<LoginViewControllerDelegate,SubtitleViewControllerDelegate,NotificationTableViewControllerDelegate,NotificationCollectionViewControllerDelegate>
{
    NotificationCollectionViewController* notificationCollectionViewController_;
    SubtitleViewController* subtitleViewController_;
}
@property (nonatomic,retain)UIImage* notInTabBarImage;
+ (NotificationViewController* )singleton;
- (void)selectTheNOtificationToGoToShowView:(NotificationObject* )sender;
@end
