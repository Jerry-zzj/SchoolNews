//
//  SubFunctionViewController.h
//  CircleTableViewDemo
//
//  Created by Jerry on 4月18星期四.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubFunctionCell.h"
//#import "FunctionViewController.h"
@protocol SubFunctionViewControllerDelegate<NSObject>
@optional
//- (void)subFunctionShow;
- (void)selectTheSubFunction:(NSString* )subTitle;

@end

@class SubFunctionViewController;
@protocol SubFunctionViewControllerDataSource <NSObject>

- (int )subFunctionViewController:(SubFunctionViewController* )subFunctionViewController
    BadgeNumberAtSubFunctionTitle:(NSString* )title;
- (float )minimumLineSpacingOfSubFunctionViewController:(SubFunctionViewController* )subFunctionViewController;
- (UIImage* )subFunctionViewController:(SubFunctionViewController* )subFunctionViewController
                 SelectedImageForTitle:(NSString* )title;
- (UIImage* )subFunctionViewController:(SubFunctionViewController *)subFunctionViewController
               UnselectedImageForTitle:(NSString *)title;
- (NSArray* )titlesForSubFunctionViewController:(SubFunctionViewController* )subFunctionViewController;

@end

@class FunctionViewController;
@interface SubFunctionViewController : UICollectionViewController<SubFunctionCellDelegate>
@property (nonatomic,assign)id<SubFunctionViewControllerDelegate> delegate;
@property (nonatomic,assign)id<SubFunctionViewControllerDataSource> dataSource;
@property (nonatomic,assign)BOOL show;
- (void)traversalAllItems;
@end
