//
//  SubFunctionViewController.m
//  CircleTableViewDemo
//
//  Created by Jerry on 4月18星期四.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import "SubFunctionViewController.h"
#import "SubFunctionCell.h"
#import "SubFunctionFlowLayout.h"
#import "PublicDefines.h"
#import "FunctionViewController.h"
@interface SubFunctionViewController ()

- (void)loadData;

@end

@implementation SubFunctionViewController
{
    NSArray* subFunctions;
    CGPoint touchBeginPint_;
    //NSDictionary* materialDictionary_;
    NSString* selectedSubFunctionTitle_;
}
@synthesize delegate;
@synthesize show;
/*SubFunctionViewController* g_SubFunctionViewController;
+ (SubFunctionViewController *)singleton
{
    if (g_SubFunctionViewController == nil) {
        SubFunctionFlowLayout* layout = [[SubFunctionFlowLayout alloc] init];
        g_SubFunctionViewController = [[SubFunctionViewController alloc] initWithCollectionViewLayout:layout];
    }
    return g_SubFunctionViewController;
}*/

- (id)init
{
    SubFunctionFlowLayout* layout = [[SubFunctionFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        subFunctions = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)traversalAllItems
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[subFunctions count] - 1
                                                                                           inSection:0]
                                                      atScrollPosition:UICollectionViewScrollPositionRight
                                                              animated:YES];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:YES];
    });
}

#define FRAME_SIZE_HEIGHT                           80
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //[self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - FRAME_SIZE_HEIGHT, 320, FRAME_SIZE_HEIGHT)];
    NSLog(@"sub function view frame:%@",NSStringFromCGRect(self.collectionView.frame));
    //[self.collectionView setBackgroundColor:[UIColor redColor]];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:self.collectionView.bounds];
    [backgroundImageView setImage:[UIImage imageNamed:@"二级栏目背景.png"]];
    [self.collectionView setBackgroundView:backgroundImageView];
    //self.view.autoresizingMask = UIViewAutoresizingNone;
    [self.collectionView registerClass:NSClassFromString(@"SubFunctionCell")
            forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)setMainFunctions:(FunctionViewController* )sender
{
    NSString* title = sender.title;
    SubFunctionData* subFunctionData = [SubFunctionData singleton];
    
    NSArray* tempSubfunctions = [subFunctionData getSubFunctionForIdentifier:title];
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout* )self.collectionView.collectionViewLayout;
    //float minimumLineSpacing = [subFunctionData getMinimumLineSpacingForSubFunctions:tempSubfunctions];
    float minimumLineSpacing = [subFunctionData getMinimumLineSpacingForSubFunctions:tempSubfunctions];
    layout.minimumLineSpacing = minimumLineSpacing;
    if ([subFunctions count] > 0) {
        [subFunctions removeAllObjects];
    }
    [subFunctions addObjectsFromArray:tempSubfunctions];
    [self.collectionView reloadData];

}*/

/*- (void)setSubFunctionViewShow:(BOOL )showSender Animated:(BOOL )animationSender
{
    if (animationSender) {
        [UIView beginAnimations:@"ShowSubFunctionView" context:nil];
        [UIView setAnimationDuration:0.2];
        if (!showSender) {
            //隐藏子功能视图
            [self.collectionView setFrame:CGRectMake(0, 465, 320, 30)];
            //self.collectionView.scrollEnabled = NO;
        }
        else
        {
            //显示子功能视图
            [self.collectionView setFrame:CGRectMake(0, 430, 320, 30)];
            self.show = YES;
            self.collectionView.scrollEnabled = YES;
        }
        [UIView commitAnimations];
    }
}*/

#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //collectionView 停止滑动时隐藏TitleLabel
    NSArray* cells = [self.collectionView visibleCells];
    for (SubFunctionCell* cell in cells) {
        [cell showTitle:NO animation:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //collectionView 开始滑动时显示TitleLabel
    NSArray* cells = [self.collectionView visibleCells];
    for (SubFunctionCell* cell in cells) {
        [cell showTitle:YES animation:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //collectionView 停止滑动时隐藏TitleLabel
    NSArray* cells = [self.collectionView visibleCells];
    for (SubFunctionCell* cell in cells) {
        [cell showTitle:NO animation:YES];
    }
}

#pragma mark UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    subFunctions = [self.dataSource titlesForSubFunctionViewController:self];
    return [subFunctions count];
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubFunctionCell* cell = (SubFunctionCell* )[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewIdentifier" forIndexPath:indexPath];
    cell.highlighted = YES;
    cell.delegate = self;
    int item = indexPath.item;
    NSString* subFunctionTitle = [subFunctions objectAtIndex:item];
    if (![subFunctionTitle isEqualToString:@"浙传资讯"]) {
        [cell setTitle:subFunctionTitle];
    }
    if ([subFunctionTitle isEqualToString:selectedSubFunctionTitle_]) {
        //cell 被选中了
        UIImage* image = [self.dataSource subFunctionViewController:self
                                              SelectedImageForTitle:subFunctionTitle];
        [cell setIconImage:image];
        [cell setShadow:YES];
    }
    else
    {
        //cell 未被选中
        UIImage* image = [self.dataSource subFunctionViewController:self
                                            UnselectedImageForTitle:subFunctionTitle];
        [cell setIconImage:image];
        [cell setShadow:NO];
        
    }
    //badge Number
    int badgeNumber = [self.dataSource subFunctionViewController:self
                                   BadgeNumberAtSubFunctionTitle:subFunctionTitle];
    if (badgeNumber == 0) {
        [cell setBadgeNumberShow:NO];
    }
    else
    {
        [cell setBadgeNumberShow:YES];
    }
    return cell;
}

#pragma mark UICollectionView Delegate
/*- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int item = [indexPath item];
    if (item == 0 || item == [subFunctions count] - 1) {
        return;
    }
    else
    {
        NSString* subtitle = [subFunctions objectAtIndex:item];
        selectedSubFunctionTitle_ = subtitle;
        [self.delegate selectTheSubFunction:subtitle];
    }
}*/

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int item = [indexPath item];
    if (item == 0 || item == [subFunctions count] - 1) {
        return NO;
    }
    else
    {
        NSString* subtitle = [subFunctions objectAtIndex:item];
        if ([selectedSubFunctionTitle_ isEqualToString:subtitle]) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

- (void)selectTheTitle:(NSString* )sender
{
    selectedSubFunctionTitle_ = sender;
    [self.delegate selectTheSubFunction:sender];
    [self.collectionView reloadData];
}

#pragma mark Private API
- (void)loadData
{
    
}

@end

