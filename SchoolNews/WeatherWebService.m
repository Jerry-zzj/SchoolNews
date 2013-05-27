//
//  WeatherWebService.m
//  SchoolNews
//
//  Created by Jerry on 3月23星期六.
//
//

#import "WeatherWebService.h"

@implementation WeatherWebService
@synthesize delegate;
WeatherWebService* g_WeatherWebService;
+ (id)singleton
{
    if (g_WeatherWebService == nil) {
        g_WeatherWebService = [[WeatherWebService alloc] init];
    }
    return g_WeatherWebService;
}

//模板方法
//处理webservice收到的数据
- (id)doHandleTheData:(NSString *)data
{
    NSDictionary* dictionary;
    @try {
        dictionary = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:NSJSONReadingMutableLeaves
                                                                     error:nil];
        //return dictionary;
    }
    @catch (NSException *exception) {
        NSLog(@"处理数据失败：%@",exception);
    }
    @finally {
        return dictionary;
    }
} 

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    [self.delegate getWeatherInformation:object];
}
@end
