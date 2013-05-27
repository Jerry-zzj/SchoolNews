//
//  LecturesViewController.h
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FunctionViewController.h"
#import "LecturesTableViewController.h"
@interface LecturesViewController : FunctionViewController<LecturesTableViewControllerDelegate>
{
    LecturesTableViewController* lecturesTableViewController_;
}
+ (LecturesViewController* )singleton;
@end
