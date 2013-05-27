//
//  TouchEventTableView.m
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "TouchEventTableView.h"
@interface TouchEventTableView(private)

- (void)swipLeft:(UISwipeGestureRecognizer* )sender;
- (void)swipRight:(UISwipeGestureRecognizer* )sender;

@end
@implementation TouchEventTableView
@synthesize moveDelegate;
@synthesize touchDelegate;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        
        UISwipeGestureRecognizer* swipLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipLeft:)];
        [swipLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipLeftGestureRecognizer];
        
        UISwipeGestureRecognizer* swipRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipRight:)];
        [swipRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipRightGestureRecognizer];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if([self.touchDelegate respondsToSelector:@selector(touchDownInTableView)])
    {
        [self.touchDelegate performSelector:@selector(touchDownInTableView)];
    }
}

- (void)swipLeft:(UISwipeGestureRecognizer *)sender
{
    [self.moveDelegate touchMoveToLeft];
}

- (void)swipRight:(UISwipeGestureRecognizer *)sender
{
    [self.moveDelegate touchMoveToRight];
}
@end
