//
//  SubtitleViewController.m
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SubtitleViewController.h"
#import "SubtitleSettingViewController.h"
#import "DataBaseOperating.h"
#define WIDTH_OF_SUBTITLE                           64
#define UP_DOWN_GAP                                 0
@interface SubtitleViewController (private)

- (void)loadTheBackGroundScrollView;
- (void)loadTheSubtitleBackgroundView;
- (void)updateTheSubtitle;
- (void)selectTheTitleButton:(id)sender;
- (void)updateTheBackgroundScrollviewContentSize;

@end

@implementation SubtitleViewController
@synthesize delegate;
@synthesize subtitlesArray;
@synthesize selectedSubtitle;
SubtitleViewController* g_SubtitleViewController;
+ (SubtitleViewController* )singleton
{
    if (g_SubtitleViewController == nil) {
        g_SubtitleViewController = [[SubtitleViewController alloc] init];
    }
    return g_SubtitleViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SubtitleViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addObserver:self
               forKeyPath:@"subtitlesArray"
                  options:0 
                  context:nil];
        buttonsArray_ = [NSMutableArray array];
        //self.subtitlesArray = [[DataBaseOperating singleton]getSubtitleForFunction:@"浙传新闻"];
        //self.selectedSubtitle = [self.subtitlesArray objectAtIndex:0];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTheBackGroundScrollView];
    [self loadTheSubtitleBackgroundView];
    if ([self.subtitlesArray count] > 0) {
        self.selectedSubtitle = [self.subtitlesArray objectAtIndex:0];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    backgroundScrollView_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)moveSelectedSubtitleToTitle:(NSString* )string
{
    self.selectedSubtitle = string;
    int index = [self.subtitlesArray indexOfObject:string];
    int numberOfSubtitle = [self.subtitlesArray count];
    float contentWidth = backgroundScrollView_.contentSize.width;
    float width = contentWidth / numberOfSubtitle;
    [UIView beginAnimations:@"move the selectedSubtitle" context:nil];
    [UIView setAnimationDuration:0.5];
    [subtitleBackGroundView_ setFrame:CGRectMake(index * width, UP_DOWN_GAP, width, self.view.frame.size.height - 1)];
    while  ((index + 1) * width > (backgroundScrollView_.contentOffset.x + backgroundScrollView_.frame.size.width))
    {
        float oldContentOffSetX = backgroundScrollView_.contentOffset.x;
        float distance = (index + 1) * width - (backgroundScrollView_.contentOffset.x + backgroundScrollView_.frame.size.width);
        backgroundScrollView_.contentOffset = CGPointMake(oldContentOffSetX + distance, 0);
        NSLog(@"%g",backgroundScrollView_.contentOffset.x);
    }
    
    while (index * width < (backgroundScrollView_.contentOffset.x))
    {
        backgroundScrollView_.contentOffset = CGPointMake(index * width, 0);
        NSLog(@"%g",backgroundScrollView_.contentOffset.x);

    }
    [UIView commitAnimations];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"subtitlesArray"]) {
        [self updateTheSubtitle];
    }
}

//--------------------------------------------------------------------------------------------------------------
#pragma mark private method
- (void)loadTheBackGroundScrollView
{
    backgroundScrollView_  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    backgroundScrollView_.showsVerticalScrollIndicator = NO;
    backgroundScrollView_.showsHorizontalScrollIndicator = NO;
    backgroundScrollView_.scrollEnabled = YES;
    //backgroundScrollView_.bounces = NO;
    [backgroundScrollView_ setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:backgroundScrollView_];
}

- (void)loadTheSubtitleBackgroundView
{
    subtitleBackGroundView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, UP_DOWN_GAP, WIDTH_OF_SUBTITLE, self.view.frame.size.height - 1)];
    [subtitleBackGroundView_ setImage:[UIImage imageNamed:@"SubtitleSelectedImage.png"]];
    [backgroundScrollView_ insertSubview:subtitleBackGroundView_ atIndex:0];
    //[self addSubview:subtitleBackGroundView_];
}

- (void)updateTheSubtitle
{
    for (id object in [backgroundScrollView_ subviews]) {
        if ([object isKindOfClass:[UIButton class]]) {
            [object removeFromSuperview];
        }
    }
    [buttonsArray_ removeAllObjects];
    for (int index = 0; index < [self.subtitlesArray count]; index ++ )
    {
        CGRect subtitleButtonRect = CGRectMake(index * WIDTH_OF_SUBTITLE, 0, WIDTH_OF_SUBTITLE, self.view.frame.size.height - 1);
        UIButton* subtitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString* name = [self.subtitlesArray objectAtIndex:index];
        subtitleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [subtitleButton setTitle:name forState:UIControlStateNormal];
        [subtitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[subtitleButton setBackgroundColor:[UIColor clearColor]];
        //[subtitleButton setImage:[UIImage imageNamed:@"SubtitleSelectedImage.png"] forState:UIControlStateSelected];
        //[subtitleButton setBackgroundImage:[UIImage imageNamed:@"SubtitleSelectedImage.png"]
                                  //forState:UIControlStateSelected];
        [subtitleButton setFrame:subtitleButtonRect];
        [subtitleButton addTarget:self action:@selector(selectTheTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundScrollView_ addSubview:subtitleButton];
        [buttonsArray_ addObject:subtitleButton];
    }
    [self updateTheBackgroundScrollviewContentSize];
}

- (void)selectTheTitleButton:(id)sender
{
    NSString* subtitle = [sender currentTitle];
    [self moveSelectedSubtitleToTitle:subtitle];
    [delegate selectTheSubtitle:sender];
    /*for (UIButton* object in buttonsArray_) {
        if ([object isEqual:sender]) {
            [object setBackgroundImage:[UIImage imageNamed:@"SubtitleSelectedImage.png"]
                              forState:UIControlStateNormal];
        }
        else
        {
            [object setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }*/
}

- (void)updateTheBackgroundScrollviewContentSize
{
    int numberOfSubTitle = [self.subtitlesArray count];
    [backgroundScrollView_ setContentSize:CGSizeMake(WIDTH_OF_SUBTITLE * numberOfSubTitle, self.view.frame.size.height)];
    float x = subtitleBackGroundView_.frame.origin.x;
    float y = subtitleBackGroundView_.frame.origin.y;
    float width = WIDTH_OF_SUBTITLE;
    float height = self.view.frame.size.height - 1;
    [subtitleBackGroundView_ setFrame:CGRectMake(x, y, width, height)];
    NSLog(@"x:%g  y:%g",backgroundScrollView_.frame.origin.x,backgroundScrollView_.frame.origin.y);
}
@end
