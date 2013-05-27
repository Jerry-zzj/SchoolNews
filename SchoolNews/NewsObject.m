//
//  NewsObject.m
//  SchoolNews
//
//  Created by Jerry on 12月26星期三.
//
//

#import "NewsObject.h"

#define ID_KEY                              @"ID"
#define TITLE_KEY                           @"title"
#define SYNOPSIS_KEY                        @"synopsis"
#define SYNOPSIS_IMAGEPATH_KEY              @"synopsisImagePath"
#define SYNOPSIS_IMAGE_KEY                  @"synopsisImage"
#define CONTENT_KEY                         @"content"
#define DATE_KEY                            @"date"
#define TOP_KEY                             @"top"
#define DEPARTMENT_KEY                      @"department"
#define SUBTITLE_KEY                        @"subtitle"
#define NEWSFROM_KEY                        @"newsFrom"

@implementation NewsObject
@synthesize ID;
@synthesize title;
@synthesize synopsis;
@synthesize synopsisImagePath;
@synthesize synopsisImage;
@synthesize content;
@synthesize date;
@synthesize top;
@synthesize department;
@synthesize subtitle;
@synthesize newsFrom;
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:ID forKey:ID_KEY];
    [aCoder encodeObject:title forKey:TITLE_KEY];
    [aCoder encodeObject:synopsis forKey:SYNOPSIS_KEY];
    //NSData* imageData = UIImageJPEGRepresentation(synopsisImage, 0);
    [aCoder encodeObject:synopsisImage forKey:SYNOPSIS_IMAGE_KEY];
    [aCoder encodeObject:synopsisImagePath forKey:SYNOPSIS_IMAGEPATH_KEY];
    [aCoder encodeObject:content forKey:CONTENT_KEY];
    [aCoder encodeObject:date forKey:DATE_KEY];
    [aCoder encodeBool:top forKey:TOP_KEY];
    [aCoder encodeObject:department forKey:DEPARTMENT_KEY];
    [aCoder encodeObject:subtitle forKey:SUBTITLE_KEY];
    [aCoder encodeObject:newsFrom forKey:NEWSFROM_KEY];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:ID_KEY];
        self.title = [aDecoder decodeObjectForKey:TITLE_KEY];
        self.synopsis = [aDecoder decodeObjectForKey:SYNOPSIS_KEY];
        //NSData* data = [aDecoder decodeObjectForKey:SYNOPSIS_IMAGE_KEY];
        self.synopsisImage = [aDecoder decodeObjectForKey:SYNOPSIS_IMAGE_KEY];
        self.synopsisImagePath = [aDecoder decodeObjectForKey:SYNOPSIS_IMAGEPATH_KEY];
        self.content = [aDecoder decodeObjectForKey:CONTENT_KEY];
        self.date = [aDecoder decodeObjectForKey:DATE_KEY];
        self.top = [aDecoder decodeBoolForKey:TOP_KEY];
        self.department = [aDecoder decodeObjectForKey:DEPARTMENT_KEY];
        self.subtitle = [aDecoder decodeObjectForKey:SUBTITLE_KEY];
        self.newsFrom = [aDecoder decodeObjectForKey:NEWSFROM_KEY];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NewsObject* news = [[NewsObject allocWithZone:zone] init];
    news.ID = [self.ID copyWithZone:zone];
    news.title = [self.title copyWithZone:zone];
    news.synopsis = [self.synopsis copyWithZone:zone];
    news.synopsisImage = [self.synopsisImage copy];
    news.synopsisImagePath = [self.synopsisImagePath copyWithZone:zone];
    news.content = [self.content copyWithZone:zone];
    news.date = [self.date copyWithZone:zone];
    news.top = self.top;
    news.department = [self.department copyWithZone:zone];
    news.subtitle = [self.subtitle copyWithZone:zone];
    news.newsFrom = [self.newsFrom copyWithZone:zone];
    return news;
}
@end
