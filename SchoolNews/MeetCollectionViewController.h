//
//  MeetCollectionViewController.h
//  SchoolNews
//
//  Created by Jerry on 3月25星期一.
//
//

#import <UIKit/UIKit.h>
@protocol MeetCollectionViewControllerDelegate<NSObject>

- (void)showTheWeek:(int )week;

@end
@interface MeetCollectionViewController : UICollectionViewController
@property (nonatomic,assign)id<MeetCollectionViewControllerDelegate> delegate;
- (void)scrollToSpecialItem:(int )sender;
@end
