//
//  OMMessageVC.h
//  dev01
//
//  Created by Huan on 15/4/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class ChatMessage;
@class Buddy;

@interface OMMessageVC : OMViewController
@property (assign, nonatomic) BOOL isTemporaryChatPop;
NSComparisonResult fSortChatMsgByDateDESC(ChatMessage* msg1, ChatMessage* msg2, void* context);

- (void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat;
- (void)createGroupChatRoom:(NSMutableArray*)buddys withGroupID:(NSString*)groupID;
- (void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat andViewController:(UIViewController *)onlineHome;
- (void)createGroupChatRoom:(NSMutableArray*)buddys withGroupID:(NSString*)groupID WithViewController:(UIViewController *)viewController;
- (void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat WithMessageContent:(NSString *)messageContent;
- (void)fRefetchTableData;
- (void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat WithNoPushMessageContent:(NSString *)messageContent;

@end
