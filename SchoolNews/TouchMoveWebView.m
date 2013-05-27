//
//  TouchMoveWebView.m
//  SchoolNews
//
//  Created by Jerry on 4月12星期五.
//
//

#import "TouchMoveWebView.h"
@interface TouchMoveWebView(privateAPI)

- (void)swipLeft:(UISwipeGestureRecognizer *)sender;
- (void)swipRight:(UISwipeGestureRecognizer *)sender;

@end
@implementation TouchMoveWebView
@synthesize swipDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UISwipeGestureRecognizer* swipLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipLeft:)];
        [swipLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipLeftGestureRecognizer];
        
        UISwipeGestureRecognizer* swipRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipRight:)];
        [swipRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipRightGestureRecognizer];
        
        self.scalesPageToFit = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark private
- (void)swipLeft:(UISwipeGestureRecognizer *)sender
{
    [self.swipDelegate swipToLeft];
}

- (void)swipRight:(UISwipeGestureRecognizer *)sender
{
    [self.swipDelegate swipToRight];
}


@end
