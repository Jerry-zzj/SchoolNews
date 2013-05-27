#import "NSString-RemoveSuperfluousString.h"
#import "RegexKitLite.h"
@implementation NSString (RemoveSuperfluousString)

- (NSString* )removeSuperfluousStringForDepartment
{
    NSString* regex = @"[a-z|A-Z|0-9|_|-]{0,10}";
    NSString* regexString = [self stringByMatching:regex];
    NSString* correctString = [self stringByReplacingOccurrencesOfString:regexString withString:@""];
    return correctString;
}

- (NSString* )removeNullNumber
{
    if ([self isEqualToString:@"null"]) {
        return nil;
    }
    return self;
}

- (BOOL)judgeAllNumber
{
    NSString* regex = @"[0-9]{0,15}";
    NSString* regexString = [self stringByMatching:regex];
    if ([self isEqualToString:regexString]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)juedgeTheNumberIsPhoneNumber
{
    NSString* longNumberRegex = @"[0-9]{11,12}";
    NSString* longRegexMatchString = [self stringByMatching:longNumberRegex];
    if ([longRegexMatchString isEqualToString:self]) {
        return YES;
    }
    
    NSString* shortNumberrRegex = @"[0-9]{6,8}";
    NSString* shortRegexMatchString = [self stringByMatching:shortNumberrRegex];
    if ([shortRegexMatchString isEqualToString:self]) {
        return YES;
    }
    return NO;
}
@end