//
//  SubtitleSettingViewController.h
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubtitleSettingViewController : UIViewController
{
    NSMutableArray* showSubtitleArray_; //object is button
    NSMutableArray* unshowSubtitleArray_; //object is button
    NSArray* showButtonFrames_;
    NSArray* unshowButtonFrames_;
    
    NSArray* allSubtitleArray_;
}
+ (SubtitleSettingViewController* )singleton;
@end
