//
//  NotificationCollectionViewController.h
//  SchoolNews
//
//  Created by Jerry on 3月28星期四.
//
//

#import <UIKit/UIKit.h>
@protocol NotificationCollectionViewControllerDelegate<NSObject>

- (void)notificationCollectionViewScrollToItem:(int )item;

@end

@interface NotificationCollectionViewController : UICollectionViewController
@property (nonatomic,retain)id<NotificationCollectionViewControllerDelegate> delegate;
-(void)scrollToSpecialItem:(int )sender;
@end
