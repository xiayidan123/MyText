//
//  WTNetworkTask.h
//  omimIOSAPI
//
//  Created by coca on 2012/12/11.
//  Copyright (c) 2012年 coca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WowtalkUIDelegates.h"
@class ASIHTTPRequest;

@interface WTNetworkTask : NSObject<NetworkIFDidFinishDelegate>

@property BOOL isDataTransferDone;

@property (nonatomic,retain) NSString* type;

@property (nonatomic,retain) NSString* key;                 /*< this is the unique key to idetify a task, a new task with a exsiting key can not run.*/
@property (nonatomic,retain) NSDictionary* taskdict;        /*< this dictionary contains required value for a specific network task. please refer to the comments in enum NETWORKTASKTYPE  */
@property (nonatomic,retain) NSDictionary* notifdict;       /*< this dictionary contains info which is intented to be used in the "selector". since a selector will at least
                                                             has a parameter (NSNotification*) notif, you can get the notifdict by the key WT_PASSED_IN_NOTIFDATA to the [notif userinfo],*/
@property (nonatomic,assign) id observer;
@property (nonatomic,retain) NSString* notificationName;

@property (nonatomic,retain) NSTimer* timer;                /*< this timer could be used to check the current task status*/

 /*< selector at least has a parameter (NSNotification*) notif. You can get notifdict (a NSDictionary object) by the key WT_PASSED_IN_NOTIFDATA in the [notif userinfo] and get error info (a NSError object) by the key WT_ERROR in the [notif userinfo]. Special cases: when a message is passed in the taskinfo, it is highly possible to be changed after the task is done, so the message is stored in the userinfo with the key WT_MESSAGE and posted back to the selector for future use.*/
@property (nonatomic) SEL selector;

@property (nonatomic,retain) ASIHTTPRequest* request;

-(id)initWithUniqueKey:(NSString*)key taskInfo:(NSDictionary*)tdict taskType:(NSString*)type notificationName:(NSString*)name notificationObserver:(id)observer userInfo:(NSDictionary*)ndict selector:(SEL)selector;


-(BOOL)start;
-(float)currentProgressForUploadTask;                    
-(float)currentProgressForDownloadTask;

-(void)finish;

//-(void)pause;    // not useful now. will write a restart function

-(BOOL) isTimerRunning;

@end
