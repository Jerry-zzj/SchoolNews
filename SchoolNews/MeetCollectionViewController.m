//
//  MeetCollectionViewController.m
//  SchoolNews
//
//  Created by Jerry on 3月25星期一.
//
//

#import "MeetCollectionViewController.h"
#import "MeetCollectionViewCell.h"
#import "PublicDefines.h"
@interface MeetCollectionViewController (privateAPI)

- (int )getWeekWithItem:(int )item;
- (int )getWeekdayWithItem:(int )item;

@end

@implementation MeetCollectionViewController
{
}
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //state = Normal;
    }
    return self;
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
    [self.collectionView registerClass:[MeetCollectionViewCell class] forCellWithReuseIdentifier:@"Identifier"];
    [self.collectionView setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:self.collectionView.bounds];
    [backgroundImageView setImage:[UIImage imageNamed:@"会议背景.png"]];
    [self.collectionView setBackgroundView:backgroundImageView];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    //[self.collectionView setPagingEnabled:YES];
	// Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollToSpecialItem:(int )sender
{
    NSIndexPath* toIndexpath = [NSIndexPath indexPathForItem:sender
                                                   inSection:0];
    [self.collectionView scrollToItemAtIndexPath:toIndexpath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
}

#pragma mark UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 120;
}

- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int item = indexPath.item;
    MeetCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Identifier" forIndexPath:indexPath];
    int week = [self getWeekWithItem:item];
    int weekday = [self getWeekdayWithItem:item];
    [cell setWeek:week AndWeekday:weekday];
    //调整周次
    NSArray* visiableCells = [collectionView visibleCells];
    BOOL change = NO;
    for (MeetCollectionViewCell* object in visiableCells) {
        if (object.savedWeek == week) {
            change = YES;
        }
    }
    if (change) {
        [self.delegate showTheWeek:week];
    }
    return cell;
}

#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView selectItemAtIndexPath:indexPath
                                 animated:YES
                           scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    MeetCollectionViewCell* cell = (MeetCollectionViewCell* )[collectionView cellForItemAtIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeScale(1.5, 1.5);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeetCollectionViewCell* meetCell = (MeetCollectionViewCell* )cell;
    [meetCell clearData];
}

#pragma mark private
- (int )getWeekWithItem:(int )item
{
    int week = item / 7 + 1;
    return week;
}

- (int )getWeekdayWithItem:(int )item
{
    int weekday = item % 7 + 1;
    return weekday;
}
@end
