//
//  ManyRowTextCell.m
//  SchoolNews
//
//  Created by shuangchi on 12月20星期四.
//
//

#import "ManyRowTextCell.h"

@implementation ManyRowTextCell
@synthesize firstLabel;
@synthesize secondLabel;
@synthesize thirdLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self addSubview:thirdLabel];
        [self addSubview:secondLabel];
        [self addSubview:firstLabel];
        [self addObserver:self
               forKeyPath:@"firstLabel.text"
                  options:0
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"secondLabel.text"
                  options:0
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"thirdLabel.text"
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
    if ([keyPath isEqualToString:@"firstLabel.text"]) {
        /*NSString* firstLabelText = self.firstLabel.text;
        UIFont* font = [UIFont systemFontOfSize:17];
        CGSize tempSize = CGSizeMake(320, 1000);
        CGSize size = [firstLabelText sizeWithFont:font
                                 constrainedToSize:tempSize
                                     lineBreakMode:NSLineBreakByCharWrapping];*/
    
    }
    else if ([keyPath isEqualToString:@"secondLabel.text"])
    {
        
    }
    else if ([keyPath isEqualToString:@"thirdLabel.text"])
    {
        
    }
}
@end
