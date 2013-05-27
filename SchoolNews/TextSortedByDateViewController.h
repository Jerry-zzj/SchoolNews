//
//  TextSortedByDateViewController.h
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "RefreshUnableTableViewController.h"
@protocol TextSortedByDateViewControllerDelegate

- (void)choseTheDataDictionary:(NSDictionary* )sender;

@end
@interface TextSortedByDateViewController : RefreshUnableTableViewController
@property (nonatomic,assign)id<TextSortedByDateViewControllerDelegate> selectedDelegate;
@end
