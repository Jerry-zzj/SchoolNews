//
//  CustomSegmentControl.m
//  CustomSegmentControl
//
//  Created by Jerry on 4月26星期五.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import "CustomSegmentControl.h"
#import <QuartzCore/QuartzCore.h>
@interface CustomSegmentControl(privateAPI)

- (void)updateUI;
- (void)loadButton;
- (void)clickTheButton:(UIButton* )button;
- (void)reloadTheButtonFrameByGap;

@end

@implementation CustomSegmentControl
{
    NSMutableArray* buttons_;
    SegmentControlStyle style_;
    NSArray* images_;
    NSArray* titles_;
    UIImage* selectedImgae_;
    UIImage* unselectedImage_;
    int selectedItemIndex_;
    float tabBarGap_;
    float tabBarUpGap_;
    float tabBarDownGap_;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame ImageArray:(NSArray* )images TitleArray:(NSArray* )titles
{
    self = [super initWithFrame:frame];
    if (self) {
        style_ = Style1;
        tabBarGap_ = 0;
        tabBarUpGap_ = 0;
        tabBarDownGap_ = 0;
        if ([images count] != [titles count]) {
            NSLog(@"segmentControl初始化失败，图片与标题不匹配!");
            return nil;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame TitleArray:(NSArray* )titles SelectedImage:(UIImage* )selectedImage UnselectedImage:(UIImage* )unselectedImage
{
    self = [super initWithFrame:frame];
    if (self) {
        style_ = Style2;
        tabBarGap_ = 0;
        tabBarUpGap_ = 0;
        tabBarDownGap_ = 0;
        titles_ = [titles copy];
        selectedImgae_ = selectedImage;
        unselectedImage_ = unselectedImage;
        [self loadButton];
    }
    return self;
}

- (void)toSelectTheItemAtIndex:(int )index
{
    
}

- (void)setBackgroundImage:(UIImage* )image
{
    CALayer* layer = [[CALayer alloc] init];
    [layer setFrame:self.bounds];
    [layer setContents:(id)image.CGImage];
    [self.layer insertSublayer:layer atIndex:0];
}

- (void)setTabBarGap:(float )gap
{
    tabBarGap_ = gap;
    [self reloadTheButtonFrameByGap];
}

- (void)setTabBarUpGap:(float )gap
{
    tabBarUpGap_ = gap;
    [self reloadTheButtonFrameByGap];
}

- (void)setTabBarDownGap:(float )gap
{
    tabBarDownGap_ = gap;
    [self reloadTheButtonFrameByGap];
}

- (void)setUpGap:(float )upGapSender DownGap:(float )downGapSender leftAndRightGap:(float )leftAndRightSender
{
    tabBarGap_ = leftAndRightSender;
    tabBarUpGap_ = upGapSender;
    tabBarDownGap_ = downGapSender;
    [self reloadTheButtonFrameByGap];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark privateAPI
- (void)updateUI
{
    if (style_ == Style1) {
        for (UIButton* object in buttons_) {
            if (object.tag == selectedItemIndex_) {
                //改变选中的标签
            }
            else
            {
                //还原未选中的标签
            }
        }
    }
    else if (style_ == Style2)
    {
        for (UIButton* object in buttons_) {
            [UIView beginAnimations:@"select the Button" context:nil];
            [UIView setAnimationDuration:0.2];
            
            if (object.tag == selectedItemIndex_) {
                [object setBackgroundImage:selectedImgae_ forState:UIControlStateNormal];
                /*CGRect frame = object.frame;
                float width = CGRectGetWidth(frame) * 1.2;
                float height = CGRectGetHeight(frame);
                float x = CGRectGetMidX(frame) - (width - CGRectGetWidth(frame)) / 2;
                float y = CGRectGetMinY(frame);
                
                [object setFrame:CGRectMake(x, y, width, height)];*/
                
                [object setTitleColor:[UIColor colorWithRed:11.0 / 255.0
                                                      green:71.0 / 255.0
                                                       blue:170.0 / 255.0
                                                      alpha:1
                                       ] forState:UIControlStateNormal];
                [object.layer setShadowOffset:CGSizeMake(1, 1)];
                [object.layer setShadowColor:[UIColor blackColor].CGColor];
                [object.layer setShadowOpacity:1];
            }
            else
            {
                [object setBackgroundImage:unselectedImage_ forState:UIControlStateNormal];
                [object.layer setShadowOffset:CGSizeMake(0, 0)];
                [object.layer setShadowColor:nil];
                [object.layer setShadowOpacity:0];
                [object setTitleColor:[UIColor colorWithRed:0
                                                      green:0
                                                       blue:0
                                                      alpha:1
                                       ] forState:UIControlStateNormal];
                /*int itemCount = [titles_ count];
                float width = CGRectGetWidth(self.frame) / (float)itemCount;
                float height = CGRectGetHeight(self.frame);
                [object setFrame:CGRectMake(object.tag * width, 0, width, height)];*/
            }
            [UIView commitAnimations];

        }
    }
}

- (void)loadButton
{
    for (NSString* title in titles_) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        int tag = [titles_ indexOfObject:title];
        button.tag = tag;
        int itemCount = [titles_ count];
        float width = (CGRectGetWidth(self.frame) - (itemCount + 1) * tabBarGap_) / (float)itemCount;
        float height = CGRectGetHeight(self.frame) - tabBarUpGap_ - tabBarDownGap_;
        [button setFrame:CGRectMake(tag * width + (tag + 1) * tabBarGap_, tabBarUpGap_, width, height)];
        button.showsTouchWhenHighlighted = YES;
        if (style_ == Style1) {
            UIImage* image = [images_ objectAtIndex:tag];
            [button setBackgroundImage:image forState:UIControlStateNormal];
        }
        else if (style_ == Style2)
        {
            if (tag == 0) {
                [button setBackgroundImage:selectedImgae_ forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:11.0 / 255.0
                                                      green:71.0 / 255.0
                                                       blue:170.0 / 255.0
                                                      alpha:1
                                       ] forState:UIControlStateNormal];
            }
            else
            {
                [button setBackgroundImage:unselectedImage_ forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:0
                                                      green:0
                                                       blue:0
                                                      alpha:1
                                       ] forState:UIControlStateNormal];
            }
        }
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(clickTheButton:)
         forControlEvents:UIControlEventTouchDown];
        if (buttons_ == nil) {
            buttons_ = [[NSMutableArray alloc] init];
        }
        [buttons_ addObject:button];
        [self addSubview:button];
    }
}

- (void)clickTheButton:(UIButton *)button
{
    int tag = button.tag;
    if (tag != selectedItemIndex_) {
        selectedItemIndex_ = tag;
        [self updateUI];
        [self.delegate selectTheItenAtIndex:tag];
    }
}

- (void)reloadTheButtonFrameByGap
{
    for (UIButton* button in buttons_) {
        int tag = button.tag;
        int itemCount = [titles_ count];
        float width = (CGRectGetWidth(self.frame) - (itemCount + 1) * tabBarGap_) / (float)itemCount;
        float height = CGRectGetHeight(self.frame) - tabBarUpGap_ - tabBarDownGap_;
        [button setFrame:CGRectMake(tag * width + (tag + 1) * tabBarGap_, tabBarUpGap_, width, height)];

    }
}
@end
