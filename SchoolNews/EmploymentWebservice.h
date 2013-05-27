//
//  EmploymentWebservice.h
//  SchoolNews
//
//  Created by Jerry on 4月10星期三.
//
//

#import "WebService.h"

@protocol EmploymentWebserviceDelegate <NSObject>

- (void)finishGetEmploymentData:(id)sender;

@end

@interface EmploymentWebservice : WebService
@property (nonatomic,assign) id<EmploymentWebserviceDelegate> delegate;
@end
