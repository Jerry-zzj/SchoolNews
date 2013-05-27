//
//  ReproduceEmploymentContentWebservice.h
//  SchoolNews
//
//  Created by Jerry on 4月15星期一.
//
//

#import "WebService.h"
@protocol ReproduceEmploymentContentWebserviceDelegate<NSObject>

- (void)getReproduceEmploymentContent:(id)sender;

@end
@interface ReproduceEmploymentContentWebservice : WebService
@property (nonatomic,assign)id<ReproduceEmploymentContentWebserviceDelegate> delegate;
@end
