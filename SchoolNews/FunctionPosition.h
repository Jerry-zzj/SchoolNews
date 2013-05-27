//
//  FunctionPosition.h
//  SchoolNews
//
//  Created by Jerry on 3月18星期一.
//
//

#import <Foundation/Foundation.h>

@interface FunctionPosition : NSObject
+ (FunctionPosition* )singleton;
@property (nonatomic,retain)NSMutableArray* allFunctionViewControllers;
@property (nonatomic,retain)NSMutableArray* inTabbarViewControllers;
@property (nonatomic,retain)NSMutableArray* inPullViewControllers;
@property (nonatomic,retain)NSMutableArray* notShowViewControllers;
@end
