//
//  ForeignExchangeViewController.h
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FunctionViewController.h"
#import "ForeignExchangeViewController.h"
@interface ForeignExchangeViewController : FunctionViewController
@property (nonatomic,retain)UIImage* notInTabBarImage;
+ (ForeignExchangeViewController* )singleton;
@end
