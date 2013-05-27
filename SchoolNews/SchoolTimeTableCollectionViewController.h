//
//  SchoolTimeTableCollectionViewController.h
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import <UIKit/UIKit.h>
#import "SchoolTimeTableModel.h"
@class SchoolTimeTableCollectionViewController;
@protocol SchoolTimeTableCollectionViewControllerDelegate<NSObject>

- (void)collectionViewControl:(SchoolTimeTableCollectionViewController* )sender scrollToIndex:(int )index;

@end
@interface SchoolTimeTableCollectionViewController : UICollectionViewController<SchoolTimeTableModelDelegate>
@property (nonatomic,assign)id<SchoolTimeTableCollectionViewControllerDelegate> delegate;
- (void)setWeek:(int )week Weekday:(int )weekday Animated:(BOOL )animated;
@end
