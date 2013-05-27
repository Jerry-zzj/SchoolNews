//
//  MeetShowWebService.h
//  SchoolNews
//
//  Created by Jerry on 1月11星期五.
//
//

#import "WebService.h"
@protocol MeetShowWebServiceDelegate <NSObject>

- (void)loadTheMeet:(id)sender;

@end
@interface MeetShowWebService : WebService
@property (nonatomic,assign)id<MeetShowWebServiceDelegate> delegate;
@end
