//
//  MeetWebService.h
//  SchoolNews
//
//  Created by Jerry on 12月28星期五.
//
//

#import "WebService.h"
#define MEET_END_UPDATE_WITH_WEBSERVICE              @"MeetEndUpdate"
@protocol MeetWebServiceDelegate<NSObject>

- (void)finishGetMeetData:(id)sender;

@end
@interface MeetWebService : WebService
@property(nonatomic,assign)id<MeetWebServiceDelegate> delegate;
@end
