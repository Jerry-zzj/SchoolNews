//
//  WeekIndexWebService.m
//  SchoolNews
//
//  Created by Jerry on 3月11星期一.
//
//

#import "WeekIndexWebService.h"
#import "GDataXMLNode.h"

@implementation WeekIndexWebService
WeekIndexWebService* g_WeekIndexWebService;
+ (id)singleton
{
    if (g_WeekIndexWebService == nil) {
        g_WeekIndexWebService = [[WeekIndexWebService alloc] init];
    }
    return g_WeekIndexWebService;
}

//模板方法
//处理webservice收到的数据
- (id)doHandleTheData:(NSString *)data
{
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* weekIndex = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    return [weekIndex stringValue];
}

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    if (self.delegate == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_WEEK_INDEX_FROM_SERVER
                                                            object:object];
    }
    else
    {
        [self.delegate getTheWeekIndex:[object intValue]];
    }
    
}
@end
