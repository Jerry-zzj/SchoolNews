//
//  NewsShowWebService.h
//  SchoolNews
//
//  Created by Jerry on 1月7星期一.
//
//

#import "WebService.h"

@protocol NewsShowWebServiceDelegate <NSObject>

- (void)loadTheNews:(id)sender;

@end

@interface NewsShowWebService : WebService
@property (nonatomic,assign)id<NewsShowWebServiceDelegate> delegate;
@end
