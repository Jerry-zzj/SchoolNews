//
//  FirstRowImageCell.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "FirstRowImageCell.h"
#import "NewsObject.h"
#import "UIImageView+WebCache.h"

#define FIRST_ROW_IMAGE_HEIGHT                      170
@interface FirstRowImageCell(private)

- (void)clickTheButtonWithNews:(UIButton* )sender;
- (void)onTimer;

@end
@implementation FirstRowImageCell
//@synthesize imageView;
@synthesize selectedDelegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        backgroundScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, FIRST_ROW_IMAGE_HEIGHT)];
        backgroundScrollView_.delegate = self;
        [backgroundScrollView_ setContentSize:CGSizeMake(320, FIRST_ROW_IMAGE_HEIGHT)];
        [backgroundScrollView_ setPagingEnabled:YES];
        [backgroundScrollView_ setShowsHorizontalScrollIndicator:NO];
        [self addSubview:backgroundScrollView_];
        titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, FIRST_ROW_IMAGE_HEIGHT - 30, 270, 30)];
        [titleLabel_ setTextColor:[UIColor whiteColor]];
        [titleLabel_ setHighlighted:YES];
        [titleLabel_ setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        [titleLabel_ setFont:[UIFont systemFontOfSize:13]];
        pageControl_ = [[UIPageControl alloc] initWithFrame:CGRectMake(270, FIRST_ROW_IMAGE_HEIGHT - 30, 50, 30)];
        [pageControl_ setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        [self addSubview:pageControl_];
        [self addSubview:titleLabel_];
        [NSTimer scheduledTimerWithTimeInterval:5
                                         target:self
                                       selector:@selector(onTimer)
                                       userInfo:nil
                                        repeats:YES];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNewses:(NSArray* )sender
{
    int numberOfNews = [sender count];
    newses_ = sender;
    //根据新闻条数设定scrollView长度
    [backgroundScrollView_ setContentSize:CGSizeMake(320 * numberOfNews, FIRST_ROW_IMAGE_HEIGHT)];
    for (int index = numberOfNews - 1; index >= 0; index --) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(320 * index, 0, 320, FIRST_ROW_IMAGE_HEIGHT)];
        NewsObject* newsInformation = [newses_ objectAtIndex:index];
        UIImage* image = newsInformation.synopsisImage;
        if (image == nil) {
            NSURL* netImageNameURL = [NSURL URLWithString:newsInformation.synopsisImagePath];
            UIImageView* buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * index, 0, button.frame.size.width, button.frame.size.height)];
            [buttonImageView setImageWithURL:netImageNameURL
                            placeholderImage:nil
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                       newsInformation.synopsisImage = image;
                                   }];
            [buttonImageView setUserInteractionEnabled:NO];
            [backgroundScrollView_ addSubview:buttonImageView];
        }
        else
        {
            [button setImage:image forState:UIControlStateNormal];
        }
        button.tag = index;
        [button addTarget:self
                   action:@selector(clickTheButtonWithNews:)
         forControlEvents:UIControlEventTouchUpInside];
        //标题和page
        /*UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.width - 30, self.bounds.size.width, self.bounds.size.height)];
        titleLabel.text = newsInformation.title;
        [button addSubview:tit];*/
        [pageControl_ setNumberOfPages:numberOfNews];
        [backgroundScrollView_ addSubview:button];
    }
    [pageControl_ setCurrentPage:0];
    [titleLabel_ setText:[(NewsObject* )[sender objectAtIndex:0] title]];
}

#pragma mark scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float contentOffSetX = scrollView.contentOffset.x;
    int indexOfImage = contentOffSetX / 320.0;
    NewsObject* news = [newses_ objectAtIndex:indexOfImage];
    [titleLabel_ setText:news.title];
    [pageControl_ setCurrentPage:indexOfImage];
}

#pragma mark private
- (void)clickTheButtonWithNews:(UIButton *)sender
{
    int selectedNewsIndex = sender.tag;
    NewsObject* selectedNews = [newses_ objectAtIndex:selectedNewsIndex];
    [self.selectedDelegate selectTheNews:selectedNews];
}

- (void)onTimer
{
    CGPoint contentOffSet = backgroundScrollView_.contentOffset;
    CGSize contentSize = backgroundScrollView_.contentSize;
    float width = backgroundScrollView_.bounds.size.width;
    if (contentOffSet.x + width < contentSize.width) {
        [UIView beginAnimations:@"image Animation" context:nil];
        [UIView setAnimationDuration:0.2];
        [backgroundScrollView_ setContentOffset:CGPointMake(contentOffSet.x + width, contentOffSet.y)];
        [UIView commitAnimations];
        float contentOffSetX = backgroundScrollView_.contentOffset.x;
        int indexOfImage = contentOffSetX / 320.0;
        NewsObject* news = [newses_ objectAtIndex:indexOfImage];
        [titleLabel_ setText:news.title];
        [pageControl_ setCurrentPage:indexOfImage];
    }
}
@end
