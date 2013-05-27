//
//  AllMeetCell.m
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import "MeetCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation MeetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addObserver:self
               forKeyPath:@"textLabel.text"
                  options:0
                  context:nil];
        CALayer* layer = [CALayer layer];
        [layer setFrame:CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width - 20, 1)];
        [layer setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2].CGColor];
        [self.layer addSublayer:layer];
        [self.textLabel setFont:[UIFont systemFontOfSize:16]];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self.textLabel setAdjustsFontSizeToFitWidth:NO];
        [self.textLabel setHighlighted:YES];
        [self.textLabel setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5]];
        
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
              forKeyPath:@"textLabel.text"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"textLabel.text"]) {
        [self.textLabel setNumberOfLines:10];
    }
}
@end
