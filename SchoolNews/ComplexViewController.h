//
//  ComplexViewController.h
//  SchoolNews
//
//  Created by Jerry on 4月23星期二.
//
//

#import "FunctionViewController.h"
#import "SubFunctionViewController.h"

@interface ComplexViewController : FunctionViewController<SubFunctionViewControllerDelegate>
+ (ComplexViewController* )singleton;
@end
