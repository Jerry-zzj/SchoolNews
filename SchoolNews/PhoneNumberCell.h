//
//  PhoneNumberCell.h
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import <UIKit/UIKit.h>
@protocol PhoneNUmberCellDelegate

- (void)callThePhoneNumber:(NSString* )sender;
- (void)messageThePhoneNumber:(NSString* )sender;

@end
@interface PhoneNumberCell : UITableViewCell
{
    UIButton* dialerButton_;
    UIButton* messageButton_;
}
@property (nonatomic,assign)BOOL phoneNumberOrNot;
@property (nonatomic,assign)id<PhoneNUmberCellDelegate> delegate;
@end
