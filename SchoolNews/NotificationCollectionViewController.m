//
//  NotificationCollectionViewController.m
//  SchoolNews
//
//  Created by Jerry on 3月28星期四.
//
//

#import "NotificationCollectionViewController.h"
#import "NotificationCollectionCell.h"
#import "PublicDefines.h"
@interface NotificationCollectionViewController ()


@end

@implementation NotificationCollectionViewController
{
    NSArray* types;
    NSMutableArray* cells;
}
@synthesize delegate;
- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"NotificationSubtitle" ofType:@"plist"];
        types = [NSArray arrayWithContentsOfFile:filePath];
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 30, 320, SCREEN_HEIGHT - 30)];
    for (NSString* type in types) {
        [self.collectionView registerClass:[NotificationCollectionCell class] forCellWithReuseIdentifier:type];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollToSpecialItem:(int )sender
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:sender inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float scrollContentOffSet = scrollView.contentOffset.x;
    int theItem = scrollContentOffSet / 320;
    [self.delegate notificationCollectionViewScrollToItem:theItem];
    
}
#pragma mark UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [types count];
}

- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int item = indexPath.item;
    NSString* type = [types objectAtIndex:item];
    NotificationCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:type forIndexPath:indexPath];
    //[cell clearTheData];
    [cell setItem:item];
    return cell;
}

#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(NotificationCollectionCell* )cell clearTheData];
}


@end
