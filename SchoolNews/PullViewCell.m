//
//  PullViewCell.m
//  SchoolNews
//
//  Created by Jerry on 3月22星期五.
//
//

#import "PullViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomBadge.h"
@implementation PullViewCell
{
    UILabel* nameLabel_;
    UIImageView* functionImageView_;
    CustomBadge* badgeNumberView_;
}
@synthesize image;
@synthesize functionName;
@synthesize badgeNumber;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 270, 52)];
        [nameLabel_ setFont:[UIFont systemFontOfSize:14]];
        [nameLabel_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:nameLabel_];
        functionImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(11, 6, 40, 40)];
        [self addSubview:functionImageView_];
        [self addObserver:self
               forKeyPath:@"image"
                  options:0
                  context:nil];
        CALayer* layer = [[CALayer alloc] init];
        [layer setFrame:CGRectMake(0, 51, 320 - 73 - 50, 1)];
        NSLog(@"%@",NSStringFromCGRect(self.bounds));
        [layer setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2].CGColor];
        [self.layer addSublayer:layer];
        
        badgeNumberView_ = [CustomBadge customBadgeWithString:@"1"
                                              withStringColor:[UIColor whiteColor]
                                               withInsetColor:[UIColor redColor]
                                               withBadgeFrame:YES
                                          withBadgeFrameColor:[UIColor whiteColor]
                                                    withScale:1.0
                                                  withShining:YES];
        [badgeNumberView_ setFrame:CGRectMake(0, 0, badgeNumberView_.frame.size.width, badgeNumberView_.frame.size.height)];
        [self addSubview:badgeNumberView_];
        [badgeNumberView_ setHidden:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFunctionName:(NSString *)sender
{
    functionName = sender;
    [nameLabel_ setText:sender];
}



- (void)setBadgeNumber:(int)sender
{
    badgeNumber = sender;
    if (badgeNumber == 0) {
        [badgeNumberView_ setHidden:YES];
    }
    else
    {
        [badgeNumberView_ setHidden:NO];
        NSString* text = [NSString stringWithFormat:@"%i",badgeNumber];
        [badgeNumberView_ setBadgeText:text];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"image"];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"])
    {
        [functionImageView_ setImage:image];
    }
}
@end
