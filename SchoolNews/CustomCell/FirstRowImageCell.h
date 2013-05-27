//
//  FirstRowImageCell.h
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsObject;
@protocol FirstRowImageCellDelegate

- (void)selectTheNews:(NewsObject* )sender;

@end
@interface FirstRowImageCell : UITableViewCell<UIScrollViewDelegate>
{
    UIScrollView* backgroundScrollView_;
    UILabel* titleLabel_;
    UIPageControl* pageControl_;
    NSArray* newses_;
}
@property (nonatomic,assign)id<FirstRowImageCellDelegate> selectedDelegate;
//@property (nonatomic,strong)IBOutlet UIImageView* imageView;
- (void)setNewses:(NSArray* )sender;
@end
