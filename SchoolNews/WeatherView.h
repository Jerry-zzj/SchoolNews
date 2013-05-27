//
//  WeatherView.h
//  SchoolNews
//
//  Created by Jerry on 3月22星期五.
//
//

#import <UIKit/UIKit.h>
#import "WeatherWebService.h"
@interface WeatherView : UIView<WeatherWebServiceDelegate>
{
    UILabel* cityLabel_;
    UILabel* temperatureLabel_;
    UILabel* weatherState_;
}

+ (WeatherView* )singleton;
@end
