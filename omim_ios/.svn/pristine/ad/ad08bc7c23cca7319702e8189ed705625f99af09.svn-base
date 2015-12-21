//
//  MessageCenter.m
//  omim
//
//  Created by elvis on 2013/05/23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "MessageCenter.h"
#import "WTHeader.h"
#import "AppDelegate.h"
#import "MessagesVC.h"
#import "Constants.h"
#import "TabBarViewController.h"
#import "WowtalkUIDelegates.h"
#import "MsgComposerVC.h"
#import "JSON.h"



@implementation MessageCenter
+(MessageCenter*)defaultCenter
{
    static  MessageCenter * center = nil;
    // check to see if an instance already exists
    if (nil == center) {
        center  = [[[self class] alloc] init];
        
        // initialize variables here
        center.messageListVC = [AppDelegate sharedAppDelegate].messagesViewController;
    }
    return center;
}

-(ChatMessage*)PreprocessMessage:(ChatMessage*)msg
{
    if (msg.messageContent == nil || [msg.messageContent isEqualToString:@""]) {
        return msg;
    }
    
    BOOL isInChatRoom = [self.messageListVC inChatRoom];
    
    NSString* currentgroupid = nil;
    
    if (isInChatRoom) {
        currentgroupid = [self.messageListVC currentChatroomID];
    }
    
    SBJsonWriter* jw = [[SBJsonWriter alloc] init];
    SBJsonParser* jp = [[SBJsonParser alloc] init];
    
    NSDictionary* dic = [jp fragmentWithString:msg.messageContent];
    if ([dic isKindOfClass:[NSDecimalNumber class]]) {
        return msg;
    }
    NSString* action = [dic objectForKey:@"action"];
    
    if ([msg.chatUserName isEqualToString:@"10000"]) {
        if ([action isEqualToString:@"friend_request_is_passed"]) {
            
            NSString* nickname = [dic valueForKey:@"nickname"];
            NSString* uid = [dic valueForKey:@"uid"];
            

            [WowTalkWebServerIF getBuddyWithUID:uid withCallback:@selector(didGetBuddy:) withObserver:self];
  
       
            // save this msg as system message and show.
            msg.messageContent = [NSString stringWithFormat:NSLocalizedString(@"%@ has passed your friend request",nil),nickname ];
            int oldkey = msg.primaryKey;
            
            // cancel 10000
//            msg.chatUserName = @"10000";
            msg.chatUserName = uid;
            msg.isGroupChatMessage = FALSE;
            msg.primaryKey =  [Database storeNewChatMessage:msg];
            
            // delete the old message.
            [Database deleteChatMessageByID:oldkey];
            
            if (self.messageListVC.isShowing) {
                [self.messageListVC fRefetchTableData];
            }
            
            [jw release];
            [jp release];
            return msg;
        
        }
        
    }
    
    // handle notification type message.
    if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM]]) {
        // disband the group
        if ([action isEqualToString:@"disband_group"]) {
            NSString* groupname = [dic valueForKey:@"group_name"];
            NSString* groupid = [dic valueForKey:@"group_id"];
            GroupChatRoom *group2disband=[Database getGroupChatRoomByGroupid:groupid];
            [Database deleteFixedGroupByID:groupid];
            [Database deleteChatMessageWithUser:groupid];
            
            NSString* dirname = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:msg.chatUserName];
            [NSFileManager removeAllTheFilesInDir:dirname];
            
            // save this msg as system message and show.
            if (nil != group2disband && group2disband.isTemporaryGroup) {
                msg.messageContent = [NSString stringWithFormat: NSLocalizedString(@"TmpGroup%@ is already dismissed",nil),@""];
            } else {
                msg.messageContent = [NSString stringWithFormat: NSLocalizedString(@"Group%@ is already dismissed",nil),groupname];
            }
            
            int oldkey = msg.primaryKey;
            
            msg.chatUserName = @"10000";
            msg.isGroupChatMessage = FALSE;
            msg.primaryKey =  [Database storeNewChatMessage:msg];
            
            // delete the old message.
            [Database deleteChatMessageByID:oldkey];
            
            // one is in that disbanded group chat room
            if ([msg.chatUserName isEqualToString:currentgroupid]) {
                // go back to the list.
                [self.messageListVC.msgComposer goBack];
                [self.messageListVC fRefetchTableData];
            }
            else{
                if (self.messageListVC.isShowing) {
                    [self.messageListVC fRefetchTableData];
                }
                
            }
        }
        // kick out
        else if([action isEqualToString:@"remove_from_group"]){
            
            NSString* groupname = [dic valueForKey:@"group_name"];
            NSString* groupid = [dic valueForKey:@"group_id"];
            NSString* buddyid = [dic valueForKey:@"buddy_id"];
            
            if ([buddyid isEqualToString:[WTUserDefaults getUid]]) {
                
                [Database deleteFixedGroupByID:groupid];
                [Database deleteChatMessageWithUser:groupid];
                NSString* dirname = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:msg.chatUserName];
                
                [NSFileManager removeAllTheFilesInDir:dirname];
                
                // save this msg as system message and show.
                msg.messageContent = [NSString stringWithFormat:NSLocalizedString(@"You have been removed from %@ by admin",nil),groupname ];
                
                int oldkey = msg.primaryKey;
                
                msg.chatUserName = @"10000";
                msg.isGroupChatMessage = FALSE;
                msg.primaryKey =  [Database storeNewChatMessage:msg];
                
                // delete the old message.
                [Database deleteChatMessageByID:oldkey];
                
                // one is removed from the group.
                if ([msg.chatUserName isEqualToString:currentgroupid]) {
                    [self.messageListVC.msgComposer goBack];
                    [self.messageListVC fRefetchTableData];
                }
                else{
                    if (self.messageListVC.isShowing) {
                        [self.messageListVC fRefetchTableData];
                    }
                }
            }
            else{
                NSString* buddynickname = [dic valueForKey:@"buddy_nickname"];
                msg.messageContent = [NSString stringWithFormat: NSLocalizedString(@"%@ has left this group",nil), buddynickname];
                [Database updateChatMessage:msg];
            }
        }
        
        else if([action isEqualToString:@"leave_user_group"]){
            NSString* buddynickname = [dic valueForKey:@"buddy_nickname"];
            msg.messageContent = [NSString stringWithFormat: NSLocalizedString(@"%@ has left this group",nil), buddynickname];
            [Database updateChatMessage:msg];
        }
        
        else if ([action isEqualToString:@"leave_temp_group"]){
            NSString* buddynickname = [dic valueForKey:@"buddy_nickname"];
            msg.messageContent = [NSString stringWithFormat: NSLocalizedString(@"%@ has left this chatroom",nil), buddynickname];
            [Database updateChatMessage:msg];
        }
        
        else if ([action isEqualToString:@"reject_join_group_request"]){
            NSString* groupname = [dic valueForKey:@"group_name"];
            // save this msg as system message and show.
            msg.messageContent = [NSString stringWithFormat: NSLocalizedString(@"Your application is not passed (%@)",nil),groupname];
            
            int oldkey = msg.primaryKey;
            
            msg.chatUserName = @"10000";
            msg.isGroupChatMessage = FALSE;
            msg.primaryKey =  [Database storeNewChatMessage:msg];
           
            // delete the old message.
            [Database deleteChatMessageByID:oldkey];
            
            if (self.messageListVC.isShowing) {
                [self.messageListVC fRefetchTableData];
            }
        }
        
        // handle reject join group
        else if ([action isEqualToString:@"reject_join_group"]) {
            NSString *groupName = [dic valueForKey:@"group_name"];
            msg.messageContent = [NSString stringWithFormat:NSLocalizedString(@"Your application is not passed (%@)", nil), groupName];
            int oldKey = msg.primaryKey;
            msg.chatUserName = @"10000";
            msg.isGroupChatMessage = NO;
            msg.primaryKey = [Database storeNewChatMessage:msg];
            // delete the old message
            [Database deleteChatMessageByID:oldKey];
            if (self.messageListVC.isShowing) {
                [self.messageListVC fRefetchTableData];
            }
        }
    }
    // someone is joinging the group
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM]]){
        // the request is passed.
        if ([action isEqualToString:@"authorized_join_group"] || [action isEqualToString:@"added_to_group"]) {
            
            NSString* buddyid = [dic valueForKey:@"buddy_id"];
            if ([buddyid isEqualToString:[WTUserDefaults getUid]]) {
                
                NSString* groupname = [dic valueForKey:@"group_name"];
                NSString* groupid = [dic valueForKey:@"group_id"];
     
                msg.messageContent = [NSString stringWithFormat:NSLocalizedString(@"You have joined%@",nil),groupname];
                [WowTalkWebServerIF getUserGroupDetail:groupid isCreator:FALSE withCallback:@selector(didGetGroupInfo:) withObserver:self];
                
                int oldkey = msg.primaryKey;
                
                msg.chatUserName = @"10000";
                msg.isGroupChatMessage = FALSE;
                msg.primaryKey =  [Database storeNewChatMessage:msg];
                
                // delete the old message.
                [Database deleteChatMessageByID:oldkey];
                
                if (self.messageListVC.isShowing) {
                    [self.messageListVC fRefetchTableData];
                }
            }
            else{
                NSString* buddynickname = [dic valueForKey:@"buddy_nickname"];
                if(buddynickname==nil){
                    [Database deleteChatMessage:msg];
                    
                    [jw release];
                    [jp release];
                    
                    return nil;
                }
                else{
                    msg.messageContent = [NSString stringWithFormat:@"%@%@", buddynickname, NSLocalizedString(@" joins this group", nil) ];
                    [Database updateChatMessage:msg];
                }
              
            }
        }
        
        else if ([action isEqualToString:@"added_to_temp_group"]){
            NSString* buddynickname = [dic valueForKey:@"buddy_nickname"];
            if([NSString isEmptyString:buddynickname]){
                [Database deleteChatMessage:msg];
                
                [jw release];
                [jp release];
                
                return nil;

            }
            else{
                msg.messageContent = [NSString stringWithFormat:@"%@%@", buddynickname, NSLocalizedString(@" join this chatroom", nil) ];
                [Database updateChatMessage:msg];
            }
           
        }
    }
      
    [jw release];
    [jp release];
    
    return msg;
}

-(BOOL)isSystemMessage:(ChatMessage*)msg
{
    if ([msg.chatUserName isEqualToString:@"10000"]) {
        return TRUE;
    }
    return FALSE;
    
}

-(void)getBuddyListDecreaseNotification:(NSString *)uid withDisplayName:(NSString *)displayName
{
    
}

-(void)getBuddyListIncreaseNotification:(NSString *)uid withDisplayName:(NSString *)displayName
{
    
}

-(void) getActiveAppTypeChangeNotification:(NSString*)app_type{
    
}

-(void)didGetGroupInfo:(NSNotification*)notif
{
   
}

-(void)didGetBuddy:(NSNotification*)notif
{
   
}

@end
