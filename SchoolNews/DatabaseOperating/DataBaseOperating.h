//
//  DataBaseOperating.h
//  SchoolNews
//
//  Created by 振嘉 张 on 12-11-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@interface DataBaseOperating : NSObject
{
    FMDatabase* database_;
}

+ (DataBaseOperating* )singleton;
- (NSArray* )getFunctions;
- (NSArray* )getSubtitleForFunction:(NSString* )string;

//get campus hotline
- (NSDictionary* )getCampusHotline;
@end
