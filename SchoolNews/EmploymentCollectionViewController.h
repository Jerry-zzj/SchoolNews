//
//  EmploymentCollectionViewController.h
//  SchoolNews
//
//  Created by Jerry on 4月11星期四.
//
//

#import <UIKit/UIKit.h>
@protocol EmploymentCollectionViewControllerDelegate<NSObject>

- (void)notificationCollectionViewScrollToItem:(int )item;

@end
@interface EmploymentCollectionViewController : UICollectionViewController
@property (nonatomic,retain)id<EmploymentCollectionViewControllerDelegate> delegate;
-(void)scrollToSpecialItem:(int )sender;
@end
