//
//  Scheduler.h
//  omim
//
//  Created by elvis on 2013/05/29.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scheduler : NSObject
{
    NSTimer* timer;
}

+(Scheduler*)sharedScheduler;

-(void)start;

-(void)stop;

@end
