//
//  WeatherView.m
//  SchoolNews
//
//  Created by Jerry on 3月22星期五.
//
//

#import "WeatherView.h"
#import "WeatherWebService.h"
@interface WeatherView(privateAPI)

- (void)loadWeatherInformation;

@end

@implementation WeatherView
{
    UIActivityIndicatorView* activityView;
}
WeatherView* g_WeatherView;
+ (WeatherView* )singleton
{
    if (g_WeatherView == nil) {
        g_WeatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    }
    return g_WeatherView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        cityLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
        [cityLabel_ setNumberOfLines:3];
        [cityLabel_ setFont:[UIFont systemFontOfSize:12]];
        [cityLabel_ setTextColor:[UIColor whiteColor]];
        [cityLabel_ setBackgroundColor:[UIColor clearColor]];
        [cityLabel_ setText:@"杭州"];
        
        temperatureLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 60, 22)];
        [temperatureLabel_ setBackgroundColor:[UIColor clearColor]];
        [temperatureLabel_ setFont:[UIFont systemFontOfSize:12]];
        [temperatureLabel_ setTextColor:[UIColor whiteColor]];
        [temperatureLabel_ setText:@"18℃-10℃"];
        
        weatherState_ = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 60, 22)];
        [weatherState_ setBackgroundColor:[UIColor clearColor]];
        [weatherState_ setFont:[UIFont systemFontOfSize:8]];
        [weatherState_ setTextColor:[UIColor whiteColor]];
        [weatherState_ setText:@"阵雨转小到多雨"];
        
        [self addSubview:cityLabel_];
        [self addSubview:temperatureLabel_];
        [self addSubview:weatherState_];
        
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        [activityView startAnimating];
        [self loadWeatherInformation];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark WeatherWebService Delegate
- (void)getWeatherInformation:(id)sender
{
    NSDictionary* weatherInformation = [(NSDictionary* )sender objectForKey:@"weatherinfo"];
    NSString* city = [weatherInformation objectForKey:@"city"];
    [cityLabel_ setText:city];
    
    NSString* lowTemperature = [weatherInformation objectForKey:@"temp2"];
    NSString* highTemperature = [weatherInformation objectForKey:@"temp1"];
    NSString* temperature = [NSString stringWithFormat:@"%@-%@",highTemperature,lowTemperature];
    [temperatureLabel_ setText:temperature];
    
    NSString* weatherState = [weatherInformation objectForKey:@"weather"];
    [weatherState_ setText:weatherState];
    
    [activityView stopAnimating];
}

#pragma mark delegate
- (void)loadWeatherInformation
{
    WeatherWebService* weatherWebService = [WeatherWebService singleton];
    weatherWebService.delegate = self;
    NSString* urlString = [NSString stringWithFormat:@"http://www.weather.com.cn/data/cityinfo/101210101.html"];
    [weatherWebService setURLWithString:urlString];
    [weatherWebService getWebServiceData];
}

@end
