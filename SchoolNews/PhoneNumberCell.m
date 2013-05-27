//
//  PhoneNumberCell.m
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import "PhoneNumberCell.h"
#import "NSString-RemoveSuperfluousString.h"
@interface PhoneNumberCell (private)

- (void)dialerButtonClick;
- (void)messageButtonClick;
- (void)hideTheButton;
- (void)showTheButton;
@end

@implementation PhoneNumberCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.phoneNumberOrNot = NO;
        messageButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [messageButton_ setFrame:CGRectMake(170, 5, 60, 34)];
        [messageButton_ addTarget:self
                           action:@selector(messageButtonClick)
                 forControlEvents:UIControlEventTouchUpInside];
        [messageButton_ setTitle:@"发短信" forState:UIControlStateNormal];
        
        dialerButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [dialerButton_ setFrame:CGRectMake(240, 5, 60, 34)];
        [dialerButton_ addTarget:self
                          action:@selector(dialerButtonClick)
                forControlEvents:UIControlEventTouchUpInside];
        [dialerButton_ setTitle:@"打电话" forState:UIControlStateNormal];
        [self addSubview:messageButton_];
        [self addSubview:dialerButton_];
        
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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"textLabel.text"];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"textLabel.text"])
    {
        if (self.phoneNumberOrNot) {
            [self showTheButton];
        }
        else
        {
            [self hideTheButton];
        }
    }
}

#pragma mark delegate
- (void)dialerButtonClick
{
    NSString* phoneNumber = self.textLabel.text;
    [self.delegate callThePhoneNumber:phoneNumber];
}

- (void)messageButtonClick
{
    NSString* phoneNumber = self.textLabel.text;
    [self.delegate messageThePhoneNumber:phoneNumber];
}

- (void)hideTheButton
{
    dialerButton_.hidden = YES;
    messageButton_.hidden = YES;
}

- (void)showTheButton
{
    dialerButton_.hidden = NO;
    messageButton_.hidden = NO;
}
@end
