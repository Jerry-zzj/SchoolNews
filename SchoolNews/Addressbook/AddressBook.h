//
//  AddressBook.h
//  AddressBookOperation
//
//  Created by 振嘉 张 on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <CoreFoundation/CoreFoundation.h>
@interface AddressBook : NSObject
{
    ABAddressBookRef addressBook_;
    NSMutableDictionary* personNameInYourAdressBook_;
}
+ (AddressBook* )singleton;
//只添加，不合并
- (BOOL)addNewContactWithName:(NSDictionary* )name
                 Organization:(NSDictionary* )organization 
                        Phone:(NSDictionary* )phone 
                        Email:(NSDictionary* )email 
                          URL:(NSDictionary* )url 
                         Note:(NSString* )note;

//合并
- (BOOL)AddContractInformation:(NSString* )name
             WithOriganization:(NSDictionary* )origanization
                         Phone:(NSDictionary* )phone
                         Email:(NSDictionary* )email
                           URL:(NSDictionary* )url
                          Note:(NSString* )note;
//将联系人加到组里
- (BOOL)addContactInformation:(NSString* )name
            WithOriganization:(NSDictionary* )origanization
                        Phone:(NSDictionary* )phone
                        Email:(NSDictionary* )email
                          URL:(NSDictionary* )url
                         Note:(NSString* )note
                      InGroup:(NSString* )group;

//替换掉本地的联系人
- (BOOL)replaceContactInformation:(NSString* )name
                WithOriganization:(NSDictionary* )origanization
                            Phone:(NSDictionary* )phone
                            Email:(NSDictionary* )email
                              URL:(NSDictionary* )url
                             Note:(NSString* )note;
- (BOOL)personExitInAdressBook:(NSString* )sender; //每次添加联系人前必须先调用此函数
@end
