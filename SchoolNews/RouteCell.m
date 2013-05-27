//
//  RouteCell.m
//  SchoolNews
//
//  Created by Jerry on 4月25星期四.
//
//

#import "RouteCell.h"
#import <QuartzCore/QuartzCore.h>

@interface RouteCellDelegate

@end

@implementation RouteCell
{
    UILabel* lineLabel_;
    UILabel* routeLabel_;
    UILabel* timeLabel_;
    UILabel* commentLabel_;
    UILabel* detailRouteLabel_;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CALayer* upLayer = [[CALayer alloc] init];
        [upLayer setFrame:CGRectMake(0, 0, 320, 40)];
        UIImage* upImage = [UIImage imageNamed:@"具体线路背景.png"];
        [upLayer setContents:(id)upImage.CGImage];
        [self.layer insertSublayer:upLayer atIndex:0];
        
        
        lineLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [lineLabel_ setTextAlignment:NSTextAlignmentLeft];
        [lineLabel_ setBackgroundColor:[UIColor clearColor]];
        [lineLabel_ setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:lineLabel_];
        
        routeLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 145, 40)];
        [routeLabel_ setTextAlignment:NSTextAlignmentLeft];
        [routeLabel_ setBackgroundColor:[UIColor clearColor]];
        [routeLabel_ setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:routeLabel_];
        
        timeLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(205, 0, 45, 40)];
        [timeLabel_ setTextAlignment:NSTextAlignmentLeft];
        [timeLabel_ setBackgroundColor:[UIColor clearColor]];
        [timeLabel_ setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:timeLabel_];
        
        commentLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 70, 40)];
        [commentLabel_ setTextAlignment:NSTextAlignmentLeft];
        [commentLabel_ setBackgroundColor:[UIColor clearColor]];
        [commentLabel_ setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:commentLabel_];

        detailRouteLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 80)];
        [detailRouteLabel_ setTextAlignment:NSTextAlignmentCenter];
        [detailRouteLabel_ setNumberOfLines:0];
        UIImage* downImage = [UIImage imageNamed:@"展开背景.png"];
        [detailRouteLabel_ setBackgroundColor:[UIColor colorWithPatternImage:downImage]];
        [detailRouteLabel_ setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:detailRouteLabel_];
        
        /*CALayer* downLayer = [[CALayer alloc] init];
        [downLayer setFrame:detailRouteLabel_.bounds];
        UIImage* downImage = [UIImage imageNamed:@"展开背景.png"];
        [downLayer setContents:(id)downImage.CGImage];
        [detailRouteLabel_.layer insertSublayer:downLayer atIndex:0];*/
        
    }
    return self;
}

- (void)setLine:(NSString* )lineSender
          Route:(NSString* )routeSender
           Time:(NSString* )timeSender
        Comment:(NSString* )commentSender
    DetailRoute:(NSString* )detailRouteSender
{
    [lineLabel_ setText:lineSender];
    [routeLabel_ setText:routeSender];
    [timeLabel_ setText:timeSender];
    [commentLabel_ setText:commentSender];
    [detailRouteLabel_ setText:detailRouteSender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShow:(BOOL )show
{
    if (show) {
        [detailRouteLabel_ setHidden:NO];
    }
    else
    {
        [detailRouteLabel_ setHidden:YES];
    }
}

@end
