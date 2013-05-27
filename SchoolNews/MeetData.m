//
//  MeetData.m
//  SchoolNews
//
//  Created by Jerry on 1月10星期四.
//
//

#import "MeetData.h"
#import "MeetBuffer.h"
#import "MeetObject.h"
@interface MeetData(private)

- (void)getDataFromBuffer;
- (void)addMeet:(NSNotification* )sender;
- (void )addMeet:(MeetObject* )meet ForWeek:(int )week Weekday:(int )weekday;

@end
@implementation MeetData
@synthesize meetDictionary;
@synthesize style = style_;
MeetData* g_MeetData;
+ (MeetData* )singleton
{
    if (g_MeetData == nil) {
        g_MeetData = [[MeetData alloc] init];
    }
    return g_MeetData;
}

- (id)init
{
    self = [super init];
    if (self) {
        style_ = All;
        [self getDataFromBuffer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addMeet:)
                                                     name:@"AddAMeet"
                                                   object:nil];
        
    }
    return self;
}

- (NSArray* )getMeetForWeek:(int )week Weekday:(int )weekday
{
    NSString* meetKey;
    switch (style_) {
        case All:
            meetKey = [NSString stringWithFormat:@"All_%i_%i",week,weekday];
            break;
        case Person:
            meetKey = [NSString stringWithFormat:@"Person_%i_%i",week,weekday];
            break;
        default:
            break;
    }
    NSArray* meets = [self.meetDictionary objectForKey:meetKey];
    return meets;
}

- (void )addMeets:(NSArray* )meets ForWeek:(int )week Weekday:(int )weekday
{
    NSString* meetKey;
    switch (style_) {
        case All:
            meetKey = [NSString stringWithFormat:@"All_%i_%i",week,weekday];
            break;
        case Person:
            meetKey = [NSString stringWithFormat:@"Person_%i_%i",week,weekday];
            break;
        default:
            break;
    }
    if (meets != nil && [meets count] > 0) {
        [self.meetDictionary setObject:meets forKey:meetKey];
    }
    else
    {
        [self.meetDictionary removeObjectForKey:meetKey];
    }
    //[self.delegate meetDataChanged:self.meetDictionary];
}

- (MeetObject* )getMeetForID:(NSString* )IDSender AndWeek:(int )weekSender AndWeekday:(int )weekday
{
    NSString* meetKey;
    switch (style_) {
        case All:
            meetKey = [NSString stringWithFormat:@"All_%i_%i",weekSender,weekday];
            break;
        case Person:
            meetKey = [NSString stringWithFormat:@"Person_%i_%i",weekSender,weekday];
            break;
        default:
            break;
    }
    NSArray* meets = [self.meetDictionary objectForKey:meetKey];
    for (MeetObject* meet in meets) {
        if ([meet.ID isEqualToString:IDSender]) {
            return meet;
        }
    }
    return nil;
}

#pragma mark private
- (void)getDataFromBuffer
{
    NSArray* meetsArray = [[MeetBuffer singleton] getDataInBufferWithIdentifier:@"Meet"];
    NSMutableDictionary* tempMeetDictionary = [NSMutableDictionary dictionary];
    if ([meetsArray count] > 0) {
        for (MeetObject* object in meetsArray) {
            NSDate* date = object.date;
            if ([[tempMeetDictionary allKeys] containsObject:date]) {
                NSMutableArray* meets = [tempMeetDictionary objectForKey:date];
                [meets addObject:object];
            }
            else
            {
                NSMutableArray* meets = [NSMutableArray array];
                [meets addObject:object];
                [tempMeetDictionary setObject:meets forKey:date];
            }
        }
    }
    self.meetDictionary = tempMeetDictionary;
}

- (void)addMeet:(NSNotification* )sender
{
    NSDictionary* notificationObject = [sender object];
    NSNumber* weekNumber = [notificationObject objectForKey:@"week"];
    NSNumber* weekdayNumber = [notificationObject objectForKey:@"weekday"];
    
    int week = [weekNumber intValue];
    int weekday = [weekdayNumber intValue];
    MeetObject* meet = [notificationObject objectForKey:@"meet"];
    [self addMeet:meet ForWeek:week Weekday:weekday];
}

- (void )addMeet:(MeetObject* )meet ForWeek:(int )week Weekday:(int )weekday
{
    NSString* meetKey;
    switch (style_) {
        case All:
            meetKey = [NSString stringWithFormat:@"All_%i_%i",week,weekday];
            break;
        case Person:
            meetKey = [NSString stringWithFormat:@"Person_%i_%i",week,weekday];
            break;
        default:
            break;
    }
    NSArray* meets = [self.meetDictionary objectForKey:meetKey];
    NSMutableArray* tempMeets = [NSMutableArray arrayWithArray:meets];
    MeetObject* sameIDMeet;
    for (MeetObject* meetObject in tempMeets) {
        if ([meetObject.ID isEqualToString:meet.ID]) {
            sameIDMeet = meetObject;
            break;
        }
    }
    if (sameIDMeet != nil) {
        [tempMeets removeObject:sameIDMeet];
    }
    [tempMeets addObject:meet];
    [self.meetDictionary setObject:tempMeets forKey:meetKey];
}
@end
