//
//  AboutLabel.h
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AboutLabel : NSObject
+ (float)getHeightWithFontSize:(float )fontSize
                         Width:(float )width
                          Text:(NSString* )text;

+ (float)getHeightWithFont:(UIFont* )font
                     Width:(float)width
                      Text:(NSString *)text;
@end
