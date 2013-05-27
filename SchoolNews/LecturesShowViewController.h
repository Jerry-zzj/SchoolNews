//
//  LecturesShowViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月17星期一.
//
//

#import <UIKit/UIKit.h>
#import "FixedSequenceTableViewController.h"
#import "LectureObject.h"
@class FixedSequenceTableViewController;
@interface LecturesShowViewController : UIViewController<RefreshUnableTouchEnableViewControllerDelegate>
{
    FixedSequenceTableViewController* showTableView_;
}
@property(nonatomic,retain)LectureObject* showLecture;
- (id)initWithShowLecture:(LectureObject* )lecture;
@end
