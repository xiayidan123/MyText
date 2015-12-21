//
//  Communicator_GetVideoCallUnsupportedDeviceList.m
//  omimLibrary
//
//  Created by Yi Chen on 6/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetVideoCallUnsupportedDeviceList.h"
#import "Database.h"
#import "GlobalSetting.h"

@implementation Communicator_GetVideoCallUnsupportedDeviceList

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        if (bodydict == nil || [bodydict objectForKey:XML_GET_NOVIDEOCALL_DEVICES_KEY] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        else{
            NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
            NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_NOVIDEOCALL_DEVICES_KEY];
            if ([[infodict objectForKey:XML_DEVICE_NUMBER_KEY] isKindOfClass:[NSMutableString class]])
                [deviceArray addObject:[infodict objectForKey:XML_DEVICE_NUMBER_KEY]];
            else if ([[infodict objectForKey:XML_DEVICE_NUMBER_KEY] isKindOfClass:[NSMutableArray class]])
                [deviceArray addObjectsFromArray:[infodict objectForKey:XML_DEVICE_NUMBER_KEY]];
            
            [Database deleteAllVideoCallUnsupportedDevices];
            [Database storeVideoCallUnsupportedDevices:deviceArray];
            [deviceArray release];
        }
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end