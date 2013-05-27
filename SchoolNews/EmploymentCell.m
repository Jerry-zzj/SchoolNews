//
//  EmploymentCell.m
//  SchoolNews
//
//  Created by Jerry on 4月11星期四.
//
//

#import "EmploymentCell.h"

@implementation EmploymentCell

@synthesize jobTitleLabel;
@synthesize dateLabel;
@synthesize departmentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.jobTitleLabel = [[UILabel alloc] init];
        [self.jobTitleLabel setFrame:CGRectMake(10, 0, 300, 40)];
        //[self.notificationTitleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        [self.jobTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.jobTitleLabel setShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        [self.jobTitleLabel setShadowOffset:CGSizeMake(100, 100)];
        [self.jobTitleLabel setAdjustsFontSizeToFitWidth:NO];
        [self.jobTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.jobTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.jobTitleLabel setNumberOfLines:2];
        [self addSubview:self.jobTitleLabel];
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

@end
