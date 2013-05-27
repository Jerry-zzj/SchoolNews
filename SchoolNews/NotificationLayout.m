//
//  NotificationLayout.m
//  SchoolNews
//
//  Created by Jerry on 3月28星期四.
//
//

#import "NotificationLayout.h"
#import "PublicDefines.h"

@implementation NotificationLayout
- (id)init
{
    self = [super init];
    if (self) {
        //self.itemSize = CGSizeMake(320,337);
        self.itemSize = CGSizeMake(320,SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT - 30);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumLineSpacing = 0;
    }
    return self;
}
// return YES to cause the collection view to requery the layout for geometry information
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/*#define scale(distance)             1.2 - 1.2 / 320 * ABS(distance)
// return an array layout attributes instances for all the views in the given rect
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        CATransform3D transform = CATransform3DScale(CATransform3DIdentity, scale(distance), scale(distance),1);
        attributes.transform3D = transform;
        int zindex = scale(distance) > 1 ? 1:0;
        attributes.zIndex = zindex;
        //NSLog(@"Distance:%g",distance);
    }
    //NSLog(@"-------------------------------------------------");
    return array;
}*/

/*- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 return nil;
 }*/

/*- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 
 }*/

// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity;
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
