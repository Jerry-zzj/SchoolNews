//
//  NetWorkAlter.h
//  SchoolNews
//
//  Created by Jerry on 4月28星期日.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NetWorkAlter : NSObject<UIAlertViewDelegate>
+ (NetWorkAlter* )singleton;
- (void)showTheAlter;
@end
