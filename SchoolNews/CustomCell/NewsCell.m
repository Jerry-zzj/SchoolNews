//
//  NewsCell.m
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation NewsCell
@synthesize titleLabel;
@synthesize bodyLabel;
@synthesize newsImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CATransition* transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transtion setType:kCATransitionFade];
        [self.newsImageView.layer addAnimation:transtion forKey:@"transitionKey"];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
