//
//  IntroductionCell.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "IntroductionCell.h"
#define CONTENT_LABEL_WIDTH                         220
#define NAME_LABEL_WIDTH                            65

@implementation IntroductionCell
@synthesize nameLabel;
@synthesize contentLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, NAME_LABEL_WIDTH, 44)];
        self.nameLabel.numberOfLines = 10;
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + NAME_LABEL_WIDTH, 0, CONTENT_LABEL_WIDTH, 44)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.numberOfLines = 100;
        UIFont* font = [UIFont systemFontOfSize:17];
        [self.contentLabel setFont:font];
        [self addSubview:self.nameLabel];
        [self addSubview:self.contentLabel];
        
        [self addObserver:self
               forKeyPath:@"contentLabel.text"
                  options:0
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"nameLabel.text"
                  options:0
                  context:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"contentLabel.text"
                 context:nil];
    [self removeObserver:self
              forKeyPath:@"nameLabel.text"
                 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentLabel.text"]) {
        UIFont* font = [UIFont systemFontOfSize:17];
        NSString* content = self.contentLabel.text;
        float contentWidth = CONTENT_LABEL_WIDTH;
        CGSize contentSize = CGSizeMake(contentWidth, 1000);
        CGSize contentLabelSize= [content sizeWithFont:font constrainedToSize:contentSize lineBreakMode:NSLineBreakByCharWrapping];
        float x = self.contentLabel.frame.origin.x;
        float y = self.contentLabel.frame.origin.y;
        float height = contentLabelSize.height;
        if (height < 44) {
            height = 44;
        }
        [self.contentLabel setFrame:CGRectMake(x, y, CONTENT_LABEL_WIDTH, height)];
    }
    
    if ([keyPath isEqualToString:@"nameLabel.text"]) {
        UIFont* font = [UIFont systemFontOfSize:17];
        NSString* content = self.nameLabel.text;
        float nameWidth = NAME_LABEL_WIDTH;
        CGSize tempSize = CGSizeMake(nameWidth, 1000);
        CGSize size= [content sizeWithFont:font
                         constrainedToSize:tempSize
                             lineBreakMode:NSLineBreakByCharWrapping];
        float x = self.nameLabel.frame.origin.x;
        float y = self.nameLabel.frame.origin.y;
        float height = size.height;
        if (height < 44) {
            height = 44;
        }
        [self.nameLabel setFrame:CGRectMake(x, y, NAME_LABEL_WIDTH, height)];
    }
}

@end
