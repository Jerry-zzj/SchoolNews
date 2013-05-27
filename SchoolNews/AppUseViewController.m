//
//  AppUseViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月23星期二.
//
//

#import "AppUseViewController.h"

@interface AppUseViewController ()

@end

@implementation AppUseViewController
{
    UIScrollView* backgroundScrollView_;
    UIPageControl* pageControl_;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        backgroundScrollView_ = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backgroundScrollView_.pagingEnabled = YES;
        backgroundScrollView_.delegate = self;
        
        pageControl_ = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, 320, 30)];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffSet = scrollView.contentOffset.x;
    [pageControl_ setCurrentPage:(int)(contentOffSet / 320)];
}

- (void)setUserImages:(NSArray* )images
{
    [backgroundScrollView_ setContentSize:CGSizeMake([images count] * 320, [UIScreen mainScreen].bounds.size.height)];
    [pageControl_ setNumberOfPages:[images count]];
    for (UIImage* image in images) {
        int index = [images indexOfObject:image];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(index * 320, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        [backgroundScrollView_ addSubview:imageView];
    }
    
}

@end
