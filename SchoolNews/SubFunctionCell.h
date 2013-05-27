//
//  SubFunctionCell.h
//  CircleTableViewDemo
//
//  Created by Jerry on 4月18星期四.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SubFunctionCellDelegate<NSObject>

- (void)selectTheTitle:(NSString* )sender;

@end
@interface SubFunctionCell : UICollectionViewCell
@property (nonatomic,assign)id<SubFunctionCellDelegate> delegate;
- (void)setIconImage:(UIImage* )sender;
- (void)setTitle:(NSString* )sender;
- (void)setShadow:(BOOL )sender;
- (void)showTitle:(BOOL )yesOrNot animation:(BOOL )animation;
- (void)setBadgeNumberShow:(BOOL)show;
@end
