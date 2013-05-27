//
//  EmploymentCompanyHeaderView.m
//  SchoolNews
//
//  Created by Jerry on 4月11星期四.
//
//

#import "EmploymentCompanyHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EmploymentCompanyHeaderView
{
    UIButton* button;
    UILabel* companyNameLabel;
    CALayer* backgroundImageLayer;
    BOOL open;
}
@synthesize delegate;
EmploymentCompanyHeaderView* g_EmploymentCompanyHeaderView;
+ (id)singleton
{
    if (g_EmploymentCompanyHeaderView == nil) {
        g_EmploymentCompanyHeaderView = [[EmploymentCompanyHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    }
    return g_EmploymentCompanyHeaderView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        //UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        //[imageView setImage:[UIImage imageNamed:@"头部展开.png"]];
        backgroundImageLayer = [[CALayer alloc] init];
        [backgroundImageLayer setFrame:self.bounds];
        UIImage* image = [UIImage imageNamed:@"头部折叠.png"];
        [backgroundImageLayer setContents:(id)image.CGImage];
        [self.layer addSublayer:backgroundImageLayer];
        companyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 230, 40)];
        [companyNameLabel setNumberOfLines:2];
        [companyNameLabel setBackgroundColor:[UIColor clearColor]];
        [companyNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:companyNameLabel];
        //[self addSubview:imageView];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:self.bounds];
        [self addSubview:button];
        [button addTarget:self
                   action:@selector(clickTheButton:)
         forControlEvents:UIControlEventTouchUpInside];
        open = NO;
        //[imageView addSubview:button];
        //[imageView addSubview:companyNameLabel];
    }
    return self;
}

- (void)setCompanyName:(NSString* )sender
{
    [companyNameLabel setText:sender];
}

- (void)setOpen:(BOOL)sender
{
    open = sender;
    if (open) {
        UIImage* image = [UIImage imageNamed:@"头部展开.png"];
        [backgroundImageLayer setContents:(id)image.CGImage];
    }
    else
    {
        UIImage* image = [UIImage imageNamed:@"头部折叠.png"];
        [backgroundImageLayer setContents:(id)image.CGImage];
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
#pragma mark private
- (void)clickTheButton:(UIButton* )sender
{
    open = !open;
    if (open) {
        UIImage* image = [UIImage imageNamed:@"头部展开.png"];
        [backgroundImageLayer setContents:(id)image.CGImage];
    }
    else
    {
        UIImage* image = [UIImage imageNamed:@"头部折叠.png"];
        [backgroundImageLayer setContents:(id)image.CGImage];
    }
    [self.delegate clickTheShowButton:sender];
}

@end
