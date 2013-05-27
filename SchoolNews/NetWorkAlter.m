//
//  NetWorkAlter.m
//  SchoolNews
//
//  Created by Jerry on 4月28星期日.
//
//

#import "NetWorkAlter.h"

@implementation NetWorkAlter
{
    UIAlertView* alertView_;
    BOOL alertShowed_;
}
NetWorkAlter* g_NetWorkAlter;
+ (NetWorkAlter* )singleton
{
    if (g_NetWorkAlter == nil) {
        g_NetWorkAlter = [[NetWorkAlter alloc] init];
    }
    return g_NetWorkAlter;
}

- (id)init
{
    self = [super init];
    if (self) {
        alertView_ = [[UIAlertView alloc] initWithTitle:@"网络连接失败"
                                                message:@"请检查网络连接"
                                               delegate:self
                                      cancelButtonTitle:@"知道了"
                                      otherButtonTitles:nil];
        alertShowed_ = NO;
    }
    return self;
}

- (void)showTheAlter
{
    if (!alertShowed_) {
        [alertView_ show];
        alertShowed_ = YES;
    }
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertShowed_ = NO;
}
@end
