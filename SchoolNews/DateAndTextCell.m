//
//  DateAndTextCell.m
//  SchoolNews
//
//  Created by shuangchi on 12月19星期三.
//
//

#import "DateAndTextCell.h"

@implementation DateAndTextCell
@synthesize dateLabel;
@synthesize textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel* tempDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [tempDateLabel setBackgroundColor:[UIColor clearColor]];
        
        UILabel* tempTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 40)];
        [tempTextLabel setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:tempDateLabel];
        [self addSubview:tempTextLabel];
        self.dateLabel = tempDateLabel;
        self.textLabel = tempTextLabel;
        
        [self addObserver:self
               forKeyPath:@"textLabel.text"
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

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:keyPath])
    {
        UIFont* font = [UIFont systemFontOfSize:17];
        NSString* content = self.textLabel.text;
        CGSize tempSize = CGSizeMake(320, 1000);
        CGSize size= [content sizeWithFont:font
                         constrainedToSize:tempSize
                             lineBreakMode:NSLineBreakByCharWrapping];
        float x = self.textLabel.frame.origin.x;
        float y = self.textLabel.frame.origin.y;
        float height = size.height;
        if (height < 44) {
            height = 44;
        }
        [self.textLabel setFrame:CGRectMake(x, y, 320, height)];
    }
}

@end
