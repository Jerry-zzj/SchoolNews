//
//  AddressBook.m
//  AddressBookOperation
//
//  Created by 振嘉 张 on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddressBook.h"

//------------------------------------------------------------------------------
@interface AddressBook(Private)

- (void)updateTheAddressBook;
- (NSString* )getNameForPerson:(ABRecordRef )person;
- (NSDictionary* )getNameDictionaryFromName:(NSString* )sender;

- (void)saveGroup:(NSString* )groupName InPerson:(ABRecordRef* )personSender;
- (void)savePhone:(NSDictionary* )phoneDictionary InPerson:(ABRecordRef* )personSender;
- (void)saveEmail:(NSDictionary* )emailDictionary InPerson:(ABRecordRef* )personSender;
- (void)saveURL:(NSDictionary* )urlDictionary InPerson:(ABRecordRef* )personSender;
- (void)saveName:(NSDictionary* )nameDictionary InPerson:(ABRecordRef* )personSender;
- (void)saveOrganication:(NSDictionary* )organizationDictionary InPerson:(ABRecordRef* )personSender;
- (void)saveNote:(NSString* )noteDictionary InPerson:(ABRecordRef* )personSender;

@end
//------------------------------------------------------------------------------

@implementation AddressBook
AddressBook* g_addressBook;
+ (AddressBook* )singleton
{
    if (g_addressBook == nil)
    {
        g_addressBook = [[AddressBook alloc] init];
    }
    return g_addressBook;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        {
            addressBook_ = ABAddressBookCreateWithOptions(NULL, NULL);
            //等待同意后向下执行
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook_, ^(bool granted, CFErrorRef error)
                                                     {
                                                         dispatch_semaphore_signal(sema);
                                                     });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            //dispatch_release(sema);
        }
    }
    return self;
}


- (BOOL)addNewContactWithName:(NSDictionary* )name
                 Organization:(NSDictionary* )organization 
                        Phone:(NSDictionary* )phone 
                        Email:(NSDictionary* )email 
                          URL:(NSDictionary* )url 
                         Note:(NSString* )note
{
    //[self updateTheAddressBook];
    ABRecordRef newOne = ABPersonCreate();
	
	[self saveOrganication:organization InPerson:&newOne];
	[self saveName:name InPerson:&newOne];	
	[self savePhone:phone InPerson:&newOne];
	[self saveEmail:email InPerson:&newOne];
	[self saveURL:url InPerson:&newOne];
	[self saveNote:note InPerson:&newOne];
	
	BOOL saveState = ABAddressBookAddRecord(addressBook_, newOne, NULL);
	ABAddressBookSave(addressBook_, NULL);
    NSString* addedName = [self getNameForPerson:newOne];
    ABRecordID id = ABRecordGetRecordID(newOne);
    [personNameInYourAdressBook_ setValue:[NSNumber numberWithInt:id] forKey:addedName];
    if (addressBook_) {
        CFRelease(addressBook_);
    }
	return saveState;
}

- (BOOL)AddContractInformation:(NSString* )name
             WithOriganization:(NSDictionary* )origanization
                         Phone:(NSDictionary* )phone
                         Email:(NSDictionary* )email
                           URL:(NSDictionary* )url
                          Note:(NSString* )note
{
    //[self updateTheAddressBook];
    NSNumber* temPersonID = [personNameInYourAdressBook_ objectForKey:name];
    ABRecordID personID = [temPersonID intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook_, personID);[personNameInYourAdressBook_ objectForKey:name];
    [self saveOrganication:origanization InPerson:&person];
	[self savePhone:phone InPerson:&person];
	[self saveEmail:email InPerson:&person];
	[self saveURL:url InPerson:&person];
	[self saveNote:note InPerson:&person];
	
	//BOOL saveState = ABAddressBookAddRecord(addressBook_, person, NULL);
	ABAddressBookSave(addressBook_, NULL);
    if (addressBook_) {
        CFRelease(addressBook_);
    }
	return YES;
}

- (BOOL)replaceContactInformation:(NSString* )name
                WithOriganization:(NSDictionary* )origanization
                            Phone:(NSDictionary* )phone
                            Email:(NSDictionary* )email
                              URL:(NSDictionary* )url
                             Note:(NSString* )note
{
    NSNumber* temPersonID = [personNameInYourAdressBook_ objectForKey:name];
    ABRecordID personID = [temPersonID intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook_, personID);
    ABAddressBookRemoveRecord(addressBook_, person, nil);
    ABAddressBookSave(addressBook_, nil);
    NSDictionary* nameDictionary = [self getNameDictionaryFromName:name];
    return [self addNewContactWithName:nameDictionary
                          Organization:origanization
                                 Phone:phone
                                 Email:email
                                   URL:url
                                  Note:note];
}

- (BOOL)addContactInformation:(NSString* )name
            WithOriganization:(NSDictionary* )origanization
                        Phone:(NSDictionary* )phone
                        Email:(NSDictionary* )email
                          URL:(NSDictionary* )url
                         Note:(NSString* )note
                      InGroup:(NSString* )group
{
    [self updateTheAddressBook];
    ABRecordRef newOne = ABPersonCreate();
    NSNumber* temPersonID = [personNameInYourAdressBook_ objectForKey:name];
    if (temPersonID != nil) {
        ABRecordID personID = [temPersonID intValue];
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook_, personID);
        ABAddressBookRemoveRecord(addressBook_, person, nil);
        ABAddressBookSave(addressBook_, nil);
        
    }
    NSArray* allGroupArray = (__bridge_transfer NSArray* )ABAddressBookCopyArrayOfAllGroups(addressBook_);
    ABRecordRef groupRecord = NULL;
    for (id groupRef in allGroupArray) {
        ABRecordRef groupInArray = (__bridge ABRecordRef)groupRef;
        NSString* groupInArrayName = (__bridge NSString*)ABRecordCopyValue(groupInArray, kABGroupNameProperty);
        if ([groupInArrayName isEqualToString:group]) {
            groupRecord = groupInArray;
            break;
        }
    }
    [self saveOrganication:origanization InPerson:&newOne];
	[self saveName:[self getNameDictionaryFromName:name] InPerson:&newOne];
	[self savePhone:phone InPerson:&newOne];
	[self saveEmail:email InPerson:&newOne];
	[self saveURL:url InPerson:&newOne];
	[self saveNote:note InPerson:&newOne];
    ABAddressBookAddRecord(addressBook_, newOne, nil);
    ABAddressBookSave(addressBook_, nil);
	BOOL saveState;
    if (groupRecord != NULL) {
        CFErrorRef error;
        saveState = ABGroupAddMember(groupRecord, newOne,&error);
        if (!saveState) {
            NSError* nsError = (__bridge_transfer NSError* )error;
            NSLog(@"domain:%@",[nsError domain]);
            NSLog(@"--------------------------");
            NSLog(@"descripe:%@",[nsError localizedDescription]);
        }
        ABAddressBookSave(addressBook_, nil);
    }
    else
    {
        groupRecord = ABGroupCreate();
        CFStringRef groupRef = (__bridge_retained CFStringRef)group;
        ABRecordSetValue(groupRecord, kABGroupNameProperty, groupRef, nil);
        saveState = ABAddressBookAddRecord(addressBook_, groupRecord, nil);
        if (!saveState) {
            NSLog(@"falied");
        }
        ABAddressBookSave(addressBook_, nil);
        saveState = ABGroupAddMember(groupRecord, newOne, nil);
        if (!saveState) {
            NSLog(@"faild");
        }
        ABAddressBookSave(addressBook_, NULL);
    }
    
    /*NSString* addedName = [self getNameForPerson:newContact];
    ABRecordID id = ABRecordGetRecordID(newContact);
    [personNameInYourAdressBook_ setObject:[NSNumber numberWithInt:id] forKey:addedName];*/
	if (addressBook_) {
        CFRelease(addressBook_);
    }
    return saveState;
}

- (BOOL)personExitInAdressBook:(NSString* )sender
{
    [self updateTheAddressBook];
    if ([[personNameInYourAdressBook_ allKeys] containsObject:sender]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

//------------------------------------------------------------------------------
#pragma mark private
- (void)updateTheAddressBook
{
    addressBook_ = ABAddressBookCreateWithOptions(nil, nil);
    personNameInYourAdressBook_ = [NSMutableDictionary dictionary];
    if(addressBook_ != nil)
    {
        NSArray* allPersonArray = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook_);
        for (id object in allPersonArray) {
            ABRecordRef person = (__bridge ABRecordRef )object;
            NSString* name = [self getNameForPerson:person];
            ABRecordID personID = ABRecordGetRecordID(person);
            if (name != nil) {
                [personNameInYourAdressBook_ setValue:[NSNumber numberWithInt:personID] forKey:name];
            }
        }
    }
}

- (NSString* )getNameForPerson:(ABRecordRef )person
{
    NSString* firstName = (__bridge NSString* )ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* middleName = (__bridge NSString* )ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    NSString* lastName = (__bridge NSString* )ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSMutableString* name = [[NSMutableString alloc] init];
    if (lastName != nil) {
        [name appendString:lastName];
    }
    if (middleName != nil)
    {
        [name appendString:middleName];
    }
    if (firstName != nil)
    {
        [name appendString:firstName];
    }
    if([name length] > 0)
    {
        return name;
    }
    else
    {
        return nil;
    }
}

- (void)savePhone:(NSDictionary* )phoneDictionary InPerson:(ABRecordRef* )personSender
{
    ABMutableMultiValueRef oldPhoneValue = (ABMutableMultiValueRef)ABRecordCopyValue(*personSender, kABPersonPhoneProperty);
    NSArray* oldValues;
    ABMutableMultiValueRef phoneValue;
    if (oldPhoneValue == NULL) {
        phoneValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        oldValues = [NSMutableArray array];
    }
    else
    {
        phoneValue = ABMultiValueCreateMutableCopy(oldPhoneValue);
        oldValues = (__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(oldPhoneValue);
    }
    //ABMutableMultiValueRef phoneValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    NSArray* labels = [phoneDictionary allKeys];
	for (int index = 0;index < [labels count]; index ++)
	{
		NSString* label = [labels objectAtIndex:index];
        //NSString* home = [NSString stringWithString:@"mobile"];
		NSString* phone = [phoneDictionary objectForKey:label];
        BOOL exit = NO;
        for (int index = 0; index < [oldValues count]; index ++) {
            NSString* oldLabel = (__bridge NSString* )ABMultiValueCopyLabelAtIndex(oldPhoneValue, index);
            NSString* oldPhone = [oldValues objectAtIndex:index];
            if ([oldLabel isEqualToString:label] && [oldPhone isEqualToString:phone]) {
                exit = YES;
                break;
            }
        }
		if ([phone isEqualToString:@""] || exit)
		{
			continue;
		}
		ABMultiValueIdentifier multiIdentifier;
        ABMultiValueAddValueAndLabel(phoneValue,
                                     (__bridge_retained CFStringRef)phone,
                                     (__bridge_retained CFStringRef)label,
                                     &multiIdentifier);
	}
	ABRecordSetValue(*personSender, kABPersonPhoneProperty, phoneValue,NULL );
}

- (void)saveEmail:(NSDictionary* )emailDictionary InPerson:(ABRecordRef* )personSender
{
    ABMutableMultiValueRef oldEmailValue = (ABMutableMultiValueRef)ABRecordCopyValue(*personSender, kABPersonEmailProperty);
    NSArray* oldValues;
    ABMutableMultiValueRef emailValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    if (oldEmailValue == NULL) {
        emailValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        oldValues = [NSMutableArray array];
    }
    else
    {
        emailValue = ABMultiValueCreateMutableCopy(oldEmailValue);
        oldValues = (__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(oldEmailValue);
    }
    NSArray* labels = [emailDictionary allKeys];
	for (int index = 0;index < [labels count]; index ++)
	{
		NSString* label = [labels objectAtIndex:index];
		NSString* email = [emailDictionary objectForKey:label];
        BOOL exit = NO;
        for (int index = 0; index < [oldValues count]; index ++) {
            NSString* oldLabel = (__bridge NSString* )ABMultiValueCopyLabelAtIndex(oldEmailValue, index);
            NSString* oldemail = [oldValues objectAtIndex:index];
            if ([oldLabel isEqualToString:label] && [oldemail isEqualToString:email]) {
                exit = YES;
                break;
            }
        }
		if ([email isEqualToString:@""] || exit)
		{
			continue;
		}
		ABMultiValueIdentifier multiIdentifier;
		ABMultiValueAddValueAndLabel(emailValue, 
									 (__bridge_retained CFStringRef)email, 
									 (__bridge_retained CFStringRef)label, 
									 &multiIdentifier);
	}
	ABRecordSetValue(*personSender, kABPersonEmailProperty, emailValue,NULL );
}

- (void)saveURL:(NSDictionary* )urlDictionary InPerson:(ABRecordRef* )personSender
{
    ABMutableMultiValueRef oldURLValue = (ABMutableMultiValueRef)ABRecordCopyValue(*personSender, kABPersonURLProperty);
    NSArray* oldValues;
    ABMutableMultiValueRef urlValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    if (oldURLValue == NULL) {
        urlValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        oldValues = [NSMutableArray array];
    }
    else
    {
        urlValue = ABMultiValueCreateMutableCopy(oldURLValue);
        oldValues = (__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(oldURLValue);
    }
    NSArray* labels = [urlDictionary allKeys];
	for (int index = 0;index < [labels count]; index ++)
	{
		NSString* label = [labels objectAtIndex:index];
		NSString* url = [urlDictionary objectForKey:label];
        BOOL exit = NO;
        for (int index = 0; index < [oldValues count]; index ++) {
            NSString* oldLabel = (__bridge NSString* )ABMultiValueCopyLabelAtIndex(oldURLValue, index);
            NSString* oldurl = [oldValues objectAtIndex:index];
            if ([oldLabel isEqualToString:label] && [oldurl isEqualToString:url]) {
                exit = YES;
                break;
            }
        }
		if ([url isEqualToString:@""] || exit)
		{
			continue;
		}
        ABMultiValueIdentifier multiIdentifier;
		ABMultiValueAddValueAndLabel(urlValue, 
									 (__bridge_retained CFStringRef)url, 
									 (__bridge_retained CFStringRef)label, 
									 &multiIdentifier);
	}
	ABRecordSetValue(*personSender, kABPersonURLProperty, urlValue,NULL );
}

- (void)saveName:(NSDictionary* )nameDictionary InPerson:(ABRecordRef* )personSender
{
    CFStringRef firstName = (__bridge_retained CFStringRef)[nameDictionary objectForKey:@"First Name"];
    CFStringRef middleName = (__bridge_retained CFStringRef)[nameDictionary objectForKey:@"Middle Name"];
    CFStringRef lastName = (__bridge_retained CFStringRef)[nameDictionary objectForKey:@"Last Name"];
    
    ABRecordSetValue(*personSender, kABPersonFirstNameProperty, firstName, NULL);
    ABRecordSetValue(*personSender, kABPersonMiddleNameProperty, middleName, NULL);
    ABRecordSetValue(*personSender, kABPersonLastNameProperty, lastName, NULL);
}

- (NSDictionary* )getNameDictionaryFromName:(NSString* )sender
{
    NSString* totalName = sender;
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
    [nameDictionary setValue:firstName forKey:@"First Name"];
    [nameDictionary setValue:lastName forKey:@"Last Name"];
    return nameDictionary;
    
}

- (void)saveOrganication:(NSDictionary* )organizationDictionary InPerson:(ABRecordRef* )personSender
{
    CFStringRef company = (__bridge_retained CFStringRef)[organizationDictionary objectForKey:@"Company"];
    CFStringRef jobTitle = (__bridge_retained CFStringRef)[organizationDictionary objectForKey:@"Job"];
    CFStringRef department = (__bridge_retained CFStringRef)[organizationDictionary objectForKey:@"Department"];
    
    ABRecordSetValue(*personSender, kABPersonOrganizationProperty, company, NULL);
    ABRecordSetValue(*personSender, kABPersonJobTitleProperty, jobTitle, NULL);
    ABRecordSetValue(*personSender, kABPersonDepartmentProperty, department, NULL);
    
}

- (void)saveNote:(NSString* )noteString InPerson:(ABRecordRef* )personSender
{
    CFStringRef note = (__bridge_retained CFStringRef)noteString;
	ABRecordSetValue(*personSender, kABPersonNoteProperty, note, NULL);
}

@end
