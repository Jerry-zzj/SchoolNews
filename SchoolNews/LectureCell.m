//
//  LectureCell.m
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import "LectureCell.h"
#import "AboutLabel.h"

@implementation LectureCell
@synthesize titleLabel;
//@synthesize introductionLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView* backgroundImageVIew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotificationCellBackground.png"]];
        [self setBackgroundView:backgroundImageVIew];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
        [self.titleLabel setNumberOfLines:3];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.titleLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2.0, 55, self.bounds.size.width / 2.0 - 20, 20)];
        [self.dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.dateLabel setTextAlignment:NSTextAlignmentRight];
        [self.dateLabel setFont:[UIFont systemFontOfSize:12]];
        [self.dateLabel setTextColor:[UIColor grayColor]];
        [self addSubview:self.dateLabel];
        
        self.underTaker = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 200, 20)];
        [self.underTaker setBackgroundColor:[UIColor clearColor]];
        [self.underTaker setBackgroundColor:[UIColor clearColor]];
        [self.underTaker setFont:[UIFont systemFontOfSize:12]];
        [self.underTaker setTextColor:[UIColor grayColor]];
        [self.underTaker setTextAlignment:NSTextAlignmentLeft];
        [self.underTaker setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:self.underTaker];
        
        /*self.introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 100)];
        [self.introductionLabel setNumberOfLines:100];
        [self.introductionLabel setTextColor:[UIColor grayColor]];
        [self.introductionLabel setFont:[UIFont systemFontOfSize:14]];
        [self.introductionLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.introductionLabel];
        [self addObserver:self
               forKeyPath:@"titleLabel.text"
                  options:0
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"introductionLabel.text"
                  options:0
                  context:nil];*/
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
    /*if ([keyPath isEqualToString:@"titleLabel.text"]) {
        NSString* text = self.titleLabel.text;
        float height = [AboutLabel getHeightWithFontSize:17 Width:280 Text:text];
        [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x,
                                             self.titleLabel.frame.origin.y,
                                             280, height)];
    }
    else if([keyPath isEqualToString:@"introductionLabel.text"])
    {
        NSString* text = self.introductionLabel.text;
        float height = [AboutLabel getHeightWithFontSize:14 Width:280 Text:text];
        [self.introductionLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.size.height, 280, height)];
    }*/
}
@end
