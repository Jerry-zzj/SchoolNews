//
//  TouchEnableView.h
//  SchoolNews
//
//  Created by Jerry on 3月21星期四.
//
//

#import <UIKit/UIKit.h>
@class TouchEnableView;
@protocol TouchEnabelViewDelegate<NSObject>
@optional
- (void)view:(TouchEnableView* )view
touchMoveXDistance:(float)xDistance
   YDistance:(float)yDistance;

- (void)view:(TouchEnableView* )view
touchMoveEndxDsitance:(float)xDistance
   yDistance:(float)yDistance;

- (void)viewtouchDown:(TouchEnableView* )view;


@end
@interface TouchEnableView : UIView
@property (nonatomic,assign)id<TouchEnabelViewDelegate> delegate;
@property (nonatomic,assign)BOOL movable;
@end
