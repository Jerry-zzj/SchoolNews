//
//  WebService.m
//  SchoolNews
//
//  Created by shuangchi on 12月13星期四.
//
//

#import "WebService.h"
#import "GDataXMLNode.h"
#import "NetWorkAlter.h"

#define TIME_OUT_SECONDS                         15
//---------------------------------------------------------------------------------------------------
@interface WebService()

- (void)doFinishGetTheWebServiceDataWithObject:(id)object;
- (id)doHandleTheData:(NSString* )data;
- (NSString* )correctTheXML:(NSString* )sender;
- (void)savetTheDataToBuffer:(id)sender;

@end
//---------------------------------------------------------------------------------------------------
@implementation WebService
+ (id)singleton
{
    return nil;
}
- (id)init
{
    self = [super init];
    if (self) {
        finished_ = NO;
    }
    return self;
}

- (void)setURLWithString:(NSString* )sender
{
    CFStringRef urlString =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)sender,
                                            NULL,
                                            NULL,
                                            kCFStringEncodingUTF8);

    url_ = [NSURL URLWithString:(__bridge NSString*)urlString];
}

- (void )getWebServiceData
{
    ASIHTTPRequest* request= [[ASIHTTPRequest alloc] initWithURL:url_];
    NSLog(@"%@",url_);
    [request setTimeOutSeconds:TIME_OUT_SECONDS];
    [request setDelegate:self];
    [request startAsynchronous];
    /*while(!finished_) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }*/
}

#pragma  mark AsihttpRequest Delegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"Start");
}

//请求完成
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* date = [request responseData];
    NSString* string = [[NSString alloc] initWithData:date encoding:NSUTF8StringEncoding];
    //NSString* string = [request responseData];
    //NSLog(@"%@",string);
    NSString* xml = [self correctTheXML:string];
    id object = [self doHandleTheData:xml];
    if (object != nil) {
        [self savetTheDataToBuffer:object];
        [self doFinishGetTheWebServiceDataWithObject:object];

    }
    finished_ = YES;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError* error = [request error];
    //NSLog(@"%@",[error domain]);
    if (error != nil) {
        [[NetWorkAlter singleton]showTheAlter];
    }
    [self doFinishGetTheWebServiceDataWithObject:nil];
}

//模板方法
//处理webservice收到的数据
- (id)doHandleTheData:(NSString *)data
{
    return nil;
}

//模板方法
//当接受完数据以后
- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    
}

- (NSString* )correctTheXML:(NSString* )sender
{
    if (sender != nil) {
        NSMutableString* temp = [NSMutableString stringWithString:sender];
        [temp replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, temp.length)];
        [temp replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, temp.length)];
        return temp;
    }
    return nil;
}

- (void)savetTheDataToBuffer:(id)sender
{
    
}
@end
