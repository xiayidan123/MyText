//
//  Scheduler.m
//  omim
//
//  Created by elvis on 2013/05/29.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Scheduler.h"
#import "WTHeader.h"

@implementation Scheduler


+(Scheduler*)sharedScheduler
{
    @synchronized(self)
    {
        static Scheduler *scheduler = nil;
        
        if (scheduler == nil)
        {
            scheduler = [[Scheduler alloc] init];
        }
        
        return scheduler;
    }
}

-(void)start
{
    timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(checkUpdate) userInfo:nil repeats:TRUE];
    [timer fire];
}

-(void)checkUpdate
{
    [WowTalkWebServerIF getLatestReplyForMeWithCallback:@selector(didGetLatestReplyForMe:) withObserver:nil];
}

-(void)stop
{
    if ([timer isValid]) {
        [timer invalidate];
        [timer release];
     }
    
    [self autorelease];
}


@end
