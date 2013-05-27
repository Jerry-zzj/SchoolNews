//
//  NotificationCell.m
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize dateLabel;
@synthesize departmentLabel;
@synthesize notificationTitleLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addObserver:self
               forKeyPath:@"textLabel.text"
                  options:0
                  context:nil];
        self.notificationTitleLabel = [[UILabel alloc] init];
        [self.notificationTitleLabel setFrame:CGRectMake(10, 0, 300, 40)];
        //[self.notificationTitleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        [self.notificationTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.notificationTitleLabel setShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        [self.notificationTitleLabel setShadowOffset:CGSizeMake(100, 100)];
        [self.notificationTitleLabel setAdjustsFontSizeToFitWidth:NO];
        [self.notificationTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.notificationTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.notificationTitleLabel setNumberOfLines:2];
        [self addSubview:self.notificationTitleLabel];
        UIColor* color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        [self setBackgroundColor:color];
        UIImageView* backgroundImageVIew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotificationCellBackground.png"]];
        [self setBackgroundView:backgroundImageVIew];
        //时间
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2.0, 55, self.bounds.size.width / 2.0 - 20, 20)];
        [self.dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.dateLabel setTextAlignment:NSTextAlignmentRight];
        [self.dateLabel setFont:[UIFont systemFontOfSize:12]];
        [self.dateLabel setTextColor:[UIColor grayColor]];
        [self addSubview:self.dateLabel];
        //发布部门
        self.departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 200, 20)];
        [self.departmentLabel setBackgroundColor:[UIColor clearColor]];
        [self.departmentLabel setFont:[UIFont systemFontOfSize:12]];
        [self.departmentLabel setTextColor:[UIColor grayColor]];
        [self.departmentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.departmentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:self.departmentLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    /*if ([keyPath isEqualToString:@"textLabel.text"]) {
        NSString* text = self.textLabel.text;
        [self.textLabel setNumberOfLines:10];
        CGSize tempSize = CGSizeMake(self.frame.size.width, 1000);
        UIFont* font = [UIFont systemFontOfSize:17];
        CGSize size = [text sizeWithFont:font
                       constrainedToSize:tempSize
                           lineBreakMode:NSLineBreakByCharWrapping];
        [self setFrame:CGRectMake(0, 0, 320, size.height + 30)];
        [self.dateLabel setFrame:CGRectMake(0, size.height + 20, self.bounds.size.width- 10, 20)];
        [self.departmentLabel setFrame:CGRectMake(self.bounds.size.width / 2.0, size.height + 20, self.bounds.size.width / 2.0, 20)];
    }*/
}
@end
