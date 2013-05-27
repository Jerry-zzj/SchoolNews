//
//  MeetCollectionViewCell.h
//  SchoolNews
//
//  Created by Jerry on 3月25星期一.
//
//

#import <UIKit/UIKit.h>
#import "MeetWebService.h"
#import "MeetListTableViewController.h"
@interface MeetCollectionViewCell : UICollectionViewCell<MeetWebServiceDelegate>
@property (nonatomic,assign)int savedWeek;
@property (nonatomic,assign)int savedWeekday;
- (void)setWeek:(int )week AndWeekday:(int )weekday;
- (void)clearData;
- (void)refreshData;
@end
