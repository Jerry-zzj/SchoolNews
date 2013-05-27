//
//  XMLAnalyze.m
//  SchoolNews
//
//  Created by Jerry on 5月20星期一.
//
//

#import "XMLAnalyze.h"
#import "NewsObject.h"
#import "AboutTime.h"
@implementation XMLAnalyze
+ (id )analyzeXML:(NSString* )xmlSender
{
    NSMutableString* correctXML = [NSMutableString stringWithString:xmlSender];
    [correctXML replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, correctXML.length)];
    [correctXML replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, correctXML.length)];
    return correctXML;
}
@end
