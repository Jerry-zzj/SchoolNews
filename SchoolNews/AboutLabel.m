//
//  AboutLabel.m
//  SchoolNews
//
//  Created by Jerry on 12月30星期日.
//
//

#import "AboutLabel.h"

@implementation AboutLabel
+ (float)getHeightWithFontSize:(float )fontSize
                         Width:(float )width
                          Text:(NSString* )text
{
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    CGSize tempSize = CGSizeMake(width, 1000000);
    CGSize size = [text sizeWithFont:font
                   constrainedToSize:tempSize
                       lineBreakMode:NSLineBreakByCharWrapping];
    return size.height;
}

+ (float)getHeightWithFont:(UIFont* )font
                     Width:(float)width
                      Text:(NSString *)text
{
    CGSize tempSize = CGSizeMake(width, 1000000);
    CGSize size = [text sizeWithFont:font
                   constrainedToSize:tempSize
                       lineBreakMode:NSLineBreakByCharWrapping];
    return size.height;
}
@end
