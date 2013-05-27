//
//  TouchEnableView.m
//  SchoolNews
//
//  Created by Jerry on 3月21星期四.
//
//

#import "TouchEnableView.h"

@implementation TouchEnableView
{
    CGPoint touchBegin;
    float allXDistance;
    float allYDistance;
}
@synthesize delegate;
@synthesize movable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    if ([self.delegate respondsToSelector:@selector(viewtouchDown:)]) {
        [self.delegate viewtouchDown:self];
    }
    if (movable) {
        UITouch* touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        touchBegin = point;
        allXDistance = 0;
        allYDistance = 0;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (movable) {
        UITouch* touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        float xDistance = point.x - touchBegin.x;
        float yDistance = point.y - touchBegin.y;
        //allDistance += distance;
        allXDistance += xDistance;
        allYDistance += yDistance;
        //[self.delegate view:self touchMoveDistance:distance];
        [self.delegate view:self touchMoveXDistance:xDistance YDistance:yDistance];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (movable) {
        //[self.delegate view:self touchMoveEnd:allDistance];
        [self.delegate view:self touchMoveEndxDsitance:allXDistance yDistance:allYDistance];
    }
}
@end
