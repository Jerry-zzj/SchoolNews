//
//  FunctionPosition.m
//  SchoolNews
//
//  Created by Jerry on 3月18星期一.
//
//

#import "FunctionPosition.h"
#import "FunctionModuleFactory.h"
#import "SchoolNewsTabBarController.h"
#import "MoreFunctionPullViewController.h"
#define IN_TAB_BAR_KEY                              @"InTabBar"
#define IN_PULL_VIEW_KEY                            @"InPullView"
#define NOT_SHOW_KEY                                @"NotShow"

@interface FunctionPosition(privateAPI)

- (void)initialTheFunctionPosition;


@end

@implementation FunctionPosition
@synthesize allFunctionViewControllers;
@synthesize inTabbarViewControllers;
@synthesize inPullViewControllers;
@synthesize notShowViewControllers;
FunctionPosition* g_FunctionPosition;
+ (FunctionPosition* )singleton
{
    if (g_FunctionPosition == nil) {
        g_FunctionPosition = [[FunctionPosition alloc] init];
    }
    return g_FunctionPosition;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialTheFunctionPosition];
        
    }
    return self;
}

#pragma mark private API
- (void)initialTheFunctionPosition
{
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath = [documentPath stringByAppendingPathComponent:@"FunctionsPlist.plist"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"FunctionsPlist" ofType:@"plist"];
    }
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSArray* inTabBarFunctionsName = [dictionary objectForKey:IN_TAB_BAR_KEY];
    NSMutableArray* inTabBarFunctions = [NSMutableArray array];
    for (NSString* key in inTabBarFunctionsName) {
        UIViewController* viewController = [[FunctionModuleFactory singleton] produceTheFunctionModuleWithIdentifier:key];
        [inTabBarFunctions addObject:viewController];
    }
    self.inTabbarViewControllers = [NSMutableArray arrayWithArray:inTabBarFunctions];
    
    NSArray* inPullViewFunctionsName = [dictionary objectForKey:IN_PULL_VIEW_KEY];
    NSMutableArray* inPullViewFunctions = [NSMutableArray array];
    for (NSString* key in inPullViewFunctionsName) {
        UIViewController* viewController = [[FunctionModuleFactory singleton] produceTheFunctionModuleWithIdentifier:key];
        [inPullViewFunctions addObject:viewController];
    }
    self.inPullViewControllers = [NSMutableArray arrayWithArray:inPullViewFunctions];
    
    NSArray* notShowFunctionsName = [dictionary objectForKey:NOT_SHOW_KEY];
    NSMutableArray* notShowFunctions = [NSMutableArray array];
    for (NSString* key in notShowFunctionsName) {
        UIViewController* viewController = [[FunctionModuleFactory singleton] produceTheFunctionModuleWithIdentifier:key];
        [notShowFunctions addObject:viewController];
    }
    self.notShowViewControllers = [NSMutableArray arrayWithArray:notShowFunctions];
}

@end
