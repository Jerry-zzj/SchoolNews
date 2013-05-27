//
//  RegisterWebService.m
//  SchoolNews
//
//  Created by Jerry on 3月8星期五.
//
//

#import "RegisterWebService.h"
#import "GDataXMLNode.h"

@implementation RegisterWebService
RegisterWebService* g_RegisterWebService;
+ (id)singleton
{
    if (g_RegisterWebService == nil) {
        g_RegisterWebService = [[RegisterWebService alloc] init];
    }
    return g_RegisterWebService;
}

- (id)doHandleTheData:(NSString* )data
{
    GDataXMLDocument* xmlDocument = [[GDataXMLDocument alloc] initWithXMLString:data
                                                                        options:0
                                                                          error:nil];
    GDataXMLElement* rootElement = [xmlDocument rootElement];
    GDataXMLElement* stateElement = [[rootElement elementsForName:@"ns:return"]
                             objectAtIndex:0];
    NSString* state = [stateElement stringValue];
    return state;
}

- (void)doFinishGetTheWebServiceDataWithObject:(id)object
{
    [self.delegate getRegisterState:object];
}
@end
