//
//  RouteCell.h
//  SchoolNews
//
//  Created by Jerry on 4月25星期四.
//
//

#import <UIKit/UIKit.h>

@interface RouteCell : UITableViewCell

- (void)setLine:(NSString* )lineSender
          Route:(NSString* )routeSender
           Time:(NSString* )timeSender
        Comment:(NSString* )commentSender
    DetailRoute:(NSString* )detailRouteSender;

- (void)setShow:(BOOL )show;
@end
