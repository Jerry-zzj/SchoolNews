//
//  RemoteNotificationCenter.m
//  SchoolNews
//
//  Created by Jerry on 5月14星期二.
//
//

#import "RemoteNotificationCenter.h"
#import "PublicDefines.h"
#import "RemotePushNotificationObject.h"
#import "PublicDefines.h"
#import "RegisterWebService.h"
#import "UsersInformation.h"
#import "ClearPushNotificationWebservice.h"

@interface RemoteNotificationCenter(privateAPI)

- (void)clearAllRemoteNotificationLocal;

@end

@implementation RemoteNotificationCenter
{
    BOOL registerState_;
    RegisterWebService* registerWebservice_;
    RemotePushNotificationWebService* remoteNotificationDataWebservice_;
    ClearPushNotificationWebservice* clearPushNotificationWebservice_;
}

+ (RemoteNotificationCenter* )singleton
{
    static RemoteNotificationCenter* g_RemoteNotificationCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (g_RemoteNotificationCenter == nil) {
            g_RemoteNotificationCenter = [[RemoteNotificationCenter alloc] init];
        }
    });
    return g_RemoteNotificationCenter;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self addObserver:self
               forKeyPath:@"unhandleRemoteNotificationDictionary_"
                  options:0
                  context:nil];
        registerState_ = NO;
        //注册用户登出通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearAllRemoteNotificationLocal)
                                                     name:USER_LOGIN_OUT
                                                   object:nil];
        //注册用户登录通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadAllUnHandleRemoteNotifcation)
                                                     name:USER_LOGIN_IN
                                                   object:nil];
    }
    return self;
}

- (void)loadAllUnHandleRemoteNotifcation
{
    if (![UsersInformation singleton].alreadyLogin) {
        return;
    }
    if (remoteNotificationDataWebservice_ == nil) {
        remoteNotificationDataWebservice_ = [[RemotePushNotificationWebService alloc] init];
        remoteNotificationDataWebservice_.delegate = self;
    }
    NSString* accountNumber = [UsersInformation singleton].accountNumber;
    if (accountNumber == nil) {
        return;
    }
    NSString* url = GET_ALL_UNHANDLE_REMOTE_NOTIFICATION_URL(accountNumber);
    [remoteNotificationDataWebservice_ setURLWithString:url];
    [remoteNotificationDataWebservice_ getWebServiceData];
}

- (int )getAllUnHandleRemoteNotifcationCount
{
    return [unhandleRemoteNotificationDictionary_ count];
}

- (NSDictionary* )getAllUnHandleRemoteNotifcation
{
    return unhandleRemoteNotificationDictionary_;
}

- (NSArray* )getRemoteNotificationForFunctionCode:(NSString* )functionCode
{
    NSArray* result;
    if ([functionCode length] == 4) {
        NSString* mainFunctionCode = [functionCode substringToIndex:2];
        NSString* subFunctionCode = [functionCode substringFromIndex:2];
        NSDictionary* notificationsForMainFunction = [unhandleRemoteNotificationDictionary_ objectForKey:mainFunctionCode];
        result = [notificationsForMainFunction objectForKey:subFunctionCode];
    }
    else if ([functionCode length] == 2)
    {
        result = [unhandleRemoteNotificationDictionary_ objectForKey:functionCode];
    }
    return result;
}

- (void)handInTheDeviceTokenToTheServerWithAccount:(NSString* )deviceToken;
{
    if (registerWebservice_ == nil) {
        registerWebservice_ = [[RegisterWebService alloc] init];
        registerWebservice_.delegate = self;
    }
    NSString* account = [UsersInformation singleton].accountNumber;
    int userType = [UsersInformation singleton].userType;
    NSString* url = REGISTER_DEVICETOKEN_WITH_ACCOUNT_URL(account, userType, deviceToken);
    [registerWebservice_ setURLWithString:url];
    [registerWebservice_ getWebServiceData];
    [UsersInformation singleton].deviceToken = deviceToken;
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"unhandleRemoteNotificationDictionary_"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:USER_LOGIN_IN
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:USER_LOGIN_OUT
                                                  object:nil];
}

//收到新的推送通知
- (void)receiveNewRemotePushNotification:(RemotePushNotificationObject* )sender
{
    NSString* contentType = sender.type;
    NSString* mainFunctionCode = [contentType substringToIndex:2];
    NSString* subFunctionCode;
    if ([contentType length] == 4) {
        subFunctionCode = [contentType substringWithRange:NSMakeRange(2, 2)];
    }
    if (subFunctionCode == nil) {
        NSMutableArray* notifications = [unhandleRemoteNotificationDictionary_ objectForKey:mainFunctionCode];
        if (notifications == nil) {
            notifications = [NSMutableArray array];
            [unhandleRemoteNotificationDictionary_ setObject:notifications forKey:mainFunctionCode];
        }
        [notifications addObject:sender];
    }
    else
    {
        NSMutableDictionary* dictionary = [unhandleRemoteNotificationDictionary_ objectForKey:mainFunctionCode];
        if (dictionary == nil) {
            dictionary = [NSMutableDictionary dictionary];
            [unhandleRemoteNotificationDictionary_ setObject:dictionary forKey:mainFunctionCode];
        }
        NSMutableArray* notifications = [dictionary objectForKey:subFunctionCode];
        if (notifications == nil) {
            notifications = [NSMutableArray array];
            [dictionary setObject:notifications forKey:subFunctionCode];
        }
        [notifications addObject:sender];
    }
    [self setValue:unhandleRemoteNotificationDictionary_ forKeyPath:@"unhandleRemoteNotificationDictionary_"];
}

- (void)clearTheRemotePushNotificationsForFunctionCode:(NSString* )functionCode
{
    if (clearPushNotificationWebservice_ == nil) {
        clearPushNotificationWebservice_ = [[ClearPushNotificationWebservice alloc] init];
        clearPushNotificationWebservice_.delegate = self;
    }
    NSMutableString* ids = [NSMutableString string];
    NSArray* toRemoveNotifications;
    if([functionCode length] == 2)
    {
        toRemoveNotifications = [unhandleRemoteNotificationDictionary_ objectForKey:functionCode];
        [unhandleRemoteNotificationDictionary_ removeObjectForKey:functionCode];
    }
    else if ([functionCode length] == 4)
    {
        NSString* mainFunctionCode = [functionCode substringToIndex:2];
        NSString* subFunctionCode = [functionCode substringFromIndex:2];
        NSMutableDictionary* dictionary = [unhandleRemoteNotificationDictionary_ objectForKey:mainFunctionCode];
        toRemoveNotifications = [dictionary objectForKey:subFunctionCode];
        [dictionary removeObjectForKey:subFunctionCode];
        
    }
    for (RemotePushNotificationObject* object in toRemoveNotifications) {
        NSString* objectID = object.ID;
        [ids appendFormat:@"%@,",objectID];
    }
    if ([ids length] > 0) {
        [ids substringToIndex:[ids length] - 1];
    }
    NSString* accountNumber = [UsersInformation singleton].accountNumber;
    NSString* clearURL = CLEAR_UNHANDLE_REMOTE_NOTIFICATION_URL(ids, accountNumber);
    NSLog(@"clear:%@",clearURL);
    [clearPushNotificationWebservice_ setURLWithString:clearURL];
    [clearPushNotificationWebservice_ getWebServiceData];
    //array = nil;
    //[unhandleRemoteNotificationDictionary_ removeObjectForKey:functionCode];
    [self setValue:unhandleRemoteNotificationDictionary_
        forKeyPath:@"unhandleRemoteNotificationDictionary_"];

}

#pragma mark Webservice delegate
- (void)getRegisterState:(id)sender
{
    if ([sender isEqualToString:@"SUCCESS"]) {
        registerState_ = YES;
    }
    else
    {
        registerState_ = NO;
    }
    [self loadAllUnHandleRemoteNotifcation];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"unhandleRemoteNotificationDictionary_"]) {
        //发送通知：有远程消息推送到设备
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_REMOTE_PUSH_NOTIFICATION
                                                            object:unhandleRemoteNotificationDictionary_];
    }
}

#pragma mark RemotePushNotificationWebService Delegate
- (void)getAllRemotePushNotificationAboutDevice:(id)sender
{
    NSArray* remoteNotifications = (NSArray* )sender;
    NSMutableDictionary* allUnhandleNotifications = [NSMutableDictionary dictionary];
    for (RemotePushNotificationObject* object in remoteNotifications) {
        NSString* mainFunctionCode = [object.type substringToIndex:2];
        NSString* subFunctionCode = [object.type length] == 4 ? [object.type substringWithRange:NSMakeRange(2, 2)] : nil;
        if ([[allUnhandleNotifications allKeys] containsObject:mainFunctionCode]) {
            if (subFunctionCode == nil) {
                NSMutableArray* array = [allUnhandleNotifications objectForKey:mainFunctionCode];
                [array addObject:object];
            }
            else
            {
                NSMutableDictionary* subDictionary = [allUnhandleNotifications objectForKey:mainFunctionCode];
                if (subDictionary == nil)
                {
                    subDictionary = [[NSMutableDictionary alloc] init];
                    [allUnhandleNotifications setObject:subDictionary forKey:mainFunctionCode];
                }
                if ([[subDictionary allKeys] containsObject:subFunctionCode]) {
                    NSMutableArray* array = [subDictionary objectForKey:subFunctionCode];
                    [array addObject:object];
                }
                else
                {
                    NSMutableArray* array = [NSMutableArray array];
                    [array addObject:object];
                    [subDictionary setObject:array forKey:subFunctionCode];
                }
            }
        }
        else
        {
            if (subFunctionCode == nil) {
                NSMutableArray* array = [NSMutableArray array];
                [array addObject:object];
                [allUnhandleNotifications setObject:array forKey:mainFunctionCode];
            }
            else
            {
                NSMutableDictionary* subDictionary = [allUnhandleNotifications objectForKey:mainFunctionCode];
                if (subDictionary == nil)
                {
                    subDictionary = [[NSMutableDictionary alloc] init];
                    [allUnhandleNotifications setObject:subDictionary forKey:mainFunctionCode];
                }
                if ([[subDictionary allKeys] containsObject:subFunctionCode]) {
                    NSMutableArray* array = [subDictionary objectForKey:subFunctionCode];
                    [array addObject:object];
                }
                else
                {
                    NSMutableArray* array = [NSMutableArray array];
                    [array addObject:object];
                    [subDictionary setObject:array forKey:subFunctionCode];
                }
            }
        }
    }
    [self setValue:allUnhandleNotifications forKeyPath:@"unhandleRemoteNotificationDictionary_"];
}

#pragma mark ClearUnhandleNotificationWebservice Delegate
- (void)clearPushNotification:(BOOL )sender
{
    if (sender) {
        NSLog(@"处理推送消息成功");
    }
    else
    {
        NSLog(@"处理推送消息失败");
    }
}

#pragma mark private API
- (void)clearAllRemoteNotificationLocal
{
    NSMutableDictionary* clearRemoteNotification = [NSMutableDictionary dictionary];
    [self setValue:clearRemoteNotification
        forKeyPath:@"unhandleRemoteNotificationDictionary_"];
}
@end
