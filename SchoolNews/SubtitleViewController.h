//
//  SubtitleViewController.h
//  SchoolNews
//
//  Created by shuangchi on 11月30星期五.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubtitleViewControllerDelegate <NSObject>

- (void)selectTheSubtitle:(UIButton* )sender;

@end

@interface SubtitleViewController : UIViewController
{
    
    UIScrollView *backgroundScrollView_;
    UIImageView* subtitleBackGroundView_;
    NSMutableArray* buttonsArray_;
    NSString* selectedSubtitle_;
}
@property (nonatomic,retain) id<SubtitleViewControllerDelegate> delegate;
@property (nonatomic,retain) NSArray* subtitlesArray;
@property (nonatomic,retain) NSString* selectedSubtitle;
+ (SubtitleViewController* )singleton;
//- (IBAction)gotoSubtitleSettingView:(id)sender;
- (void)moveSelectedSubtitleToTitle:(NSString* )string;
@end
