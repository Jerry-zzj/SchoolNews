//
//  SubFunctionFlowLayout.m
//  CircleTableViewDemo
//
//  Created by Jerry on 4月18星期四.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import "SubFunctionFlowLayout.h"
@implementation SubFunctionFlowLayout

#define ITEM_SIZE           60.0
#define RADIUS              268.25
- (id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //self.minimumLineSpacing = 80;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#define Y(distance)                RADIUS - sqrt(pow(RADIUS, 2) - pow(distance, 2)) + ITEM_SIZE / 2.0
#define RORATE(distance)            asin(distance / RADIUS)
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    //NSLog(@"rect:%@",NSStringFromCGRect(rect));
    //NSLog(@"collectionView_rect:%@",NSStringFromCGRect(self.collectionView.frame));
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        float y = Y(distance);
        float rorate = - RORATE(distance);
        if (!isnan(y)) {
            attributes.center = CGPointMake(attributes.center.x, y);
            attributes.transform3D = CATransform3DMakeRotation(rorate, 0, 0, 1);
        }
        //NSLog(@"Distance:%g",distance);
    }
    //NSLog(@"-------------------------------------------------");
    return array;
}

// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
/*- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity;
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
}*/

@end
