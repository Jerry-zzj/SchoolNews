//
//  UsersInformation.h
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import <Foundation/Foundation.h>
typedef enum{
    Student,
    Teacher,
    Visitor
}UserType;
@interface UsersInformation : NSObject

#define AUTO_LOGIN_KEY                                      @"AutoLogin"
#define ACCOUNT_NUMBER_KEY                                  @"AccountNumber"
#define PASSWORD_KEY                                        @"Password"
#define DEVICE_TOKEN_KEY                                    @"DeviceToken"
#define VERSION_KEY                                         @"Version"
@property (nonatomic, assign)BOOL alreadyLogin;
@property (nonatomic, strong)NSString* accountName;
@property (nonatomic, strong)NSString* accountNumber;
@property (nonatomic, strong)NSString* password;
@property (nonatomic, assign)UserType userType;
@property (nonatomic,readonly,retain)  NSSet* userRightFunctionSet;
@property (nonatomic, retain)NSString* deviceToken;
@property (nonatomic, retain)NSString* version;
@property (nonatomic, assign)BOOL autoLogin;
@property (nonatomic, assign)BOOL keyRegistered;
+ (UsersInformation* )singleton;
- (void)saveTheUserInformation;
- (void)verificateTheAccount;
@end
