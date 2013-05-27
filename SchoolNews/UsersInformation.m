//
//  UsersInformation.m
//  SchoolNews
//
//  Created by shuangchi on 12月1星期六.
//
//

#import "UsersInformation.h"
#import "WebServiceFactory.h"
#import "VerificationWebService.h"
#import "PublicDefines.h"
#import "DataBase.h"
#import "PublicDefines.h"
//---------------------------------------------------------------------------------------------------------------
@interface UsersInformation(private)

- (void)loadTheUserInformation;
//- (NSString* )informationFilePath;
- (void)verificateTheAccount;
- (void)verificationCallBack:(NSNotification* )sender;

@end
//--------------------------------------------------------------------------------------------------

@implementation UsersInformation
@synthesize alreadyLogin;
@synthesize accountName;
@synthesize userType;
@synthesize password;
@synthesize version;
@synthesize autoLogin;
UsersInformation* g_UsersInformation;
+ (UsersInformation* )singleton
{
    if (g_UsersInformation == nil) {
        g_UsersInformation = [[UsersInformation alloc] init];
    }
    return g_UsersInformation;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.alreadyLogin = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(verificationCallBack:)
                                                     name:LOGIN_FINISHED
                                                   object:nil];
        [self addObserver:self
               forKeyPath:@"userType"
                  options:0
                  context:nil];
        [self addObserver:self
               forKeyPath:@"deviceToken"
                  options:0
                  context:nil];
        self.userType = Visitor;
        self.autoLogin = YES;
        [self loadTheUserInformation];
    }
    return self;
}

- (void)saveTheUserInformation
{
    NSNumber* autoLoginObject = [NSNumber numberWithBool:self.autoLogin];
    if (autoLoginObject != nil) {
        [[NSUserDefaults standardUserDefaults] setValue:autoLoginObject
                                                 forKey:AUTO_LOGIN_KEY];
    }
    NSString* accountNumberObject = self.accountNumber;
    if (accountNumberObject != nil) {
        [[NSUserDefaults standardUserDefaults] setValue:accountNumberObject
                                                 forKey:ACCOUNT_NUMBER_KEY];
    }
    NSString* passwordObject = self.password;
    if (passwordObject != nil) {
        [[NSUserDefaults standardUserDefaults] setValue:passwordObject
                                                 forKey:PASSWORD_KEY];
    }
}

- (void)verificateTheAccount
{
    WebService* verficationWebService = [[WebServiceFactory singleton] produceTheWebService:VERFICATION_WEBSERVICE];
    NSString* urlString = [NSString stringWithFormat:@"%@/axis2/services/VerificationService/verifyAccountNameInVersion11?accountName=%@&password=%@&deviceToken=%@&deviceType=%@",WEBSERVICE_DOMAIN,self.accountNumber,self.password,@"NO",@"IOS"];
    NSLog(@"%@",urlString);
    [verficationWebService setURLWithString:urlString];
    [verficationWebService getWebServiceData];
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"deviceToken"];
    [self removeObserver:self
              forKeyPath:@"userType"];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LOGIN_FINISHED
                                                  object:nil];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userType"]) {
        _userRightFunctionSet = [[DataBase singleton] getUserRightForType:self.userType];
    }
}
//---------------------------------------------------------------------------------------------------
#pragma mark private
- (void)loadTheUserInformation
{
    NSUserDefaults* usersDefaults = [NSUserDefaults standardUserDefaults];
    if ([usersDefaults objectForKey:AUTO_LOGIN_KEY] == nil) {
        self.autoLogin = YES;
    }
    self.autoLogin = [[usersDefaults objectForKey:AUTO_LOGIN_KEY] boolValue];
    self.accountNumber = [usersDefaults objectForKey:ACCOUNT_NUMBER_KEY];
    self.password = [usersDefaults objectForKey:PASSWORD_KEY];
    if (self.autoLogin) {
        [self verificateTheAccount];
    }
}

/*- (NSString* )informationFilePath
{
    NSArray* paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    NSString* file = [documentPath stringByAppendingPathComponent:@"UserInofrmation.plist"];
    return file;
}*/

- (void)verificationCallBack:(NSNotification* )sender
{
    NSDictionary* result = [sender object];
    if ([result count] == 0) {
        NSLog(@"faild");
        self.alreadyLogin = NO;
    }
    else
    {
        NSString* name = [result objectForKey:@"姓名"];
        self.alreadyLogin = YES;
        self.accountName = name;
        
        NSNumber* userTypeInDictionary = [result objectForKey:@"用户类型"];
        self.userType = [userTypeInDictionary intValue];
        
        NSNumber* keyRegisterState = [result objectForKey:@"秘钥注册情况"];
        self.keyRegistered = [keyRegisterState boolValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_IN
                                                            object:nil
                                                          userInfo:nil];
    }
}
@end
