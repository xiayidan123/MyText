//
//  Communicator_AccountDeactive.m
//  omimLibrary
//
//  Created by Yi Chen on 5/30/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_AccountDeactive.h"
#import "Database.h"
#import "WowTalkVoipIF.h"
#import "GlobalSetting.h"
#import "WTUserDefaults.h"

@implementation Communicator_AccountDeactive

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    [WowTalkVoipIF fWowTalkServiceEnterBackgroundMode];
    
    //TODO: delete local values
    
    /*        server_version
     ios_client_version
     MY_STATUS
     MY_NICKNAME
     MY_BIRTHDAY
     MY_SEX
     MY_AREA
     add_buddy_automatically
     people_can_add_me
     unknown_buddy_can_call_me
     unknown_buddy_can_message_me
     push_show_detail_flag
     DEMO_MODE_CODE
     MY_STATUS
     MY_NICKNAME
     MY_BIRTHDAY
     MY_SEX
     MY_AREA
     
     
     video_available
     
     countrycode_preference
     username_preference
     domain_preference
     uid_preference
     password_preference
     time_offset*/
    [WTUserDefaults removeUserDefaults];
    
    if([WTUserDefaults getUserDefaults]){
        // if(PRINT_LOG)NSLog(@"this doesnt work");
    }
    
    [Database dropAllTables:NO];
    [Database teardown];
    
    int errNo;
    
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
  
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];

}

@end