//
//  SchoolBusViewController.h
//  SchoolNews
//
//  Created by Jerry on 4月23星期二.
//
//

#import <UIKit/UIKit.h>
#import "CustomSegmentControl.h"
@interface SchoolBusViewController : UIViewController<CustomSegmentControlDelegate>
+ (SchoolBusViewController* )singleton;
@end
