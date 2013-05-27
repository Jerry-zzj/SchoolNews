//
//  NewsModel.h
//  SchoolNews
//
//  Created by Jerry on 5月17星期五.
//
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

- (NSDictionary* )loadNewsForIDS:(NSArray* )ids;

@end
