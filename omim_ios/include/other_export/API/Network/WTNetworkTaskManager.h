//
//  WTNetworkTaskManager.h
//  omimIOSAPI
//
//  Created by coca on 2012/12/12.
//  Copyright (c) 2012年 coca. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTNetworkTask;
@class ChatMessage;
@interface WTNetworkTaskManager : NSObject

@property (nonatomic,retain) NSMutableDictionary* queue;

+(WTNetworkTaskManager*) defaultManager;

/*
 method to get the networktask with the unique key
 
 * @param key, unique key to get the task
 */
-(WTNetworkTask*)networkTaskWithKey:(NSString*)key;

/*
 method to check whether networktask is running.
 */
-(BOOL)isNetworkTaskManagerRunning;

-(WTNetworkTask*) taskforMessage:(ChatMessage*)msg;

// normally no need to call the following two functions. SDK takes care of all.
-(void)run;   // start to run the manager
-(void)finish;  // terminate the manager when no task is running.
- (void)cleanQueue;
//-(void)pause;
@end
