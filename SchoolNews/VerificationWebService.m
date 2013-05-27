//
//  VerificationWebService.m
//  SchoolNews
//
//  Created by Jerry on 12月31星期一.
//
//

#import "VerificationWebService.h"
#import "GDataXMLNode.h"
#import "UsersInformation.h"
@implementation VerificationWebService
VerificationWebService* g_VerificationWebService;
+ (id)singleton
{
    if (g_VerificationWebService == nil) {
        g_VerificationWebService = [[VerificationWebService alloc] init];
    }
    return g_VerificationWebService;
}
//模板方法
//处理webservice收到的数据
- (id)doHandleTheData:(NSString *)data
{
    //NSLog(@"%@",data);
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* stateElement = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    
    //姓名
    GDataXMLElement* nameElement = [[stateElement elementsForName:@"Name"] objectAtIndex:0];
    NSString* name = [nameElement stringValue];
    
    if (name == nil) {
        return [NSDictionary dictionary];
    }
    
    //类型
    GDataXMLElement* typeElement = [[stateElement elementsForName:@"Type"] objectAtIndex:0];
    NSString* type = [typeElement stringValue];
    UserType userType;
    if ([type isEqualToString:@"1"]) {
        userType = Teacher;
    }
    else if ([type isEqualToString:@"2"])
    {
        userType = Student;
    }
    else
    {
        userType = Visitor;
    }
    
    //注册秘钥状态
    GDataXMLElement* registerStateElement = [[stateElement elementsForName:@"RegisterState"] objectAtIndex:0];
    NSString* registerState = [registerStateElement stringValue];
    BOOL state;
    if ([registerState isEqualToString:@"SUCCESS"]) {
        state = YES;
    }
    else
    {
        state = NO;
    }
    
    //封装成字典
    [NSNumber numberWithInt:userType];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:name,@"姓名",[NSNumber numberWithInt:userType],@"用户类型",[NSNumber numberWithBool:state],@"秘钥注册情况", nil];
    return dictionary;
}

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_FINISHED object:object];
}

@end
