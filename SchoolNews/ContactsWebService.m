//
//  ContactsWebService.m
//  SchoolNews
//
//  Created by Jerry on 1月3星期四.
//
//

#import "ContactsWebService.h"
#import "GDataXMLNode.h"
#import "NSString-RemoveSuperfluousString.h"
@implementation ContactsWebService
ContactsWebService* g_ContactsWebService;
+ (id )singleton
{
    if (g_ContactsWebService == nil) {
        g_ContactsWebService = [[ContactsWebService alloc] init];
    }
    return g_ContactsWebService;
}

- (void )getWebServiceData
{
    ASIHTTPRequest* request= [[ASIHTTPRequest alloc] initWithURL:url_];
    NSLog(@"%@",url_);
    [request setTimeOutSeconds:60];
    [request setDelegate:self];
    [request startAsynchronous];
    /*while(!finished_) {
     [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
     }*/
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
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSArray* contacts = [temp elementsForName:@"Contact"];
    NSMutableDictionary* contactsDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray* allDepartment = [NSMutableArray array];
    for (GDataXMLElement* element in contacts) {
        NSMutableDictionary* contact = [[NSMutableDictionary alloc] init];
        
        //姓名
        GDataXMLElement* nameElement = [[element elementsForName:@"Name"]
                                         objectAtIndex:0];
        NSString* name = [[nameElement stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
        [contact setValue:name forKey:@"姓名"];
        
        //部门
        GDataXMLElement* departmentElement = [[element elementsForName:@"Department"]
                                        objectAtIndex:0];
        NSString* tempDepartmentString = [departmentElement stringValue];
        NSString* departmentString = [tempDepartmentString removeSuperfluousStringForDepartment];

        //职务
        GDataXMLElement* jobElement = [[element elementsForName:@"Job"]
                                           objectAtIndex:0];
        NSString* job = [[jobElement stringValue] removeNullNumber];
        [contact setValue:job forKey:@"职务"];
        
        //办公地址
        GDataXMLElement* officeAddressElement = [[element elementsForName:@"OfficeAddress"] objectAtIndex:0];
        NSString* officeAddress = [officeAddressElement stringValue];
        [contact setValue:officeAddress forKey:@"办公室地址"];
        
        //下沙办公电话
        GDataXMLElement* xiashaOfficePhoneElement = [[element elementsForName:@"XiashaOfficePhone"] objectAtIndex:0];
        NSString* officePhone = [[xiashaOfficePhoneElement stringValue] removeNullNumber];
        //[contact setValue:officePhone forKey:@"下沙办公电话"];
        [contact setValue:officePhone forKey:@"办公室电话1"];
        
        //桐乡办公电话
        GDataXMLElement* tongxiangOfficePhoneElement = [[element elementsForName:@"TongxiangOfficePhone" ]objectAtIndex:0];
        NSString* tongxiangOfficePhone = [tongxiangOfficePhoneElement stringValue];
        //[contact setValue:tongxiangOfficePhone forKey:@"桐乡办公室电话"];
        [contact setValue:tongxiangOfficePhone forKey:@"办公室电话2"];
        //移动
        GDataXMLElement* cmccPhoneElement = [[element elementsForName:@"CMCC"] objectAtIndex:0];
        NSString* cmcc = [[cmccPhoneElement stringValue] removeNullNumber];
        [contact setValue:cmcc forKey:@"移动"];
        //移动短号
        GDataXMLElement* cmccShortPhoneElement = [[element elementsForName:@"CMCCShort"] objectAtIndex:0];
        NSString* cmccShort = [[cmccShortPhoneElement stringValue] removeNullNumber];
        [contact setValue:cmccShort forKey:@"移动短号"];
        //联通
        GDataXMLElement* unicomPhoneElement = [[element elementsForName:@"Unicom"] objectAtIndex:0];
        NSString* unicom = [[unicomPhoneElement stringValue] removeNullNumber];
        [contact setValue:unicom forKey:@"联通"];
        //联通短号
        GDataXMLElement* unicomShortPhoneElement = [[element elementsForName:@"UnicomShort"] objectAtIndex:0];
        NSString* unicomShort = [[unicomShortPhoneElement stringValue] removeNullNumber];
        [contact setValue:unicomShort forKey:@"联通短号"];
        //电信
        GDataXMLElement* chinanetPhoneElement = [[element elementsForName:@"Chinanet"] objectAtIndex:0];
        NSString* chinanet = [[chinanetPhoneElement stringValue] removeNullNumber];
        [contact setValue:chinanet forKey:@"电信"];
        //电信短号
        GDataXMLElement* chinanetShortElement = [[element elementsForName:@"ChinanetShort"] objectAtIndex:0];
        NSString* chinanetShort = [[chinanetShortElement stringValue] removeNullNumber];
        [contact setValue:chinanetShort forKey:@"电信短号"];
        //传真
        GDataXMLElement* faxElement = [[element elementsForName:@"Fax"] objectAtIndex:0];
        NSString* fax = [[faxElement stringValue] removeNullNumber];
        [contact setValue:fax forKey:@"传真"];
        //邮箱
        GDataXMLElement* emailElement = [[element elementsForName:@"Email"] objectAtIndex:0];
        NSString* email = [emailElement stringValue];
        [contact setValue:email forKey:@"邮箱"];
        //QQ
        GDataXMLElement* qqElement = [[element elementsForName:@"QQ"] objectAtIndex:0];
        NSString* qq = [[qqElement stringValue] removeNullNumber];
        [contact setValue:qq forKey:@"QQ"];
        //家庭电话
        GDataXMLElement* homePhoneElement = [[element elementsForName:@"HomePhone"] objectAtIndex:0];
        NSString* homePhone = [homePhoneElement stringValue];
        [contact setValue:homePhone forKey:@"家庭电话"];
        //家庭地址
        GDataXMLElement* homeAddElement = [[element elementsForName:@"HomeAddress"] objectAtIndex:0];
        NSString* homeAdd = [[homeAddElement stringValue] removeNullNumber];
        [contact setValue:homeAdd forKey:@"家庭住址"];
        //将通知加到通知数组中
        if ([[contactsDictionary allKeys] containsObject:departmentString]) {
            NSMutableArray* contacts = [contactsDictionary objectForKey:departmentString];
            [contacts addObject:contact];
        }
        else
        {
            NSMutableArray* contacts = [NSMutableArray array];
            [contacts addObject:contact];
            [contactsDictionary setObject:contacts forKey:departmentString];
            [allDepartment addObject:departmentString];
        }
    }
    NSArray* departmentsAndContacts = [NSArray arrayWithObjects:allDepartment,contactsDictionary, nil];
    return departmentsAndContacts;
}

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_CONTACT_DATA object:object];
}

//将通讯录缓存在缓存区
- (void)savetTheDataToBuffer:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveInContactBuffer"
                                                        object:sender];
}

@end
