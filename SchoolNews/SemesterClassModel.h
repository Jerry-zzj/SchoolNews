//
//  SemesterClassModel.h
//  SchoolNews
//
//  Created by Jerry on 5月9星期四.
//
//

#import <Foundation/Foundation.h>
#import "ClassWebService.h"
@protocol SemesterClassModelDelegate<NSObject>

- (void)getTheClassFromWebservice:(id)sender;

@end
@interface SemesterClassModel : NSObject<ClassWebServiceDelegate>
@property (nonatomic,assign)id<SemesterClassModelDelegate> delegate;
+ (SemesterClassModel* )singleton;
- (NSDictionary* )getAllClass;
@end
