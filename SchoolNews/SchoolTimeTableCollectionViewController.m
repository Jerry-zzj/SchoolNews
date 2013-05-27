//
//  SchoolTimeTableCollectionViewController.m
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "SchoolTimeTableCollectionViewController.h"
#import "SchoolTimeCollectionCell.h"

@interface SchoolTimeTableCollectionViewController ()

- (void)loadModel;

- (int )itemIndexForWeek:(int )week AndWeekday:(int )weekday;
- (int )getWeekFromItem:(int )item;
- (int )getWeekdayFromItem:(int )item;

@end

@implementation SchoolTimeTableCollectionViewController
{
    SchoolTimeTableModel* schoolTimeTableModel_;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self loadModel];
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self loadModel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:NSClassFromString(@"SchoolTimeCollectionCell") forCellWithReuseIdentifier:@"SchoolTimeCollectionCell"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWeek:(int )week Weekday:(int )weekday Animated:(BOOL )animated
{
    int item = [self itemIndexForWeek:week AndWeekday:weekday];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:animated];
}

#pragma mark UIScrollView delegate

/*- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([[self.collectionView visibleCells] count] == 1) {
        NSIndexPath* indexpath = [[self.collectionView indexPathsForVisibleItems] objectAtIndex:0];
        [self.delegate collectionViewControl:self scrollToIndex:[indexpath item]];
    }
}*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int item = scrollView.contentOffset.x / 320;
    [self.delegate collectionViewControl:self scrollToIndex:item];
}

#pragma mark UICollectionView DataSource
- (int )numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (int )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1000;
}

- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolTimeCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SchoolTimeCollectionCell"
                                                                               forIndexPath:indexPath];
    int item = [indexPath item];
    int week = [self getWeekFromItem:item];
    int weekday = [self getWeekdayFromItem:item];
    NSDictionary* classes = [schoolTimeTableModel_ getClassesInWeek:week WeekDay:weekday];
    if (classes == nil) {
        [cell setLoding:YES];
    }
    else
    {
        [cell setLoding:NO];
        [cell setClasses:classes];
    }
    return cell;
}

#pragma mark Model Delegate
- (void)getTheClasses:(NSDictionary *)dictionary AtWeek:(int)week Weekday:(int)weekday
{
    int item = [self itemIndexForWeek:week AndWeekday:weekday];
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    
    NSArray* visiableIndex = [self.collectionView indexPathsForVisibleItems];
    if ([visiableIndex containsObject:indexPath]) {
        int index = [visiableIndex indexOfObject:indexPath];
        SchoolTimeCollectionCell* cell = [[self.collectionView visibleCells] objectAtIndex:index];
        [cell setLoding:NO];
        [cell setClasses:dictionary];
    }
}

#pragma mark private API
- (void)loadModel
{
    schoolTimeTableModel_ = [SchoolTimeTableModel singleton];
    schoolTimeTableModel_.delegate = self;
}


- (int )itemIndexForWeek:(int )week AndWeekday:(int )weekday
{
    int itemIndex = (week - 1) * 7 + weekday - 1;
    return itemIndex;
}

- (int )getWeekFromItem:(int )item
{
    int week = item / 7 + 1;
    return week;
}

- (int )getWeekdayFromItem:(int )item
{
    int weekday = item % 7 + 1;
    return weekday;
}
@end
