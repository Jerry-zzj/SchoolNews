//
//  ImagesCell.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "ImagesCell.h"

@implementation ImagesCell
@synthesize titleLabel;
@synthesize numberOfImageLabel;
@synthesize firstImageView;
@synthesize secondImageView;
@synthesize thirdImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
