//
//  RegisterWebService.h
//  SchoolNews
//
//  Created by Jerry on 3月8星期五.
//
//

#import "WebService.h"
@protocol RegisterWebServiceDelegate<NSObject>

- (void)getRegisterState:(id)sender;

@end
@interface RegisterWebService : WebService
@property (nonatomic,assign)id<RegisterWebServiceDelegate> delegate;
@end
