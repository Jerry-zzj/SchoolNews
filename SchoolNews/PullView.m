//
//  PullView.m
//  SchoolNews
//
//  Created by Jerry on 3月19星期二.
//
//

#import "PullView.h"
#import <QuartzCore/QuartzCore.h>
#import "PublicDefines.h"

@implementation PullView
{
    BOOL show;
    float distance;
    CGPoint touchBeginPoint;
}
@synthesize delegate;
PullView* g_PullView;
+ (PullView* )singleton
{
    if (g_PullView == nil) {
        g_PullView = [[PullView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    }
    return g_PullView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage* image = [UIImage imageNamed:@"灰色纹理.png"];
        UIImageView* backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320-PULL_VIEW_RESPONSE_WIDTH, SCREEN_HEIGHT)];
        [backgroundView setImage:image];
        [self insertSubview:backgroundView atIndex:0];
    }
    return self;
}


- (BOOL)moreFunctionShow
{
    return show;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    touchBeginPoint = point;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPoint center = self.center;
    float moveDistance = point.x - touchBeginPoint.x;
    [self setCenter:CGPointMake(center.x + moveDistance, center.y)];
    [self.delegate pullViewMoveDistance:point.x - touchBeginPoint.x];
    distance += moveDistance;
    //touchBeginPoint = point;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (distance > 130) {
        [self pullViewToShow:YES];
    }
    else
    {
        [self pullViewToHidden:YES];
    }
    distance = 0;
}

- (void)pullViewToHidden:(BOOL)animation
{
    if (animation) {
        [UIView beginAnimations:@"move to Hidden" context:nil];
        [UIView setAnimationDuration:0.2];
        [self setFrame:CGRectMake(PULL_VIEW_RESPONSE_WIDTH - 320, 20, self.frame.size.width, self.frame.size.height)];
        [UIView commitAnimations];
    }
    else
    {
        [self setFrame:CGRectMake(PULL_VIEW_RESPONSE_WIDTH - 320, 20, self.frame.size.width, self.frame.size.height)];
    }
    show = NO;
    [self.delegate pullViewHidden];
}

- (void)pullViewToShow:(BOOL)animation
{
    if (animation) {
        [UIView beginAnimations:@"move to Show" context:nil];
        [UIView setAnimationDuration:0.2];
        [self setFrame:CGRectMake(-73, 20, self.frame.size.width, self.frame.size.height)];
        [UIView commitAnimations];
    }
    else
    {
        [self setFrame:CGRectMake(-73, 20, self.frame.size.width, self.frame.size.height)];
    }
    show = YES;
    [self.delegate pullViewShowTotal];
}

- (void)movePullViewDistance:(float)distanceSender animated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:@"Move View" context:nil];
        [UIView setAnimationDuration:0.2];
        [self setCenter:CGPointMake(self.center.x + distanceSender, self.center.y)];
        [UIView commitAnimations];
    }
    else
    {
        [self setCenter:CGPointMake(self.center.x + distanceSender, self.center.y)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
