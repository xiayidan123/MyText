//
//  MessagesVC.h
//  omim
//
//  Created by Coca on 4/16/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WowtalkUIDelegates.h"
#import "WTOfficialMSGXMLDelegate.H"
#import "MsgComposerVC.h"
#import "OnlineHomeworkVC.h"
@class AVAudioPlayer;
@class ChatMessage;
@class Buddy;
@class SystemMessageViewController;

@interface MessagesVC : UIViewController<UIAlertViewDelegate,UIGestureRecognizerDelegate,WTOfficialMSGXMLDelegate, UISearchBarDelegate,UISearchDisplayDelegate>
{
	
   
 //   NSIndexPath * indexOfDeletingCell;
    BOOL inDeleteMode;
    
  //  BOOL inMessageComposerView;
    
    BOOL inEnterGroupChatRoomMode;
    NSString* currentSelectedGroupID;
    
    
    UIView* noChatsNoticeView;
    
    BOOL isInSystemMessageView;
   BOOL isSearchBarShown;
	
}


@property (nonatomic,retain) SystemMessageViewController* smvc;

@property BOOL inMessageComposerView;

@property BOOL isShowing;

@property (nonatomic,retain) NSIndexPath * indexOfDeletingCell;

@property  BOOL _isFromContactList;
@property (nonatomic,retain) IBOutlet UITableView* tb_messages;

@property (nonatomic,retain) UIButton* btn_addchat;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property(nonatomic,retain)	AVAudioPlayer* incomeMsgRingtonePlayer;


@property (nonatomic,retain) NSMutableArray* dataSource;
@property (nonatomic,retain) NSMutableArray* filtedDataSource;
@property (nonatomic,retain) NSCalendar *gregorian;
@property (nonatomic,retain) NSDate* today;
@property (nonatomic,retain) NSDate* sevenDaysAgo;

@property (nonatomic,retain) MsgComposerVC* msgComposer;

// by yangbin
@property (nonatomic,assign)BOOL isTemporaryChatPop;


-(NSString*)currentChatroomID;
-(BOOL)inChatRoom;

NSComparisonResult fSortChatMsgByDateDESC(ChatMessage* msg1, ChatMessage* msg2, void* context);

-(void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat;
-(void)createGroupChatRoom:(NSMutableArray*)buddys withGroupID:(NSString*)groupID;
-(void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat andViewController:(UIViewController *)onlineHome;
-(void)createGroupChatRoom:(NSMutableArray*)buddys withGroupID:(NSString*)groupID WithViewController:(UIViewController *)viewController;
- (void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat WithMessageContent:(NSString *)messageContent;
-(void)fRefetchTableData;
- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date;


//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;

@end
