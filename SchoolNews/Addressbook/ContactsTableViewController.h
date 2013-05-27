//
//  ContactsTableViewController.h
//  SchoolNews
//
//  Created by shuangchi on 12月2星期日.
//
//

#import "RefreshUnableTouchEnableViewController.h"
@protocol ContactsTableViewControllerDelegate<NSObject>

- (void)selectThePerson:(NSDictionary* )person;

@end

@interface ContactsTableViewController : RefreshUnableTouchEnableViewController<UISearchBarDelegate,TouchEventTableViewTouchDelegate>
{
    NSArray* tempAllKeys_;
}
@property (nonatomic,assign)id<ContactsTableViewControllerDelegate>seletPersonDelegate;
@property (nonatomic,retain)NSDictionary* allContacts;
@property (nonatomic,retain)UISearchBar* contactSearchBar;
+ (ContactsTableViewController* )singleton;
- (NSArray* )getAllDepartmentSorted;
- (BOOL)addContactsToLocalAddressBook;
@end
