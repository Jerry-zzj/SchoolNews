//
//  ClassWebService.h
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "WebService.h"
@protocol ClassWebServiceDelegate<NSObject>

- (void)finishGetClassData:(id)sender;

@end
@interface ClassWebService : WebService
@property (nonatomic,assign) id<ClassWebServiceDelegate> delegate;
@end
