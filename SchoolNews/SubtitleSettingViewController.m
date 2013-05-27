//
//  SubtitleSettingViewController.m
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SubtitleSettingViewController.h"
#import "SubtitleViewController.h"
#import "DataBaseOperating.h"
#import "PublicDefines.h"

#define IPHONE5             SCREEN_HEIGHT == 548
@interface SubtitleSettingViewController ()

- (void)loadTheNavigationBar;
- (void)loadTheSubtitleButton;
- (void)loadTheIPhone5ButtonFrames;
- (void)loadTheIPhone4ButtonFrames;
- (void)finishTheSetting;

- (void)clickTheButton:(UIButton* )sender;
@end

@implementation SubtitleSettingViewController
SubtitleSettingViewController* g_SubtitleSettingViewController;
+ (SubtitleSettingViewController* )singleton
{
    if (g_SubtitleSettingViewController == nil) {
        g_SubtitleSettingViewController = [[SubtitleSettingViewController alloc] init];
    }
    return g_SubtitleSettingViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadTheNavigationBar];
        if (IPHONE5) {
            [self loadTheIPhone5ButtonFrames];
        }
        else
        {
            [self loadTheIPhone4ButtonFrames];
        }
        [self loadTheSubtitleButton];
        allSubtitleArray_ = [[DataBaseOperating singleton] getSubtitleForFunction:@"新闻"];
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"appear");
    
}

//--------------------------------------------------------------------------------------------------------------
#pragma mark private
- (void)loadTheNavigationBar
{
    UINavigationBar* navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"内容制定"];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(finishTheSetting)];
    [navigationItem setLeftBarButtonItem:leftBarButton animated:YES];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
}

- (void)finishTheSetting
{
    NSMutableArray* showSubtitle = [NSMutableArray array];
    for (int index = 0; index < [showSubtitleArray_ count]; index ++) {
        UIButton* button = [showSubtitleArray_ objectAtIndex:index];
        NSString* title = [button currentTitle];
        [showSubtitle addObject:title];
    }
    [SubtitleViewController singleton].subtitlesArray = showSubtitle;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadTheSubtitleButton
{
    showSubtitleArray_ = [NSMutableArray array];
    NSArray* subtitleInView = [SubtitleViewController singleton].subtitlesArray;
    for (int index = 0; index < [subtitleInView count]; index ++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString* frameString = [showButtonFrames_ objectAtIndex:index];
        NSString* firstFrameString = IPHONE5 ? @"{{10, 98}, {67, 40}}" : @"{{10, 89}, {67, 32}}";
        if ([frameString isEqualToString:firstFrameString]) {
            [button setUserInteractionEnabled:NO];
            //[button setImage:[UIImage imageNamed:@"按钮带星星.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"按钮带星星.png"] forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"按钮1.png"] forState:UIControlStateNormal];
        }
        CGRect frame = CGRectFromString(frameString);
        [button setFrame:frame];
        NSString* title = [subtitleInView objectAtIndex:index];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(clickTheButton:)
         forControlEvents:UIControlEventTouchUpInside];
        [showSubtitleArray_ addObject:button];
        [self.view addSubview:button];
    }
    
    unshowSubtitleArray_ = [NSMutableArray array];
    for(int index = 0; index < [allSubtitleArray_ count]; index ++)
    {
        NSString* subtitleName = [allSubtitleArray_ objectAtIndex:index];
        if(![subtitleInView containsObject:subtitleName])
        {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            NSString* frameString = [unshowSubtitleArray_ objectAtIndex:index];
            CGRect frame = CGRectFromString(frameString);
            [button setFrame:frame];
            [button setTitle:subtitleName forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(clickTheButton:)
             forControlEvents:UIControlEventTouchUpInside];
            [unshowSubtitleArray_ addObject:button];
        }
    }
}
- (void)loadTheIPhone5ButtonFrames
{
    NSMutableArray* tempShowButtonFrames = [NSMutableArray array];
    for (int row = 0; row < 4; row ++) {
        for (int rank = 0; rank < 4; rank ++) {
            float x = 77 * rank + 10;
            float y = row * 65 + 98;
            float width = 67;
            float height = 40;
            CGRect frame = CGRectMake(x, y, width, height);
            [tempShowButtonFrames addObject:NSStringFromCGRect(frame)];
        }
    }
    showButtonFrames_ = [NSArray arrayWithArray:tempShowButtonFrames];
    
    NSMutableArray* tempUnshowButtonFrames = [NSMutableArray array];
    for (int row = 0; row < 4; row ++) {
        for (int rank = 0; rank < 4; rank ++) {
            float x = 77 * rank + 10;
            float y = row * 65 + 350;
            float width = 67;
            float height = 40;
            CGRect frame = CGRectMake(x, y, width, height);
            [tempUnshowButtonFrames addObject:NSStringFromCGRect(frame)];
        }
    }
    unshowButtonFrames_ = [NSArray arrayWithArray:tempUnshowButtonFrames];
}

- (void)loadTheIPhone4ButtonFrames
{
    NSMutableArray* tempShowButtonFrames = [NSMutableArray array];
    for (int row = 0; row < 4; row ++) {
        for (int rank = 0; rank < 4; rank ++) {
            float x = 77 * rank + 10;
            float y = row * 51 + 89;
            float width = 67;
            float height = 32;
            CGRect frame = CGRectMake(x, y, width, height);
            [tempShowButtonFrames addObject:NSStringFromCGRect(frame)];
        }
    }
    showButtonFrames_ = [NSArray arrayWithArray:tempShowButtonFrames];
    
    NSMutableArray* tempUnshowButtonFrames = [NSMutableArray array];
    for (int row = 0; row < 4; row ++) {
        for (int rank = 0; rank < 4; rank ++) {
            float x = 77 * rank + 10;
            float y = row * 51 + 296;
            float width = 67;
            float height = 32;
            CGRect frame = CGRectMake(x, y, width, height);
            [tempUnshowButtonFrames addObject:NSStringFromCGRect(frame)];
        }
    }
    unshowButtonFrames_ = [NSArray arrayWithArray:tempUnshowButtonFrames];
}

- (void)clickTheButton:(UIButton* )sender
{
    if ([showSubtitleArray_ containsObject:sender]) {
        int senderIndex = [showSubtitleArray_ indexOfObject:sender];
        for (int index = senderIndex + 1; index < [showSubtitleArray_ count]; index ++) 
        {
            NSString* frameString = [showButtonFrames_ objectAtIndex:index - 1];
            CGRect frame = CGRectFromString(frameString);
            UIButton* buttonToMoveInShow = [showSubtitleArray_ objectAtIndex:index];
            [UIView beginAnimations:@"MoveTheShowButton" context:nil];
            [UIView setAnimationDuration:0.2];
            [buttonToMoveInShow setFrame:frame];
            [UIView commitAnimations];
        }
        int numberOfUnshowButton = [unshowSubtitleArray_ count];
        NSString* frameString = [unshowButtonFrames_ objectAtIndex:numberOfUnshowButton];
        CGRect frame = CGRectFromString(frameString);
        [UIView beginAnimations:@"MoveTheClickButton" context:nil];
        [UIView setAnimationDuration:0.2];
        [sender setFrame:frame];
        [UIView commitAnimations];
        [unshowSubtitleArray_ addObject:sender];
        [showSubtitleArray_ removeObject:sender];
    }
    else if([unshowSubtitleArray_ containsObject:sender])
    {
        int senderIndex = [unshowSubtitleArray_ indexOfObject:sender];
        for (int index = senderIndex + 1; index < [unshowSubtitleArray_ count]; index ++) 
        {
            NSString* frameString = [unshowButtonFrames_ objectAtIndex:index - 1];
            CGRect frame = CGRectFromString(frameString);
            UIButton* buttonToMoveInShow = [unshowSubtitleArray_ objectAtIndex:index];
            [UIView beginAnimations:@"MoveTheUnshowButton" context:nil];
            [UIView setAnimationDuration:0.2];
            [buttonToMoveInShow setFrame:frame];
            [UIView commitAnimations];
        }
        int numberOfUnshowButton = [showSubtitleArray_ count];
        NSString* frameString = [showButtonFrames_ objectAtIndex:numberOfUnshowButton];
        CGRect frame = CGRectFromString(frameString);
        [UIView beginAnimations:@"MoveTheClickButton" context:nil];
        [UIView setAnimationDuration:0.2];
        [sender setFrame:frame];
        [UIView commitAnimations];
        [showSubtitleArray_ addObject:sender];
        [unshowSubtitleArray_ removeObject:sender];
    }
}
@end
