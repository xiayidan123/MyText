//
//  WTNetworkTaskManager.m
//  omimIOSAPI
//
//  Created by coca on 2012/12/12.
//  Copyright (c) 2012年 coca. All rights reserved.
//

#import "WTNetworkTaskManager.h"
#import "WTNetworkTask.h"
#import "WTNetworkTaskConstant.h"
#import "ChatMessage.h"
@interface WTNetworkTaskManager ()

@property   BOOL isrunning;

@end


@implementation WTNetworkTaskManager
@synthesize queue = _queue;
@synthesize isrunning = _isrunning;

// the instance of this class is stored here
static WTNetworkTaskManager *myInstance = nil;

+ (WTNetworkTaskManager *)defaultManager
{
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}

-(WTNetworkTask*)networkTaskWithKey:(NSString*)key
{
    return (WTNetworkTask*)[self.queue objectForKey:key];
}

#pragma mark - check the task related to the msg
-(WTNetworkTask*) taskforMessage:(ChatMessage*)msg
{
    
    if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]]) {
        NSString* key = [WT_UPLOAD_MEDIAMESSAGE_ORIGINAL stringByAppendingFormat:@"%zi",msg.primaryKey];
        WTNetworkTask* task = [[WTNetworkTaskManager defaultManager] networkTaskWithKey:key];
        return task;
    }
    else{
        NSString* key = [WT_DOWNLOAD_MEDIAMESSAGE_ORIGINAL stringByAppendingFormat:@"%zi",msg.primaryKey];
        WTNetworkTask* task = [[WTNetworkTaskManager defaultManager] networkTaskWithKey:key];
        return task;
    }
}

-(BOOL)isNetworkTaskManagerRunning
{
    return self.isrunning;
}

-(void)cleanQueue{
    [self.queue removeAllObjects];
}
-(void)run
{
    if (!self.isrunning) {
        self.queue = [[[NSMutableDictionary alloc] init] autorelease];
        self.isrunning = TRUE;
    }
   
}

-(void)finish
{
    if (self.queue != nil) {
        NSArray* tasks = [self.queue allValues];
        for (int i = 0; i< [tasks count]; i++) {
        WTNetworkTask* task = (WTNetworkTask*)[tasks objectAtIndex:i];
        [task finish];
        }
        if ([self.queue count] != 0) {
        [self.queue removeAllObjects];
        }
    }
    
    self.queue = nil;
    self.isrunning = FALSE;
    if (myInstance!=nil) {
        [myInstance release];
        myInstance = nil;
    }
  //  [self autorelease];
}
/*
-(void)pause
{
    
    NSArray* tasks = [self.queue allValues];
    for (int i = 0; i< [tasks count]; i++) {
        WTNetworkTask* task = (WTNetworkTask*)[tasks objectAtIndex:i];
        [task pause];
    }
}
*/
-(void)dealloc
{
    self.queue = nil;
    [super dealloc];
}

@end