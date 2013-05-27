//
//  NewsObject.h
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import <Foundation/Foundation.h>

@interface NewsObject : NSObject<NSCoding,NSCopying>
@property (nonatomic,retain) NSString* ID;
@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* synopsis;
@property (nonatomic,retain) NSString* synopsisImagePath;
@property (nonatomic,retain) UIImage* synopsisImage;
@property (nonatomic,retain) NSString* content;
@property (nonatomic,retain) NSDate* date;
@property (nonatomic,retain) NSString* department;
@property (nonatomic,retain) NSString* subtitle;
@property (nonatomic,retain) NSString* newsFrom;
@property (nonatomic,assign) BOOL top;
@end
