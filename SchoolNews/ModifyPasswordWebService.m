//
//  ModifyPasswordWebService.m
//  SchoolNews
//
//  Created by Jerry on 2月17星期日.
//
//

#import "ModifyPasswordWebService.h"
#import "GDataXMLNode.h"

@implementation ModifyPasswordWebService
ModifyPasswordWebService* g_ModifyPasswordWebService;
+ (id)singleton
{
    if (g_ModifyPasswordWebService == nil) {
        g_ModifyPasswordWebService = [[ModifyPasswordWebService alloc] init];
    }
    return g_ModifyPasswordWebService;
}

//模板方法
//处理webservice收到的数据
- (id)doHandleTheData:(NSString *)data
{
    NSLog(@"%@",data);
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* stateElement = [[rootElement elementsForName:@"ns:return"]
                                    objectAtIndex:0];
    NSString* state = [stateElement stringValue];
    return state;
}

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MODIFY_PASSWORD_FINISHED object:object];
}

@end
