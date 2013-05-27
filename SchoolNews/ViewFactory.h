//
//  ViewFactory.h
//  SchoolNews
//
//  Created by Jerry on 1月30星期三.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class IpadProducer;
@class Iphone4Producer;
@class Iphone5Producer;
@interface ViewFactory : NSObject
{
    IpadProducer* ipadProducer_;
    Iphone4Producer* iphone4Producer_;
    Iphone5Producer* iphone5Producer_;
}

+ (ViewFactory* )singleton;

- (id)produceViewWithIdentifier:(NSString* )sender;
@end
