//
//  SchoolTimeTableViewController.h
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "FunctionViewController.h"
#import "SchoolTimeTableModel.h"
#import "SchoolTimeTableCollectionViewController.h"
@interface SchoolTimeTableViewController : UIViewController<SchoolTimeTableModelDelegate,SchoolTimeTableCollectionViewControllerDelegate>
+ (id)singleton;
@end
