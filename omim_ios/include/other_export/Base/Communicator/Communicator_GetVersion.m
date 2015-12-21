//
//  Communicator_GetVersion.m
//  omim
//
//  Created by elvis on 2013/05/29.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetVersion.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation Communicator_GetVersion

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    if (errNo == NO_ERROR) {
        
        NSDictionary* dict = [[[result objectForKey:XML_BODY_NAME] objectForKey:WT_GET_VERSION] objectForKey:@"ios"];
        
        if (dict == nil) {
            [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
            return;
        }
        
        NSDictionary* log = [dict objectForKey:@"change_log"];
        
        NSString* oldVersion =  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];

        
        newVersion = [dict valueForKey:@"ver_name"];
        
        if(log&&oldVersion&&newVersion){
            oldVersion=[oldVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString* newVersion2=[newVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            
            
            //NSLog(@"oldver=%f",[oldVersion doubleValue]);
            //NSLog(@"newver=%f",[newVersion2 doubleValue]);
            
            BOOL needAlert = [[[NSUserDefaults standardUserDefaults] objectForKey:@"new_version_alert"] boolValue];
            if ([oldVersion doubleValue] < [newVersion2 doubleValue]) {
                
                NSInteger timestamp = [[NSUserDefaults standardUserDefaults] integerForKey:@"lasttimepopup"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NEW_VERSION_NOTIFICATION object:nil];
                // the first time.
                if (timestamp == 0) {
                    [self popupUpdateLog:log];
                }
                else{
                    
                    NSInteger currentTimestamp = (int)[[NSDate date] timeIntervalSince1970];
                    if (currentTimestamp -  timestamp > 60*60*24*7 || needAlert) {
                        [self popupUpdateLog:log];
                    }
                    
                }
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"new_version"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        }
    }
    
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


-(void)popupUpdateLog:(NSDictionary*)dict
{
    if (dict == nil) {
        return;
    }
    
    NSString* title = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"Software update",nil), newVersion];
    if ([[dict valueForKey:@"li"] isKindOfClass:[NSMutableArray class]]) {
        
        NSMutableArray* array = [dict valueForKey:@"li"];
        NSString* finalmsg = [array objectAtIndex:0];
        for (int i = 1; i< [array count]; i++) {
            NSString* msg = [array objectAtIndex:i];
            finalmsg = [finalmsg stringByAppendingFormat:@"\n%@",msg];
        }
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", finalmsg, @"message", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NEW_VERSION_ALERT_NOTIFICATION object:nil userInfo:dict];
        
    }
    else{
        NSString* finalmsg = [dict valueForKey:@"li"];
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", finalmsg, @"message", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NEW_VERSION_ALERT_NOTIFICATION object:nil userInfo:dict];
        
    }
    
}



@end
