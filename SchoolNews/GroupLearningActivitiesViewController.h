//
//  GroupLearningActivitiesViewController.h
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FunctionViewController.h"
@class TextSortedByDateViewController;
@interface GroupLearningActivitiesViewController : FunctionViewController
{
    TextSortedByDateViewController* groupLearningActivitiesTableView_;
}
+ (GroupLearningActivitiesViewController* )singleton;
@end
