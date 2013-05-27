//
//  WeatherWebService.h
//  SchoolNews
//
//  Created by Jerry on 3月23星期六.
//
//

#import "WebService.h"
@protocol WeatherWebServiceDelegate<NSObject>

- (void)getWeatherInformation:(id)sender;

@end
@interface WeatherWebService : WebService
@property (nonatomic,assign)id<WeatherWebServiceDelegate> delegate;
@end
