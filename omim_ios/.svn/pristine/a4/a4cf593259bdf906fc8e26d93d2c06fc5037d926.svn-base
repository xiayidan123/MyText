//
//  Communicator_GetActiveAppType.m
//  omimLibrary
//
//  Created by Coca on 10/25/12.
//
//

#import "Communicator_GetActiveAppType.h"
#import "GlobalSetting.h"

@implementation Communicator_GetActiveAppType

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo != NO_ERROR)
        [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    else
    {
        NSMutableDictionary *dict = [result objectForKey:XML_BODY_NAME];
        if (!dict || [dict objectForKey:XML_GET_APPTYPE_KEY] == nil){
            errNo = NECCESSARY_DATA_NOT_RETURNED;
            [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        }
        else{
            NSMutableDictionary *apptypedict = [dict objectForKey:XML_GET_APPTYPE_KEY];
           [self networkTaskDidFinishWithReturningData:[apptypedict objectForKey:XML_APPTYPE_KEY] error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        }
    }
}

@end