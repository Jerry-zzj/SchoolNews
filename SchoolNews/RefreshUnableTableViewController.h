//
//  RefreshUnableTableViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月3星期一.
//
//

#import <UIKit/UIKit.h>

@interface RefreshUnableTableViewController : UITableViewController
{
    NSArray* allKeys_;
}
@property (nonatomic,strong) NSDictionary* showDataDictionary;
- (id)initWithStyle:(UITableViewStyle)style Frame:(CGRect )frame;

@end
