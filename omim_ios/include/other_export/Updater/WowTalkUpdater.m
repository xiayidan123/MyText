//
//  omimUpdater.m
//  omimLibrary
//
//  Created by Yi Chen on 9/17/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "WowTalkUpdater.h"
#import "Communicator_UpdateUID.h"

@implementation WowTalkUpdater

+(BOOL) fUpdater_checkWhetherUIDNeedToUpdate{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"uid_preference"]==nil){
        return TRUE;
    } 
    
    return FALSE;
    
}


+ (void)fUpdater_updateUID_withNetworkIFDidFinishDelegate:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:@"update_uid" taskInfo:nil taskType:@"update_uid"  notificationName:@"update_uid"  notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* strPassword = [defaults objectForKey:@"password_preference"];
	NSString* strUserName= [defaults objectForKey: @"username_preference"];

    
    Communicator_UpdateUID *netIFCommunicator = [[Communicator_UpdateUID alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, @"phone_number", @"password", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:@"update_uid", strPassword, strUserName, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}






@end
