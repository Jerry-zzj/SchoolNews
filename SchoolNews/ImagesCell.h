//
//  ImagesCell.h
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesCell : UITableViewCell
@property (nonatomic,strong)IBOutlet UILabel* titleLabel;
@property (nonatomic,strong)IBOutlet UILabel* numberOfImageLabel;
@property (nonatomic,strong)IBOutlet UIImageView* firstImageView;
@property (nonatomic,strong)IBOutlet UIImageView* secondImageView;
@property (nonatomic,strong)IBOutlet UIImageView* thirdImageView;
@end
