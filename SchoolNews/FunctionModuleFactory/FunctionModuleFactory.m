//
//  FunctionModuleFactory.m
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FunctionModuleFactory.h"
#import "NewsViewController.h"
#import "NotificationViewController.h"
#import "EducationalAdministrationViewController.h"

#import "MeetsViewController.h"

#import "LecturesViewController.h"
#import "GroupLearningActivitiesViewController.h"
#import "ForeignExchangeViewController.h"
#import "ContactsViewController.h"
#import "ComplexViewController.h"
#import "TeachingServiceViewController.h"
#import "XueGongServiceViewController.h"
#import "PersonnelViewController.h"
#import "ResearchServiceViewController.h"
#import "FinancialServiceViewController.h"
#import "SafeCampusViewController.h"
#import "LogisticsServiceViewController.h"
#import "AssetServiceViewController.h"
#import "EmployMentServiceViewController.h"
@implementation FunctionModuleFactory
FunctionModuleFactory* g_FunctionModuleFactory;
+ (FunctionModuleFactory* )singleton
{
    if (g_FunctionModuleFactory == nil) {
        g_FunctionModuleFactory = [[FunctionModuleFactory alloc] init];
    }
    return g_FunctionModuleFactory;
}

- (FunctionViewController* )produceTheFunctionModuleWithIdentifier:(NSString* )Identifier
{
    FunctionViewController* viewController;
    if ([Identifier isEqualToString:@"浙传新闻"]) {
        viewController = [NewsViewController singleton];
        viewController.functionCode = @"01";
    }
    else if ([Identifier isEqualToString:@"通知公告"])
    {
        viewController = [NotificationViewController singleton];
        viewController.functionCode = @"04";
    }
    else if ([Identifier isEqualToString:@"一周会议"])
    {
        viewController = [MeetsViewController singleton];
        viewController.functionCode = @"02";
    }
    else if ([Identifier isEqualToString:@"就业服务"])
    {
        viewController = [EmployMentServiceViewController singleton];
        viewController.functionCode = @"05";
    }
    else if ([Identifier isEqualToString:@"学术讲座"]) {
        viewController = [LecturesViewController singleton];
        viewController.functionCode = @"06";
    }
    else if ([Identifier isEqualToString:@"团学活动"]){
        viewController = [GroupLearningActivitiesViewController singleton];
        viewController.functionCode = @"07";
    }
    else if ([Identifier isEqualToString:@"对外交流"])
    {
        viewController = [ForeignExchangeViewController singleton];
        viewController.functionCode = @"08";
    }
    else if ([Identifier isEqualToString:@"教学服务"]) {
        viewController = [TeachingServiceViewController singleton];
    }
    else if ([Identifier isEqualToString:@"学工服务"]) {
        viewController = [XueGongServiceViewController singleton];
    }
    else if ([Identifier isEqualToString:@"人事服务"]) {
        viewController = [PersonnelViewController singleton];
        viewController.functionCode = @"09";
    }
    else if ([Identifier isEqualToString:@"科研服务"]) {
        viewController = [ResearchServiceViewController singleton];
    }
    else if ([Identifier isEqualToString:@"计财服务"]) {
        viewController = [FinancialServiceViewController singleton];
    }
    else if ([Identifier isEqualToString:@"资产服务"])
    {
        viewController = [AssetServiceViewController singleton];
    }
    else if ([Identifier isEqualToString:@"平安校园"]) {
        viewController = [SafeCampusViewController singleton];
    }
    else if ([Identifier isEqualToString:@"后勤服务"])
    {
        viewController = [LogisticsServiceViewController singleton];
    }
    else if ([Identifier isEqualToString:@"通讯录"])
    {
        viewController = [ContactsViewController singleton];
        viewController.functionCode = @"03";
    }
    else if ([Identifier isEqualToString:@"综合服务"])
    {
        viewController = [ComplexViewController singleton];
        viewController.functionCode = @"10";
    }
    else if ([Identifier isEqualToString:@"移动服务"])
    {
        //viewController = [JiuYeViewController singleton];
    }
    else if ([Identifier isEqualToString:@"教务服务"])
    {
        viewController = [EducationalAdministrationViewController singleton];
        viewController.functionCode = @"12";
    }
    viewController.title = Identifier;
    return viewController;
}
@end
