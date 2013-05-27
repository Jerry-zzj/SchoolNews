//
//  SubFunctionCell.m
//  CircleTableViewDemo
//
//  Created by Jerry on 4月18星期四.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import "SubFunctionCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomBadge.h"
@interface SubFunctionCell(Private)

- (void)clickTheButton;

@end

@implementation SubFunctionCell
{
    //CALayer* iconLayer;
    UIButton* iconButton_;
    UILabel* label;
    NSString* title_;
    CustomBadge* badgeNumberView_;
    //CALayer* backgroundLayer_;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /*iconLayer = [[CALayer alloc] init];
        [iconLayer setFrame:CGRectMake(10, 12, 20, 20)];
        [self.layer addSublayer:iconLayer];*/
        NSLog(@"%@",NSStringFromCGRect(frame));
        iconButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton_ setFrame:CGRectMake(20, 30, 20, 20)];
        [self.contentView addSubview:iconButton_];
        [iconButton_ setShowsTouchWhenHighlighted:YES];
        //[iconButton_ setHighlighted:YES];
        [iconButton_ addTarget:self
                        action:@selector(clickTheButton)
              forControlEvents:UIControlEventTouchDown];
        
        badgeNumberView_ = [CustomBadge customBadgeWithString:nil
                                              withStringColor:[UIColor whiteColor]
                                               withInsetColor:[UIColor redColor]
                                               withBadgeFrame:YES
                                          withBadgeFrameColor:[UIColor whiteColor]
                                                    withScale:1.0
                                                  withShining:YES];
        [badgeNumberView_ setFrame:CGRectMake(35,
                                              25,
                                              badgeNumberView_.frame.size.width / 2.0,
                                              badgeNumberView_.frame.size.height / 2.0)];
        [self.contentView addSubview:badgeNumberView_];
        /*backgroundLayer_ = [[CALayer alloc] init];
        [backgroundLayer_ setFrame:CGRectMake(10, 12, 20, 20)];
        [backgroundLayer_ setOpacity:0.5];
        [self.layer addSublayer:backgroundLayer_];*/
        //[iconButton_.layer setShadowOffset:CGSizeMake(0, 0)];
        //[iconButton_];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:label];
        //[label setHidden:YES];
    }
    return self;
}

- (void)setIconImage:(UIImage* )sender
{
    //iconLayer.contents = (id)sender.CGImage;
    [iconButton_ setBackgroundImage:sender forState:UIControlStateNormal];
    
}

- (void)setTitle:(NSString* )sender
{
    [label setText:sender];
    title_ = sender;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setShadow:(BOOL )sender
{
    if (sender) {
        //[backgroundLayer_ setBackgroundColor:[UIColor whiteColor].CGColor];
        [iconButton_.layer setShadowColor:[UIColor whiteColor].CGColor];
        [iconButton_.layer setShadowOffset:CGSizeMake(0, 0)];
        [iconButton_.layer setShadowRadius:3];
        [iconButton_.layer setShadowOpacity:1];
    }
    else
    {
        //[backgroundLayer_ setBackgroundColor:[UIColor blackColor].CGColor];
        [iconButton_.layer setShadowColor:[UIColor blackColor].CGColor];
        [iconButton_.layer setShadowOffset:CGSizeMake(1, 1)];
        [iconButton_.layer setShadowRadius:3];
        [iconButton_.layer setShadowOpacity:1];
    }
}

- (void)setBadgeNumberShow:(BOOL)show
{
    [badgeNumberView_ setHidden:!show];
}

- (void)showTitle:(BOOL )yesOrNot animation:(BOOL )animation
{
    if (animation) {
        [UIView beginAnimations:@"titleLabel" context:nil];
        [UIView setAnimationDuration:0.5];
        if (yesOrNot) {
            [label setAlpha:1];
        }
        else
        {
            [label setAlpha:0];
        }
        [UIView commitAnimations];
    }
    else
    {
        if (yesOrNot) {
            [label setAlpha:1];
        }
        else
        {
            [label setAlpha:0];
        }
    }
}

#pragma mark privateAPI
- (void)clickTheButton
{
    [(NSObject* )self.delegate performSelector:@selector(selectTheTitle:) withObject:title_ afterDelay:0.3];
    //[self.delegate selectTheTitle:title_];
}


@end
