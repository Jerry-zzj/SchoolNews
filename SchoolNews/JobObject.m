//
//  JobObject.m
//  SchoolNews
//
//  Created by Jerry on 4月10星期三.
//
//

#import "JobObject.h"

#define ID_KEY                          @"ID"
#define TYPE_KEY                        @"Type"
#define TITLE_KEY                       @"Title"
#define CONTENT_KEY                     @"Content"
#define DATE_KEY                        @"Date"
#define RELEASE_KEY                     @"Release"
#define COMPANY_KEY                     @"Company"
#define INDUSTRY_KEY                    @"Industry"
#define COMPANY_NATURE_KEY              @"CompanyNature"
#define COMPANY_TYPE_KEY                @"CompanyType"
#define COMPANY_INTRODUCTION_KEY        @"CompanyIntroduction"
#define COMPANY_ADD_KEY                 @"CompanyAdd"
#define COMPANY_CONTACT_KEY             @"CompanyContact"
#define CONTACT_PHONE_KEY               @"ContactPhone"
#define JOB_KEY                         @"Job"

@implementation JobObject
@synthesize ID;
@synthesize type;
@synthesize title;
@synthesize content;
@synthesize date;
@synthesize releasePerson;
@synthesize company;
@synthesize industry;
@synthesize companyNature;
@synthesize companyType;
@synthesize companyIntroduction;
@synthesize companyAdd;
@synthesize companyContact;
@synthesize contactPhone;
@synthesize job;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:ID_KEY];
        self.type = [aDecoder decodeObjectForKey:TYPE_KEY];
        self.title = [aDecoder decodeObjectForKey:TITLE_KEY];
        self.content = [aDecoder decodeObjectForKey:CONTENT_KEY];
        self.date = [aDecoder decodeObjectForKey:DATE_KEY];
        self.releasePerson = [aDecoder decodeObjectForKey:RELEASE_KEY];
        self.company = [aDecoder decodeObjectForKey:COMPANY_KEY];
        self.industry = [aDecoder decodeObjectForKey:INDUSTRY_KEY];
        self.companyNature = [aDecoder decodeObjectForKey:COMPANY_NATURE_KEY];
        self.companyType = [aDecoder decodeObjectForKey:COMPANY_TYPE_KEY];
        self.companyIntroduction = [aDecoder decodeObjectForKey:COMPANY_INTRODUCTION_KEY];
        self.companyAdd = [aDecoder decodeObjectForKey:COMPANY_ADD_KEY];
        self.companyContact = [aDecoder decodeObjectForKey:COMPANY_CONTACT_KEY];
        self.contactPhone = [aDecoder decodeObjectForKey:CONTACT_PHONE_KEY];
        self.job = [aDecoder decodeObjectForKey:JOB_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:ID forKey:ID_KEY];
    [aCoder encodeObject:type forKey:TYPE_KEY];
    [aCoder encodeObject:title forKey:TITLE_KEY];
    [aCoder encodeObject:content forKey:CONTENT_KEY];
    [aCoder encodeObject:date forKey:DATE_KEY];
    [aCoder encodeObject:releasePerson forKey:RELEASE_KEY];
    [aCoder encodeObject:company forKey:COMPANY_KEY];
    [aCoder encodeObject:industry forKey:INDUSTRY_KEY];
    [aCoder encodeObject:companyNature forKey:COMPANY_NATURE_KEY];
    [aCoder encodeObject:companyType forKey:COMPANY_TYPE_KEY];
    [aCoder encodeObject:companyIntroduction forKey:COMPANY_INTRODUCTION_KEY];
    [aCoder encodeObject:companyAdd forKey:COMPANY_ADD_KEY];
    [aCoder encodeObject:companyContact forKey:COMPANY_CONTACT_KEY];
    [aCoder encodeObject:contactPhone forKey:CONTACT_PHONE_KEY];
    [aCoder encodeObject:job forKey:JOB_KEY];
}

- (id )copyWithZone:(NSZone *)zone
{
    JobObject* theJob = [[JobObject alloc] init];
    theJob.ID = [self.ID copyWithZone:zone];
    theJob.type = [self.type copyWithZone:zone];
    theJob.title = [self.title copyWithZone:zone];
    theJob.content = [self.content copyWithZone:zone];
    theJob.date = [self.date copyWithZone:zone];
    theJob.releasePerson = [self.releasePerson copyWithZone:zone];
    theJob.company = [self.ID copyWithZone:zone];
    theJob.industry = [self.industry copyWithZone:zone];
    theJob.companyNature = [self.companyNature copyWithZone:zone];
    theJob.companyType = [self.companyType copyWithZone:zone];
    theJob.companyIntroduction = [self.companyIntroduction copyWithZone:zone];
    theJob.companyAdd = [self.companyAdd copyWithZone:zone];
    theJob.contactPhone = [self.contactPhone copyWithZone:zone];
    theJob.job = [self.job copyWithZone:zone];
    return theJob;
}

- (void)absorbTheJob:(JobObject* )sender
{
    if (sender.type != nil) {
        self.type = sender.type;
    }
    if (sender.title != nil) {
        self.title = sender.title;
    }
    if (sender.content != nil) {
        self.content = sender.content;
    }
    if (sender.date != nil) {
        self.date = sender.date;
    }
    if (sender.releasePerson != nil) {
        self.releasePerson = sender.releasePerson;
    }
    if(sender.company != nil)
    {
        self.company = sender.company;
    }
    if(sender.industry != nil)
    {
        self.industry = sender.industry;
    }
    if(sender.companyNature != nil)
    {
        self.companyNature = sender.companyNature;
    }
    if(sender.companyType != nil)
    {
        self.companyType = sender.companyType;
    }
    if(sender.companyIntroduction != nil)
    {
        self.companyIntroduction = sender.companyIntroduction;
    }
    if(sender.companyAdd != nil)
    {
        self.companyAdd = sender.companyAdd;
    }
    if (sender.companyContact != nil) {
        self.companyContact = sender.companyContact;
    }
    if(sender.contactPhone != nil)
    {
        self.contactPhone = sender.contactPhone;
    }
    if(sender.job != nil)
    {
        self.job = sender.job;
    }
}
@end
