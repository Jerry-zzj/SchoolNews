//
//  ViewFactory.m
//  SchoolNews
//
//  Created by Jerry on 1月30星期三.
//
//

#import "ViewFactory.h"
#import "IpadProducer.h"
#import "Iphone4Producer.h"
#import "Iphone5Producer.h"


#define IPAD                            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IPHONE_5                        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@implementation ViewFactory
ViewFactory* g_ViewFactory;
+ (ViewFactory* )singleton
{
    if (g_ViewFactory == nil) {
        g_ViewFactory = [[ViewFactory alloc] init];
    }
    return g_ViewFactory;
}

- (id)init
{
    self = [super init];
    if (self) {
        ipadProducer_ = [[IpadProducer alloc] init];
        iphone4Producer_ = [[Iphone4Producer alloc] init];
        iphone5Producer_ = [[Iphone5Producer alloc] init];
    }
    return self;
}

- (id)produceViewWithIdentifier:(NSString* )sender
{
    if (IPAD) {
        return [ipadProducer_ produceViewWithIdentifier:sender];
    }
    else if (IPHONE_5)
    {
        return [iphone5Producer_ produceViewWithIdentifier:sender];
    }
    else
    {
        return [iphone4Producer_ produceViewWithIdentifier:sender];
    }
}

@end
