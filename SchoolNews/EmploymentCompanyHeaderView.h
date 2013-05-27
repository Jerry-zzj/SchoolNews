//
//  EmploymentCompanyHeaderView.h
//  SchoolNews
//
//  Created by Jerry on 4月11星期四.
//
//

#import <UIKit/UIKit.h>
@protocol EmploymentCompanyHeaderViewDelegate<NSObject>

- (void)clickTheShowButton:(UIButton* )sender;

@end
@interface EmploymentCompanyHeaderView : UIView
@property (nonatomic,retain)id<EmploymentCompanyHeaderViewDelegate> delegate;
+ (id)singleton;
- (void)setCompanyName:(NSString* )sender;
- (void)setOpen:(BOOL)sender;
@end
