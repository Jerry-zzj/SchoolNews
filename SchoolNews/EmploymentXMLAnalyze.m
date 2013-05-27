//
//  EmploymentXMLAnalyze.m
//  SchoolNews
//
//  Created by Jerry on 5月22星期三.
//
//

#import "EmploymentXMLAnalyze.h"
#import "JobObject.h"
#import "GDataXMLNode.h"
#import "GDataDefines.h"
#import "AboutTime.h"

@implementation EmploymentXMLAnalyze

+ (id)analyzeXML:(NSString *)xmlSender
{
    NSString* data = [super analyzeXML:xmlSender];
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                     options:0
                                                                       error:nil];
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* temp = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSArray* jobs = [temp elementsForName:@"JobSynopsis"];
    if ([jobs count] == 0) {
        jobs = [temp elementsForName:@"Job"];
    }
    if ([jobs count] == 0) {
        jobs = [temp elementsForName:@"ReproducedEmployment"];
    }
    NSMutableArray* tempInformation = [NSMutableArray array];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (GDataXMLElement* element in jobs) {
        JobObject* job = [[JobObject alloc] init];
        
        //ID
        GDataXMLElement* idElement = [[element elementsForName:@"ID"] objectAtIndex:0];
        NSString* ID = [idElement stringValue];
        job.ID = ID;
        
        //标题
        GDataXMLElement* titleElement = [[element elementsForName:@"Title"]
                                         objectAtIndex:0];
        NSString* title = [titleElement stringValue];
        job.title = title;
        
        //日期
        GDataXMLElement* dateElement = [[element elementsForName:@"Date"]
                                        objectAtIndex:0];
        NSString* dateString = [dateElement stringValue];
        NSDate* date = [[AboutTime singleton] getDateFromString:dateString];
        job.date = date;
        
        //发布部门
        GDataXMLElement* releasePersonElement = [[element elementsForName:@"ReleasePerson"]
                                                 objectAtIndex:0];
        NSString* releasePerson = [releasePersonElement stringValue];
        job.releasePerson = releasePerson;
        
        //公司名称
        GDataXMLElement* companyElement = [[element elementsForName:@"Company"]
                                           objectAtIndex:0];
        NSString* company = [companyElement stringValue];
        job.company = company;
        
        //行业
        GDataXMLElement* industryElement = [[element elementsForName:@"Industry"]
                                            objectAtIndex:0];
        NSString* industry = [industryElement stringValue];
        job.industry = industry;
        
        //公司性质
        GDataXMLElement* companyNatureElement = [[element elementsForName:@"CompanyNature"]
                                                 objectAtIndex:0];
        NSString* companyNature = [companyNatureElement stringValue];
        job.companyNature = companyNature;
        
        //机构类型
        GDataXMLElement* companyTypeElement = [[element elementsForName:@"CompanyType"] objectAtIndex:0];
        NSString* companyType = [companyTypeElement stringValue];
        job.companyType = companyType;
        
        //公司介绍
        GDataXMLElement* companyIntroductionElement = [[element elementsForName:@"CompanyIntroduction"] objectAtIndex:0];
        NSString* companyIntroduction = [companyIntroductionElement stringValue];
        job.companyIntroduction = companyIntroduction;
        
        //公司地址
        GDataXMLElement* companyAddElement = [[element elementsForName:@"CompanyAdd"] objectAtIndex:0];
        NSString* companyAdd = [companyAddElement stringValue];
        job.companyAdd = companyAdd;
        
        //公司联系人
        GDataXMLElement* companyContactElement = [[element elementsForName:@"CompanyContact"] objectAtIndex:0];
        NSString* companyContact = [companyContactElement stringValue];
        job.companyContact = companyContact;
        
        //联系电话
        GDataXMLElement* contactPhoneElement = [[element elementsForName:@"ContactPhone"] objectAtIndex:0];
        NSString* contactPhone = [contactPhoneElement stringValue];
        job.contactPhone = contactPhone;
        
        //若不是列表才会有一下内容
        //工作名称
        NSMutableDictionary* tempDictionary = [NSMutableDictionary dictionary];
        GDataXMLElement* jobNameElement = [[element elementsForName:@"JobName"] objectAtIndex:0];
        NSString* jobName = [jobNameElement stringValue];
        if (jobName != nil) {
            [tempDictionary setObject:jobName forKey:@"职位名称"];
        }
        //所需人数
        GDataXMLElement* needPersonElement = [[element elementsForName:@"NeedPersonCount"] objectAtIndex:0];
        NSString* needPersonCount = [needPersonElement stringValue];
        if (needPersonElement != nil) {
            [tempDictionary setObject:needPersonCount forKey:@"需求人数"];
        }
        //工作类型
        GDataXMLElement* jobTypeElement = [[element elementsForName:@"JobType"] objectAtIndex:0];
        NSString* jobType = [jobTypeElement stringValue];
        if (jobType != nil) {
            [tempDictionary setObject:jobType forKey:@"工作类型"];
        }
        //聘用方式
        GDataXMLElement* employmentTypeElement = [[element elementsForName:@"EmployType"] objectAtIndex:0];
        NSString* employmentType = [employmentTypeElement stringValue];
        if (employmentType != nil) {
            [tempDictionary setObject:employmentType forKey:@"聘用方式"];
        }
        //薪水
        GDataXMLElement* salaryElement = [[element elementsForName:@"Salary"] objectAtIndex:0];
        NSString* salary = [salaryElement stringValue];
        if (salary != nil) {
            [tempDictionary setObject:salary forKey:@"薪水"];
        }
        //截止日期
        GDataXMLElement* endDateElement = [[element elementsForName:@"EndDate"] objectAtIndex:0];
        NSString* endDate = [endDateElement stringValue];
        if (endDate != nil) {
            [tempDictionary setObject:endDate forKey:@"截止日期"];
        }
        //将工作加到工作数组中
        if ([tempInformation count] == 0) {
            if ([tempDictionary count] > 0) {
                [dictionary setObject:tempDictionary forKey:jobName];
            }
            [tempInformation addObject:job];
            continue;
        }
        for (JobObject* object in tempInformation) {
            if ([object.ID isEqualToString:job.ID]) {
                [dictionary setObject:tempDictionary forKey:jobName];
                continue;
            }
            else
            {
                [tempInformation addObject:job];
                break;
            }
        }
    }
    if ([tempInformation count] == 1) {
        if ([dictionary count] > 0) {
            JobObject* job = [tempInformation objectAtIndex:0];
            job.job = dictionary;
        }
    }
    return tempInformation;
}

@end
