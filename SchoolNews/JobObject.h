//
//  JobObject.h
//  SchoolNews
//
//  Created by Jerry on 4月10星期三.
//
//

#import <Foundation/Foundation.h>

@interface JobObject : NSObject<NSCoding,NSCopying>

@property (nonatomic,retain) NSString* ID;
@property (nonatomic,retain) NSString* type;
@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* content;
@property (nonatomic,retain) NSDate* date;
@property (nonatomic,retain) NSString* releasePerson;
@property (nonatomic,retain) NSString* company;
@property (nonatomic,retain) NSString* industry;
@property (nonatomic,retain) NSString* companyNature;
@property (nonatomic,retain) NSString* companyType;
@property (nonatomic,retain) NSString* companyIntroduction;
@property (nonatomic,retain) NSString* companyAdd;
@property (nonatomic,retain) NSString* companyContact;
@property (nonatomic,retain) NSString* contactPhone;
@property (nonatomic,retain) NSDictionary* job;
/*@property (nonatomic,retain) NSString* jobName;
@property (nonatomic,retain) NSString* needPersonCount;
@property (nonatomic,retain) NSString* jobType;
@property (nonatomic,retain) NSString* employType;
@property (nonatomic,retain) NSString* salary;
@property (nonatomic,retain) NSString* endDate;*/

- (void)absorbTheJob:(JobObject* )sender;
@end
