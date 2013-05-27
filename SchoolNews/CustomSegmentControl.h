//
//  CustomSegmentControl.h
//  CustomSegmentControl
//
//  Created by Jerry on 4月26星期五.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    Style1,                     //不同的标签有不同的图片
    Style2,                     //选中的标签和没有选中的标签有不同的图片
}SegmentControlStyle;
@protocol CustomSegmentControlDelegate <NSObject>

- (void)selectTheItenAtIndex:(int )selectedIndex;

@end

@interface CustomSegmentControl : UIView
@property (nonatomic,assign)id<CustomSegmentControlDelegate> delegate;

- (id)initWithFrame:(CGRect)frame ImageArray:(NSArray* )images TitleArray:(NSArray* )titles;
- (id)initWithFrame:(CGRect)frame TitleArray:(NSArray* )titles SelectedImage:(UIImage* )selectedImage UnselectedImage:(UIImage* )unselectedImage;

- (void)toSelectTheItemAtIndex:(int )index;

- (void)setUpGap:(float )upGapSender DownGap:(float )downGapSender leftAndRightGap:(float )leftAndRightSender;

- (void)setBackgroundImage:(UIImage* )image;
- (void)setTabBarGap:(float )gap;
- (void)setTabBarUpGap:(float )gap;
- (void)setTabBarDownGap:(float )gap;
@end
