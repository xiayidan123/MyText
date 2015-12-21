//
//  MessageCenter.h
//  omim
//
//  Created by elvis on 2013/05/23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChatMessage;
@class MessagesVC;

@protocol WowTalkNotificationDelegate;

@interface MessageCenter : NSObject
{
   
    
}

@property (nonatomic,retain)  MessagesVC* messageListVC;
+(MessageCenter*)defaultCenter;


-(ChatMessage*)PreprocessMessage:(ChatMessage*)chatmessage;

-(BOOL)isSystemMessage:(ChatMessage*)msg;


@end
