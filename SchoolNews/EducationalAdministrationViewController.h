//
//  EducationalAdministrationViewController.h
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "FunctionViewController.h"
#import "LoginViewController.h"
@interface EducationalAdministrationViewController : FunctionViewController<LoginViewControllerDelegate>
+ (id)singleton;
@end
