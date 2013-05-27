//
//  ContactsDictionaryTransform.m
//  SchoolNews
//
//  Created by Jerry on 1月15星期二.
//
//

#import "ContactsDictionaryTransform.h"
@interface ContactsDictionaryTransform (private)

- (NSDictionary* )getNameDictionaryFromDictionary:(NSDictionary* )sender;
- (NSDictionary* )getOrganizationDictionaryFromDictionary:(NSDictionary* )sender;
- (NSDictionary* )getPhoneDictioaryFromDictionary:(NSDictionary* )sender;
- (NSDictionary* )getEmailDictionaryFromDictionary:(NSDictionary* )sender;
- (NSDictionary* )getURLDictionaryFromDictionary:(NSDictionary* )sender;
- (NSDictionary* )getNoteStringFromDictionary:(NSDictionary* )sender;

@end

@implementation ContactsDictionaryTransform
ContactsDictionaryTransform* g_ContactsDictionaryTransform;
+ (id)singleton
{
    if (g_ContactsDictionaryTransform == nil) {
        g_ContactsDictionaryTransform = [[ContactsDictionaryTransform alloc] init];
    }
    return g_ContactsDictionaryTransform;
}

- (NSDictionary* )getContractFromContractDictionary:(NSDictionary* )sender
{
    NSDictionary* nameDictionary = [self getNameDictionaryFromDictionary:sender];
    NSDictionary* origanizationDictionary = [self getOrganizationDictionaryFromDictionary:sender];
    NSDictionary* phoneDictionary = [self getPhoneDictioaryFromDictionary:sender];
    NSDictionary* urlDictionary = [self getURLDictionaryFromDictionary:sender];
    NSDictionary* emailDictionary = [self getEmailDictionaryFromDictionary:sender];
    NSDictionary* noteDictionary = [self getNoteStringFromDictionary:sender];
    
    NSMutableDictionary* contactToSaveDictionary = [NSMutableDictionary dictionary];
    if (nameDictionary != nil) {
        [contactToSaveDictionary setObject:nameDictionary forKey:@"姓名"];
    }
    if (origanizationDictionary != nil) {
        [contactToSaveDictionary setObject:origanizationDictionary forKey:@"公司"];
    }
    if (phoneDictionary != nil) {
        [contactToSaveDictionary setObject:phoneDictionary forKey:@"电话"];
    }
    if (urlDictionary != nil) {
        [contactToSaveDictionary setObject:urlDictionary forKey:@"网址"];
    }
    if (emailDictionary != nil) {
        [contactToSaveDictionary setObject:emailDictionary forKey:@"邮箱"];
    }
    if (noteDictionary != nil) {
        [contactToSaveDictionary setObject:noteDictionary forKey:@"备注"];
    }
    return contactToSaveDictionary;
}

#pragma mark private
- (NSDictionary* )getNameDictionaryFromDictionary:(NSDictionary* )sender
{
    NSString* totalName = [sender objectForKey:@"姓名"];
    NSString* firstName;
    //NSString* middleName;
    NSString* lastName;
    int nameLength = [totalName length];
    if (nameLength >= 2)
    {
        lastName = [totalName substringToIndex:1];
        firstName = [totalName substringFromIndex:1];
    }
    else
    {
        lastName = totalName;
    }
    NSMutableDictionary* nameDictionary = [NSMutableDictionary dictionary];
    [nameDictionary setObject:firstName forKey:@"First Name"];
    [nameDictionary setObject:lastName forKey:@"Last Name"];
    return nameDictionary;

}

- (NSDictionary* )getOrganizationDictionaryFromDictionary:(NSDictionary* )sender
{
    NSString* department = [sender objectForKey:@"部门"];
    NSString* jobtitle = [sender objectForKey:@"职务"];
    NSString* conpany = @"浙江传媒学院";
    NSMutableDictionary* organization = [NSMutableDictionary dictionary];
    if (department != nil) {
        [organization setObject:department forKey:@"Department"];
    }
    if (jobtitle != nil) {
        [organization setObject:jobtitle forKey:@"Job"];
    }
    if (conpany != nil) {
        [organization setObject:conpany forKey:@"Company"];
    }
    return organization;
}

- (NSDictionary* )getPhoneDictioaryFromDictionary:(NSDictionary* )sender
{
    NSString* cmcc = [sender objectForKey:@"移动"];
    NSString* chinanet = [sender objectForKey:@"电信"];
    NSString* unicom = [sender objectForKey:@"联通"];
    NSString* cmccShort = [sender objectForKey:@"移动短号"];
    NSString* chinanetShort = [sender objectForKey:@"电信短号"];
    NSString* unicomShort = [sender objectForKey:@"联通短号"];
    NSString* housePhone = [sender objectForKey:@"家庭电话"];
    NSString* tongxiangOfficePhone = [sender objectForKey:@"办公室电话2"];
    NSString* xiashaOfficePhone = [sender objectForKey:@"办公室电话1"];
    NSMutableDictionary* phoneDictionary = [[NSMutableDictionary alloc] initWithCapacity:7];
    if (cmcc != nil)
    {
        [phoneDictionary setValue:cmcc forKey:@"移动"];
    }
    if (chinanet != nil)
    {
        [phoneDictionary setValue:chinanet forKey:@"电信"];
    }
    if (unicom != nil)
    {
        [phoneDictionary setValue:unicom forKey:@"联通"];
    }
    if (cmccShort != nil)
    {
        [phoneDictionary setValue:cmccShort forKey:@"移动短号"];
    }
    if (chinanetShort != nil)
    {
        [phoneDictionary setValue:chinanetShort forKey:@"电信短号"];
    }
    if (unicomShort != nil) {
        [phoneDictionary setValue:unicomShort forKey:@"联通短号"];
    }
    if (housePhone != nil)
    {
        [phoneDictionary setValue:housePhone forKey:@"家庭号码"];
    }
    if (xiashaOfficePhone != nil)
    {
        [phoneDictionary setValue:xiashaOfficePhone forKey:@"办公室电话1"];
    }
    if (tongxiangOfficePhone != nil)
    {
        [phoneDictionary setValue:tongxiangOfficePhone forKey:@"办公室电话2"];
    }
    return phoneDictionary;

}

- (NSDictionary* )getEmailDictionaryFromDictionary:(NSDictionary* )sender
{
    return nil;
}

- (NSDictionary* )getURLDictionaryFromDictionary:(NSDictionary* )sender
{
    return nil;
}

- (NSDictionary* )getNoteStringFromDictionary:(NSDictionary* )sender
{
    return nil;
}

@end
