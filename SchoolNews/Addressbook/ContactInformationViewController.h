//
//  ContactInformationViewController.h
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchEventTableView.h"
#import "PhoneNumberCell.h"
@interface ContactInformationViewController : UITableViewController<TouchEventTableViewMoveDelegate,UIAlertViewDelegate,UIActionSheetDelegate,PhoneNUmberCellDelegate>
{
    NSDictionary* contact_;
    NSArray* keys_;
    CGPoint touchBeginPoint_;
    NSString* selectedNumber_;
}
- (id)initWithContact:(NSDictionary* )dictionary;
@end
