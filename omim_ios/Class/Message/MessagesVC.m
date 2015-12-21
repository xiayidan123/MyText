//
//  MessagesVC.m
//  omim
//
//  Created by Coca on 4/16/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import "MessagesVC.h"
//#import "ContactListVC.h"
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#include <AVFoundation/AVFoundation.h>

#import "LastestMsgCell.h"
#import "MsgComposerVC.h"

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "MessageCenter.h"

#import "ContactPickerViewController.h"

#import "WTHeader.h"
#import "Constants.h"
#import "PublicFunctions.h"

#import "SystemMessageViewController.h"
#import "AddressBookManager.h"

//#import "BizContactPickerViewController.h"
#import "CustomNavigationBar.h"
#import "OnlineHomeworkVC.h"
@implementation MessagesVC



@synthesize savedSearchTerm, savedScopeButtonIndex, searchWasActive;
@synthesize incomeMsgRingtonePlayer;
@synthesize dataSource,filtedDataSource;
@synthesize gregorian,today,sevenDaysAgo;
@synthesize msgComposer;
@synthesize btn_addchat;
@synthesize tb_messages;
@synthesize _isFromContactList;
@synthesize indexOfDeletingCell = _indexOfDeletingCell;

#define UITableViewCellEditingStyleMultiSelect (3)
-(void)fContactPickUp{
    ContactPickerViewController *cpvc = [[ContactPickerViewController alloc] init];
    
    cpvc.isChosenToStartAChat = YES;
    
    [self.navigationController pushViewController:cpvc animated:YES];
    
    [cpvc release];
    
}


#pragma mark -
#pragma mark Messages Composer
-(void)createGroupChatRoom:(NSMutableArray*)buddys withGroupID:(NSString*)groupID
{
    
    self.msgComposer =[[[MsgComposerVC alloc]
                        initWithNibName:@"MsgComposerVC"
                        bundle:nil] autorelease];
    
    self.msgComposer.isGroupMode = TRUE;
    
    // notify the friends that the messages have been readed.
    NSArray* unreadMsgList = [Database fetchUnreadChatMessagesWithUser:groupID];
    
    NSInteger unReadMsgCount = [unreadMsgList count];
    
    for(int i=0;i<unReadMsgCount;i++)
    {
        ChatMessage* msgTmp = [unreadMsgList objectAtIndex:i];
        
        [WowTalkVoipIF fNotifyMessageReaded:[NSString stringWithFormat:@"%zi", msgTmp.remoteKey] forUser:msgTmp.chatUserName];
        
        // download the message thumbnail from the internet if it is a multimedia msg.
        if ([msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]||[msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
        {
            if (![NSFileManager mediafileExistedAtPath:msgTmp.pathOfThumbNail])
            {
                self.msgComposer.maxNumofThumbnailsToBeDownload ++;
                
            }
        }
        if (unReadMsgCount>0)
        {
            [AppDelegate sharedAppDelegate].unread_message_count -= unReadMsgCount;
            if([AppDelegate sharedAppDelegate].unread_message_count <0)
            {
                [AppDelegate sharedAppDelegate].unread_message_count = 0;
            }
            
            int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
            [defaults synchronize];
            
            [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
            [Database setChatMessageAllReaded:groupID];
            
        }
        
        if (self.msgComposer.maxNumofThumbnailsToBeDownload>0)
        {
            self.msgComposer.needToDownloadMissingThumbnails = TRUE;
        }
        
    }
    
    self.inMessageComposerView = TRUE;
    
    NSString* compistename = nil;
    
    GroupChatRoom* room = [Database getGroupChatRoomByGroupid:groupID];
    if (room) {
        compistename =  room.groupNameOriginal;
    }
    
    [Database setGroupVisibleByID:groupID];
    
    // if it is temporary room, we add myself in the buddys
    
    if (room.isTemporaryGroup) {
        
        //add myself.
        Buddy *buddy = [[Buddy alloc] initWithUID:[WTUserDefaults getUid] andPhoneNumber:[WTUserDefaults getPhoneNumber] andNickname:[WTUserDefaults getNickname] andStatus:[WTUserDefaults getStatus] andDeviceNumber:nil andAppVer:nil andUserType:@"1" andBuddyFlag:@"1" andIsBlocked:NO andSex:nil andPhotoUploadTimeStamp:nil andWowTalkID:[WTUserDefaults getWTID] andLastLongitude:nil andLastLatitude:nil andLastLoginTimestamp:nil withAddFriendRule:1 andAlias:nil];
        [buddys addObject:buddy];
        [buddy release];
        
    }
    
    // start a conversation
    [self.msgComposer startGroupChat:groupID withBuddys:buddys withCompositeName:compistename];
    [self.navigationController pushViewController:self.msgComposer animated:YES];  // temp disabled.
    
}

//input : username here can be some raw phone number like 1(234)567, need some handle
-(void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat
{
    // not a valid number;
    if (buddy ==nil)
    {
        return;
    }
    
    NSString* compositename=nil;
    
    if ([buddy.buddy_flag isEqualToString:@"2"]) {
        ABPerson* person  = [AddressBookManager personWithNumber:buddy.phoneNumber];
        if (person) {
            compositename = person.compositeName;
        }
        else{
            compositename = buddy.phoneNumber;
        }
    }
    else
        compositename = buddy.showName;
    
    self.msgComposer =[[[MsgComposerVC alloc]
                        initWithNibName:@"MsgComposerVC"
                        bundle:nil] autorelease];
    
    self.msgComposer.isGroupMode = FALSE;
    self.msgComposer.isFristChat = isFirstChat;
    
    if(buddy.userType == 0){
        self.msgComposer.isTalkingToOfficialUser=TRUE;
    }
    else{
        self.msgComposer.isTalkingToOfficialUser=FALSE;
    }
    
    
    // notify the friends that the messages have been readed.
    NSArray* unreadMsgList = [Database fetchUnreadChatMessagesWithUser:buddy.userID];
    
    NSInteger unReadMsgCount = [unreadMsgList count];
    
    for(int i=0;i<unReadMsgCount;i++)
    {
        ChatMessage* msgTmp = [unreadMsgList objectAtIndex:i];
        
        [WowTalkVoipIF fNotifyMessageReaded:[NSString stringWithFormat:@"%ld", (long)msgTmp.remoteKey] forUser:msgTmp.chatUserName];
        
        // download the message thumbnail from the internet if it is a multimedia msg.
        if ([msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]||[msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
        {
            if (![NSFileManager mediafileExistedAtPath:msgTmp.pathOfThumbNail])
            {
                self.msgComposer.maxNumofThumbnailsToBeDownload ++;
                
            }
            
            
        }
        if (unReadMsgCount>0)
        {
            
            [AppDelegate sharedAppDelegate].unread_message_count -= unReadMsgCount;
            if([AppDelegate sharedAppDelegate].unread_message_count <0)
            {
                [AppDelegate sharedAppDelegate].unread_message_count = 0;
            }
            
            int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
            [defaults synchronize];
            
            [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
            
            [Database setChatMessageAllReaded:buddy.userID];
            
        }
        
        if (self.msgComposer.maxNumofThumbnailsToBeDownload>0)
        {
            self.msgComposer.needToDownloadMissingThumbnails = TRUE;
        }
        
    }
    
    self.inMessageComposerView = TRUE;
    
    // start a conversation
    [self.msgComposer startChatWithUser:buddy.userID withCompositeName:compositename withDisplayname:compositename];
    
    [self.navigationController pushViewController:self.msgComposer animated:!self._isFromContactList];
}


- (void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat andViewController:(UIViewController *)onlineHome
{
    // not a valid number;
    if (buddy ==nil)
    {
        return;
    }
    
    NSString* compositename=nil;
    
    if ([buddy.buddy_flag isEqualToString:@"2"]) {
        ABPerson* person  = [AddressBookManager personWithNumber:buddy.phoneNumber];
        if (person) {
            compositename = person.compositeName;
        }
        else{
            compositename = buddy.phoneNumber;
        }
    }
    else
        compositename = buddy.showName;
    
    self.msgComposer =[[[MsgComposerVC alloc]
                        initWithNibName:@"MsgComposerVC"
                        bundle:nil] autorelease];
    
    self.msgComposer.isGroupMode = FALSE;
    self.msgComposer.isFristChat = isFirstChat;
    
    if(buddy.userType == 0){
        self.msgComposer.isTalkingToOfficialUser=TRUE;
    }
    else{
        self.msgComposer.isTalkingToOfficialUser=FALSE;
    }
    
    
    // notify the friends that the messages have been readed.
    NSArray* unreadMsgList = [Database fetchUnreadChatMessagesWithUser:buddy.userID];
    
    NSInteger unReadMsgCount = [unreadMsgList count];
    
    for(int i=0;i<unReadMsgCount;i++)
    {
        ChatMessage* msgTmp = [unreadMsgList objectAtIndex:i];
        
        [WowTalkVoipIF fNotifyMessageReaded:[NSString stringWithFormat:@"%ld", (long)msgTmp.remoteKey] forUser:msgTmp.chatUserName];
        
        // download the message thumbnail from the internet if it is a multimedia msg.
        if ([msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]||[msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
        {
            if (![NSFileManager mediafileExistedAtPath:msgTmp.pathOfThumbNail])
            {
                self.msgComposer.maxNumofThumbnailsToBeDownload ++;
                
            }
            
            
        }
        if (unReadMsgCount>0)
        {
            
            [AppDelegate sharedAppDelegate].unread_message_count -= unReadMsgCount;
            if([AppDelegate sharedAppDelegate].unread_message_count <0)
            {
                [AppDelegate sharedAppDelegate].unread_message_count = 0;
            }
            
            int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
            [defaults synchronize];
            
            [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
            
            [Database setChatMessageAllReaded:buddy.userID];
            
        }
        
        if (self.msgComposer.maxNumofThumbnailsToBeDownload>0)
        {
            self.msgComposer.needToDownloadMissingThumbnails = TRUE;
        }
        
    }
    
    self.inMessageComposerView = TRUE;
    
    // start a conversation
    [self.msgComposer startChatWithUser:buddy.userID withCompositeName:compositename withDisplayname:compositename];
    [self.msgComposer getDataFromHomeworkCamera:(OnlineHomeworkVC *)onlineHome];
    [self.navigationController pushViewController:self.msgComposer animated:!self._isFromContactList];
}

-(void)createGroupChatRoom:(NSMutableArray*)buddys withGroupID:(NSString*)groupID WithViewController:(UIViewController *)viewController
{
    
    self.msgComposer =[[[MsgComposerVC alloc]
                        initWithNibName:@"MsgComposerVC"
                        bundle:nil] autorelease];
    
    self.msgComposer.isGroupMode = TRUE;
    
    // notify the friends that the messages have been readed.
    NSArray* unreadMsgList = [Database fetchUnreadChatMessagesWithUser:groupID];
    
    NSInteger unReadMsgCount = [unreadMsgList count];
    
    for(int i=0;i<unReadMsgCount;i++)
    {
        ChatMessage* msgTmp = [unreadMsgList objectAtIndex:i];
        
        [WowTalkVoipIF fNotifyMessageReaded:[NSString stringWithFormat:@"%ld", (long)msgTmp.remoteKey] forUser:msgTmp.chatUserName];
        
        // download the message thumbnail from the internet if it is a multimedia msg.
        if ([msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]||[msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
        {
            if (![NSFileManager mediafileExistedAtPath:msgTmp.pathOfThumbNail])
            {
                self.msgComposer.maxNumofThumbnailsToBeDownload ++;
                
            }
        }
        if (unReadMsgCount>0)
        {
            [AppDelegate sharedAppDelegate].unread_message_count -= unReadMsgCount;
            if([AppDelegate sharedAppDelegate].unread_message_count <0)
            {
                [AppDelegate sharedAppDelegate].unread_message_count = 0;
            }
            
            int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
            [defaults synchronize];
            
            [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
            [Database setChatMessageAllReaded:groupID];
            
        }
        
        if (self.msgComposer.maxNumofThumbnailsToBeDownload>0)
        {
            self.msgComposer.needToDownloadMissingThumbnails = TRUE;
        }
        
    }
    
    self.inMessageComposerView = TRUE;
    
    NSString* compistename = nil;
    
    GroupChatRoom* room = [Database getGroupChatRoomByGroupid:groupID];
    if (room) {
        compistename =  room.groupNameOriginal;
    }
    
    [Database setGroupVisibleByID:groupID];
    
    // if it is temporary room, we add myself in the buddys
    
    if (room.isTemporaryGroup) {
        
        //add myself.
        Buddy *buddy = [[Buddy alloc] initWithUID:[WTUserDefaults getUid] andPhoneNumber:[WTUserDefaults getPhoneNumber] andNickname:[WTUserDefaults getNickname] andStatus:[WTUserDefaults getStatus] andDeviceNumber:nil andAppVer:nil andUserType:@"1" andBuddyFlag:@"1" andIsBlocked:NO andSex:nil andPhotoUploadTimeStamp:nil andWowTalkID:[WTUserDefaults getWTID] andLastLongitude:nil andLastLatitude:nil andLastLoginTimestamp:nil withAddFriendRule:1 andAlias:nil];
        [buddys addObject:buddy];
        [buddy release];
        
    }
    
    // start a conversation
    [self.msgComposer startGroupChat:groupID withBuddys:buddys withCompositeName:compistename];
    [self.msgComposer getDataFromDAView:viewController];
    [self.navigationController pushViewController:self.msgComposer animated:YES];  // temp disabled.
    
}

- (void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat WithMessageContent:(NSString *)messageContent{
    // not a valid number;
    if (buddy ==nil)
    {
        return;
    }
    
    NSString* compositename=nil;
    
    if ([buddy.buddy_flag isEqualToString:@"2"]) {
        ABPerson* person  = [AddressBookManager personWithNumber:buddy.phoneNumber];
        if (person) {
            compositename = person.compositeName;
        }
        else{
            compositename = buddy.phoneNumber;
        }
    }
    else
        compositename = buddy.nickName;
    
    self.msgComposer =[[[MsgComposerVC alloc]
                        initWithNibName:@"MsgComposerVC"
                        bundle:nil] autorelease];
    
    self.msgComposer.isGroupMode = FALSE;
    self.msgComposer.isFristChat = isFirstChat;
    
    if(buddy.userType == 0){
        self.msgComposer.isTalkingToOfficialUser=TRUE;
    }
    else{
        self.msgComposer.isTalkingToOfficialUser=FALSE;
    }
    
    
    // notify the friends that the messages have been readed.
    NSArray* unreadMsgList = [Database fetchUnreadChatMessagesWithUser:buddy.userID];
    
    NSInteger unReadMsgCount = [unreadMsgList count];
    
    for(int i=0;i<unReadMsgCount;i++)
    {
        ChatMessage* msgTmp = [unreadMsgList objectAtIndex:i];
        
        [WowTalkVoipIF fNotifyMessageReaded:[NSString stringWithFormat:@"%ld", (long)msgTmp.remoteKey] forUser:msgTmp.chatUserName];
        
        // download the message thumbnail from the internet if it is a multimedia msg.
        if ([msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]||[msgTmp.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
        {
            if (![NSFileManager mediafileExistedAtPath:msgTmp.pathOfThumbNail])
            {
                self.msgComposer.maxNumofThumbnailsToBeDownload ++;
                
            }
            
            
        }
        if (unReadMsgCount>0)
        {
            
            [AppDelegate sharedAppDelegate].unread_message_count -= unReadMsgCount;
            if([AppDelegate sharedAppDelegate].unread_message_count <0)
            {
                [AppDelegate sharedAppDelegate].unread_message_count = 0;
            }
            
            int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
            [defaults synchronize];
            
            [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
            
            [Database setChatMessageAllReaded:buddy.userID];
            
        }
        
        if (self.msgComposer.maxNumofThumbnailsToBeDownload>0)
        {
            self.msgComposer.needToDownloadMissingThumbnails = TRUE;
        }
        
    }
    
    self.inMessageComposerView = TRUE;
    
    // start a conversation
    [self.msgComposer startChatWithUser:buddy.userID withCompositeName:compositename withDisplayname:compositename];
    [self.msgComposer getDataFromSignInContent:messageContent];
    [self.navigationController pushViewController:self.msgComposer animated:!self._isFromContactList];
}

#pragma mark -
#pragma mark table Handle

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    /*
     If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
     */
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        if (self.filtedDataSource!=nil) {
            return [self.filtedDataSource count];
        }
        else {
            return 0;
        }
        
    }
    else if(tableView == self.tb_messages)
    {
        return [self.dataSource count];
    }
    
    return  0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LastestMsgCell";
    LastestMsgCell *cell = (LastestMsgCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"LastestMsgCell" owner:nil options:nil];
        cell = [topLevelObject objectAtIndex:0];
        
        cell.lblcount.font = [UIFont systemFontOfSize:BADGE_TEXT_FONT];
        
        [cell.btn_delete setBackgroundImage:[PublicFunctions strecthableImage:LARGE_RED_BUTTON] forState:UIControlStateNormal];
        
        [cell.btn_delete setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
        
        
        [cell.btn_delete setFrame:CGRectMake(320-10-DELETE_BUTTON_W, (65-DELETE_BUTTON_H)/2, DELETE_BUTTON_W, DELETE_BUTTON_H)];
        
        cell.btn_delete.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        
        [cell.btn_delete addTarget:self action:@selector(deleteTheChatRoom) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.iv_countbg setImage:[UIImage imageNamed:UNREAD_COUNT_BG]];
        
        // cell.iv_profile.layer.borderColor = [UIColor lightGrayColor].CGColor;
        // cell.iv_profile.layer.borderWidth = 1;
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    // color;
    cell.lblUserName.textColor = [Colors blackColor];
    cell.lblMsg.textColor = [Colors latestMessageColor];
    //    cell.lblSentDate.textColor= [Colors latestChatTimeColor];
    cell.lblSentDate.textColor = [UIColor colorWithHexString:@"#c1c1c1"];
    cell.lblcount.minimumScaleFactor = 7;
    cell.lblcount.adjustsFontSizeToFitWidth = TRUE;
    cell.lblcount.textColor = [Colors whiteColor];
    [cell.btn_delete setTitleColor:[Colors whiteColor] forState:UIControlStateNormal];
    
    if (inDeleteMode && [indexPath isEqual:self.indexOfDeletingCell]) {
        cell.btn_delete.hidden = NO;
        cell.lblSentDate.hidden = YES;
        
    }
    else
    {
        cell.btn_delete.hidden = YES;
        cell.lblSentDate.hidden = NO;
        cell.lblSentDate.alpha = 1;
        
    }
    ChatMessage* msg;
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        msg	=(ChatMessage*) [self.filtedDataSource objectAtIndex:indexPath.row];
        
    }
    else{
        msg	=(ChatMessage*) [self.dataSource objectAtIndex:indexPath.row];
    }
    
    // content;
    cell.lblUserName.text = [PublicFunctions compositeNameOfMessage:msg];
    
    if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]])
    {
        cell.lblMsg.text = msg.messageContent;
    }
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            cell.lblMsg.text = NSLocalizedString(@"A voice message was sent", nil);
        }
        else
        {
            cell.lblMsg.text = NSLocalizedString(@"A voice message was received", nil);
        }
        
    } // photo
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            cell.lblMsg.text = NSLocalizedString(@"A photo was sent", nil);
        }
        else
        {
            cell.lblMsg.text = NSLocalizedString(@"A photo was received", nil);
        }
        
    } // video
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            cell.lblMsg.text = NSLocalizedString(@"A video clip was sent", nil);
        }
        else
        {
            cell.lblMsg.text = NSLocalizedString(@"A video clip was received", nil);
        }
        
    }
    // location
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_LOCATION]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            cell.lblMsg.text = NSLocalizedString(@"A location was sent", nil);
        }
        else
        {
            cell.lblMsg.text = NSLocalizedString(@"A location was received", nil);
        }
        
    } // stamp
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_STAMP]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            cell.lblMsg.text = NSLocalizedString(@"A stamp was sent", nil);
        }
        else
        {
            cell.lblMsg.text = NSLocalizedString(@"A stamp was received", nil);
        }
        
    }
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_CALL_LOG]])
    {
        SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
        NSDictionary* dic = (NSDictionary*)[jp fragmentWithString: msg.messageContent];
        if ([[dic valueForKey:CALL_DIRECTION] isEqualToString:@"out"]) {
            cell.lblMsg.text = NSLocalizedString(@"You just called others", nil);
        }
        else
        {
            if ([[dic valueForKey:CALL_RESULT_TYPE] isEqualToString:@"1"]) {
                cell.lblMsg.text = NSLocalizedString(@"You had a missing call", nil);
            }
            else {
                cell.lblMsg.text = NSLocalizedString(@"You had an incoming call", nil);
            }
        }
    }
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM]])
    {
        cell.lblMsg.text = msg.messageContent;
        
    }
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM]])
    {
        cell.lblMsg.text = msg.messageContent;
        
    }
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            cell.lblMsg.text = NSLocalizedString(@"A pic-voice message was sent", nil);
        }
        else
        {
            cell.lblMsg.text = NSLocalizedString(@"A pic-voice message was received", nil);
        }
        
    }
    // add more types.
    else
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            cell.lblMsg.text = NSLocalizedString(@"A multimedia message was sent", nil);
        }
        else
        {
            cell.lblMsg.text = NSLocalizedString(@"A multimedia message was received", nil);
        }
    }
    
    
    cell.lblSentDate.text = msg.sentDate;
    
    NSInteger unReadMsgCount = [Database countUnreadChatMessagesWithUser:msg.chatUserName];
    
    if ( unReadMsgCount == 0) {
        cell.lblcount.hidden = YES;
        cell.iv_countbg.hidden = YES;
    }
    else if (unReadMsgCount > 0)
    {
        cell.lblcount.hidden = NO;
        cell.iv_countbg.hidden = NO;
        
        cell.lblcount.text =  [NSString stringWithFormat:@"%ld",(long)unReadMsgCount];
        
    }
    
    UIView* subview = [cell.headImageView viewWithTag:100];
    if (subview) {
        [subview removeFromSuperview];
    }
    
    if (msg.isGroupChatMessage) {
        
        GroupChatRoom* room = [Database getGroupChatRoomByGroupid:msg.chatUserName];
        cell.headImageView.buddy = nil;
        if (room == nil) {
            cell.headImageView.headImage = [UIImage imageNamed:DEFAULT_GROUP_AVATAR];
            [WowTalkWebServerIF groupChat_GetGroupDetail:msg.chatUserName withCallback:@selector(didGetGroupInfo:) withObserver:self];
        }
        else{
            if (room.isTemporaryGroup) {
                cell.headImageView.headImage = [UIImage imageNamed:@"group_avatar_bg.png"];
                UIView* avatars = [PublicFunctions combinedGroupChatRoomAvatar:room];
                avatars.tag = 100;
                [cell.headImageView addSubview:avatars];
            }
            else{
                NSData* data = [AvatarHelper getThumbnailForGroup:msg.chatUserName];
                if(data){
                    cell.headImageView.headImage = [[[UIImage alloc] initWithData:data] autorelease];
                }
                else{
                    cell.headImageView.headImage = [UIImage imageNamed:DEFAULT_GROUP_AVATAR];
                }
                UserGroup* group = [Database getFixedGroupByID:msg.chatUserName];
                if (group.needToDownloadThumbnail) {
                    [WowTalkWebServerIF getGroupAvatarThumbnail:msg.chatUserName withCallback:@selector(didGetGroupThumbnail:) withObserver:self];
                }
            }
        }
    }
    else{
        cell.headImageView.buddy = nil;
        if ([msg.chatUserName isEqualToString:@"10000"]) {
            cell.headImageView.headImage = [UIImage imageNamed:@"chat_notification_icon.png"];
        }
        else{
            Buddy* buddy = [Database buddyWithUserID:msg.chatUserName];
            cell.headImageView.buddy = buddy;
            if ([NSFileManager mediafileExistedAtPath: buddy.pathOfThumbNail]){
                cell.headImageView.headImage = [UIImage imageWithData:[AvatarHelper getThumbnailForUser:buddy.userID]];
            }
            else
            {
                if ([buddy.buddy_flag isEqualToString:@"2"]) {
                    cell.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR_OFFLINE_IMAGE_90];
                }
                else
                    cell.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR];
                
                
            }
            if (buddy.needToDownloadThumbnail) {
                [WowTalkWebServerIF getThumbnailForUserID:buddy.userID withCallback:@selector(didGetBuddyThumbnail:) withObserver:self];
            }
        }
    }
    
    if ([tableView isEditing]) {
        cell.lblSentDate.frame = CGRectMake(175, 0, 95, 20);
    }
    else{
        cell.lblSentDate.frame = CGRectMake(205, 0, 95, 20);
        
    }
    
    
    ////////////////////////////////
    NSDate* sentDate= [Database chatMessage_UTCStringToDate:msg.sentDate];
    
    NSDateComponents* components = [self getDateComponentsFromDate:sentDate];
    
    //if the sentDate is not earlier then today
    if ([sentDate compare:self.today] != NSOrderedAscending ) {
        cell.lblSentDate.text = [NSString stringWithFormat: @"%02ld:%02ld", (long)[components hour],(long)[components minute]];
    }
    else {
        if ([sentDate compare:self.sevenDaysAgo] != NSOrderedAscending) {
            NSString* strWeekday = [NSString stringWithFormat:@"Weekday%ld",(long)[components weekday]];
            cell.lblSentDate.text = NSLocalizedString(strWeekday,nil);
        }
        else {
            cell.lblSentDate.text = [NSString stringWithFormat: @"%ld/%ld/%ld", (long)[components year],(long)[components month],(long)[components day]];
            
        }
        
    }
    
    ////////////////////////////////
    
    
    
    
    return cell;
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (![self.tb_messages isEditing]) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        ChatMessage* msg;
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            msg	=(ChatMessage*) [self.filtedDataSource objectAtIndex:indexPath.row];
        }
        else
        {
            msg	=(ChatMessage*) [self.dataSource objectAtIndex:indexPath.row];
        }
        
        if ([msg.chatUserName isEqualToString:@"10000"]) {
            self.smvc = [[SystemMessageViewController alloc] init];
            [self.navigationController pushViewController:self.smvc animated:TRUE];
            [self.smvc release];
            isInSystemMessageView = TRUE;
            
            return;
        }
        
        if (msg.isGroupChatMessage) {
            GroupChatRoom* room = [Database getGroupChatRoomByGroupid:msg.chatUserName];
            if (room == nil) {
                currentSelectedGroupID = msg.chatUserName;
                inEnterGroupChatRoomMode = TRUE;
                [WowTalkWebServerIF groupChat_GetGroupDetail:msg.chatUserName withCallback:@selector(didGetGroupInfo:) withObserver:self];
            }
            else{
                NSMutableArray* buddys = [Database fetchAllBuddysInGroupChatRoom:msg.chatUserName];
                [self createGroupChatRoom:buddys withGroupID:msg.chatUserName];
            }
        }
        else{
            Buddy* buddy = [Database buddyWithUserID:msg.chatUserName];
            [self fComposeWowTalkMsgToUser:buddy withFirstChat:NO];
        }
    }
}

#pragma mark  gesture operation

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // Disallow recognition of tap gestures in the segmented control.
    
    // if it is a button
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if ([touch.view isKindOfClass:[UIButton class]]) {
            return NO;
        }
    }
    return YES;
}

-(void)cancleDeletingChatRoom:(UIGestureRecognizer *)gestureRecognizer
{
    if (!inDeleteMode) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        LastestMsgCell* cell = (LastestMsgCell*)[self.tb_messages cellForRowAtIndexPath:self.indexOfDeletingCell];
        
        cell.btn_delete.hidden = NO;
        cell.lblSentDate.hidden = NO;
        
        cell.btn_delete.alpha = 1;
        cell.lblSentDate.alpha = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            cell.btn_delete.alpha = 0;
            cell.lblSentDate.alpha = 1;
            
        } completion:^(BOOL flag){
            cell.btn_delete.hidden = YES;
        }];
        
        
        [self.tb_messages removeGestureRecognizer:gestureRecognizer];
        
        inDeleteMode = FALSE;
        
        
        
    }
    
}

-(void)deleteTheChatRoom
{
    
    ChatMessage* msg =(ChatMessage*) [self.dataSource objectAtIndex:self.indexOfDeletingCell.row] ;
    
    if (msg.isGroupChatMessage && ![msg.chatUserName isEqualToString:@"10000"]) {
        [Database setGroupInvisibleByID:msg.chatUserName];
    }
    
    int numberOfUnreadedMsg = [Database deleteChatMessageWithUser:msg.chatUserName];
    
    NSString* dirname = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:msg.chatUserName];
    
    [NSFileManager removeAllTheFilesInDir:dirname];
    
    [self.dataSource removeObjectAtIndex:self.indexOfDeletingCell.row];
    
    [self.tb_messages deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexOfDeletingCell] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    if (numberOfUnreadedMsg>0)
    {
        [AppDelegate sharedAppDelegate].unread_message_count -= numberOfUnreadedMsg;
        
        if([AppDelegate sharedAppDelegate].unread_message_count <0)
        {
            [AppDelegate sharedAppDelegate].unread_message_count = 0;
        }
        
        int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
        [defaults synchronize];
        
        [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
        
    }
    
    for (UIGestureRecognizer* gesture in [self.tb_messages gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.tb_messages removeGestureRecognizer:gesture];
        }
    }
    
    [self checkEmptyNotice];
    inDeleteMode = FALSE;
}

-(void)didSwipeTheRow:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (!inDeleteMode) {
            
            // set up swiper guestures
            UITapGestureRecognizer* tapRecognizer;
            tapRecognizer = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleDeletingChatRoom:)] autorelease];
            tapRecognizer.delegate = self;
            [self.tb_messages addGestureRecognizer:tapRecognizer];
            
            
            CGPoint swipeLocation = [gestureRecognizer locationInView:self.tb_messages];
            NSIndexPath *swipedIndexPath = [self.tb_messages indexPathForRowAtPoint:swipeLocation];
            
            self.indexOfDeletingCell = swipedIndexPath;
            
            LastestMsgCell* swipedCell = (LastestMsgCell*)[self.tb_messages cellForRowAtIndexPath:swipedIndexPath];
            
            swipedCell.btn_delete.alpha = 0;
            swipedCell.btn_delete.hidden = NO;
            swipedCell.lblSentDate.alpha = 1;
            
            
            [UIView animateWithDuration:0.2 animations:^{
                
                swipedCell.btn_delete.alpha = 1;
                swipedCell.lblSentDate.alpha = 0;
                
            } completion:^(BOOL flag){
                swipedCell.lblSentDate.hidden = YES;
            }];
            
            
            inDeleteMode = TRUE;
        }
        
        
    }
}

#pragma mark -
#pragma mark WowtalkTextDelegate WowtalkXMLParserDelegate

- (void)officialMSGXMLParseFinished:(NSMutableDictionary *)result forMsg:(ChatMessage *)msg{
    
    NSLog(@"officialMSGXMLParseFinished");
    NSString* xmlMsgType = [result objectForKey:@"MsgType"];
    NSString* xmlMsgContent = [result objectForKey:@"Content"];
    
    if(xmlMsgType!=nil && xmlMsgContent!=nil){
        
        msg.msgType = [MessageHelper translateOfficialUserMsgTypeToChatMessageType:xmlMsgType];
        
        msg.messageContent = xmlMsgContent;
        
        [Database updateChatMessage:msg];
        
        [self getChatMessage:msg];
        
    }
    else{
        [Database deleteChatMessage:msg];
        
    }
    
}

-(void)getChatMessageByNotif:(NSNotification *)notif{
    if (self.dataSource == nil) {
        self.dataSource = [[[NSMutableArray alloc] init] autorelease];
    }
    
    ChatMessage* msg = (ChatMessage *)[notif.userInfo objectForKey: @"data"];
    
    if(msg==nil)  return;
    
    
    
    if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_OFFICIAL_ACCOUNT_MSG]]){
        //[WTHelper WTLog:msg.messageContent];
        
        WTOfficialMSGXMLDelegate *xmlParserDelegate = [[WTOfficialMSGXMLDelegate alloc] init];
        xmlParserDelegate.delegate = self;
        xmlParserDelegate.msg = msg;
        
        if (xmlParserDelegate!=nil) {
            NSData *xmlData=[msg.messageContent dataUsingEncoding:NSUTF8StringEncoding];
            
            NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData: xmlData];
            //end patch
            
            [xmlParser setDelegate: xmlParserDelegate];
            [xmlParser setShouldResolveExternalEntities:YES];
            [xmlParser parse];
            [xmlParser setDelegate:nil];
        }
        return;
        
    }
    else{
        [self getChatMessage:msg];
    }
    
}

-(void)getChatMessage:(ChatMessage*)newmsg
{
    if (self.dataSource == nil) {
        self.dataSource = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if(newmsg==nil)  return;
    
    int oldKey = newmsg.primaryKey;
    
    ChatMessage* msg = [[MessageCenter defaultCenter] PreprocessMessage:newmsg];
    
    if (msg==nil) {
        return;
    }
    
    // if the message becomes system message, we increase unread count and do nothing.
    if (msg.primaryKey != oldKey) {
        
        if (self.smvc == nil) {
            
            [AppDelegate sharedAppDelegate].unread_message_count += 1;
            
            int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
            
            [defaults synchronize];
            
            [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
            
            
        }
        else{
            [self.smvc fProcessNewIncomeMsg:msg];
        }
        return;
    }
    
    else{
        
        if (!msg.isGroupChatMessage) {
            Buddy* buddy = [Database buddyWithUserID: msg.chatUserName];
            if (buddy == nil)
                [WowTalkWebServerIF getBuddyWithUID:msg.chatUserName withCallback:@selector(didGetBuddy:) withObserver:nil];
        }
        else{
            Buddy* senderbuddy = [Database buddyWithUserID:msg.groupChatSenderID];
            if (senderbuddy == nil)
                [WowTalkWebServerIF getBuddyWithUID:msg.groupChatSenderID withCallback:@selector(didGetBuddy:) withObserver:nil];
            
        }
        
        //we only show chat message in the list if one' chatroom is already shown or it is not notification type messages (join or quit)
        BOOL found = FALSE;
        int index = -1;
        //store msg
        for (int i=0;i<[self.dataSource count];i++){
            ChatMessage* tmpMsg =[self.dataSource objectAtIndex:i];
            if ([tmpMsg.chatUserName isEqualToString:msg.chatUserName] ){
                found = TRUE;
                index = i;
                break;
            }
        }
        
        BOOL needShowThisMessage = FALSE;
        
        if (found) {
            needShowThisMessage = TRUE;
        }
        
        if (![msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM]]&&![msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM]]) {
            needShowThisMessage = TRUE;
        }
        else
            needShowThisMessage = FALSE;
        
        // if message log show and it is with that user ,reload that view too
        if(self.msgComposer!=nil && self.inMessageComposerView){
            if([self.msgComposer._userName isEqualToString: msg.chatUserName]){
                [self.msgComposer fProcessNewIncomeMsg:msg];
            }
        }
        //else show badgeValue
        else{
            
            if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM]]&&![msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM]]) {
                [Database setChatMessageReaded:msg];
            }
            
            if (needShowThisMessage) {
                [AppDelegate sharedAppDelegate].unread_message_count += 1;
                int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
                
                [defaults synchronize];
                
                [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
            }
            
        }
        
        if (needShowThisMessage) {
            if (found&&index > -1) {
                [self.dataSource removeObjectAtIndex:index];
            }
            
            [self.dataSource insertObject:msg atIndex:0];
            
            if (msg.isGroupChatMessage) {
                [Database setGroupVisibleByID:msg.chatUserName];  // visible issue is handled here.
            }
            
            
            //TODO: fix here.
            if (self.incomeMsgRingtonePlayer == nil) {
                NSString *incomeCallRingtone = [[NSBundle mainBundle] pathForResource:@"Msg" ofType:@"caf"];
                self.incomeMsgRingtonePlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:incomeCallRingtone] error:NULL] autorelease];
                self.incomeMsgRingtonePlayer.delegate = nil;
                [self.incomeMsgRingtonePlayer setNumberOfLoops:0];
            }
            
            if (![self.incomeMsgRingtonePlayer isPlaying])
            {
                [self.incomeMsgRingtonePlayer prepareToPlay];
                [self.incomeMsgRingtonePlayer play];
            }
            
            // TODO vibration not working on 3G
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            
            //reload table data // change title
            [self.tb_messages reloadData];
            
            
            [self checkEmptyNotice];
            
        }
    }
}

-(NSString*)currentChatroomID
{
    if (self.msgComposer != nil) {
        return  self.msgComposer._userName;
    }
    return nil;
}

-(BOOL)inChatRoom
{
    if (self.msgComposer!= nil && self.inMessageComposerView) {
        return TRUE;
    }
    return FALSE;
}


#pragma mark -
#pragma mark Registration Update Notification Received
- (void)registrationUpdateEvent:(NSNotification*)notif {
    
    int state = [[notif.userInfo objectForKey: @"state"] intValue] ;
    
    NSString* strTitleMsg=@"";
    switch (state) {
        case WTRegistrationInProgress:
            strTitleMsg = NSLocalizedString(@"Connecting...", nil);
            break;
        case WTRegistrationIdle:
            //            strTitleMsg = NSLocalizedString(@"Idle", nil);
            //            break;
        case WTRegistrationFailed:
            strTitleMsg = NSLocalizedString(@"Connection lost", nil);
            break;
        case WTRegistrationSuccess:
            strTitleMsg = NSLocalizedString(@"messages",nil);
            break;
        default:
            break;
    }
    
    if ([self isShowing]) {
        [self setTitle:strTitleMsg];
        self.navigationController.navigationBar.topItem.title = strTitleMsg;
    }
    
    //    self.navigationItem.titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    [self.navigationItem.titleView sizeToFit];
    //
    //    [self.navigationItem.titleView setNeedsLayout];
    //    [self.navigationItem.titleView setNeedsDisplay];
}



#pragma mark -
#pragma mark Table Data.
//NSComparisonResult fSortChatMsgByDateDESC(ChatMessage* msg1, ChatMessage* msg2, void* context)
//{
//	return [msg2.sentDate compare:msg1.sentDate];
//}

-(void)fRefetchTableData
{
    if (self.dataSource){
        [self.dataSource removeAllObjects];
    }
    
    self.dataSource = [Database fetchAllChatMessages:YES];   // Get all the messages.
    
    [self.dataSource sortUsingFunction:fSortChatMsgByDateDESC context:nil];
    
    for (int i = 0; i< [self.dataSource count]; i ++){
        
        ChatMessage* msg = [self.dataSource objectAtIndex:i];
        if (msg.isGroupChatMessage) {
            GroupChatRoom* room = [Database getGroupChatRoomByGroupid:msg.chatUserName];
            
            //if the group is invisible, we don't show its message until someone sends a message to the group.
            if (room.isInvisibile) {
                [self.dataSource removeObject:msg];
                continue;
            }
            
            NSArray* buddys = [Database fetchAllBuddysInGroupChatRoom:msg.chatUserName];
            
            if (buddys == nil || [buddys count] == 0){
                // if the member count is larger than 1
                if (room.memberCount > 0) {
                    [WowTalkWebServerIF groupChat_GetGroupMembers:msg.chatUserName withCallback:@selector(didGetBuddyForGroup:) withObserver:self];
                }
                continue;
            }
            else{
                Buddy* senderbuddy = [Database buddyWithUserID:msg.groupChatSenderID];
                if (senderbuddy == nil)
                    [WowTalkWebServerIF getBuddyWithUID:msg.groupChatSenderID withCallback:@selector(didGetBuddy:) withObserver:nil];
            }
        }
        else{
            if (![msg.chatUserName isEqualToString:@"10000"]) {
                Buddy* buddy = [Database buddyWithUserID: msg.chatUserName];
                if (!buddy) {
                    [WowTalkWebServerIF getBuddyWithUID:msg.chatUserName withCallback:@selector(didGetBuddy:) withObserver:self];
                }
            }
        }
    }
    
    [self.tb_messages reloadData];
}

#pragma mark -
#pragma mark notification callback.

- (void)didRomveBuddy:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
//    id name = [notif name];
    if (error.code == 0) {
        [self fRefetchTableData];
    }
}


- (void)didKickoutGroup:(NSNotification *)notif{
    [self fRefetchTableData];
}

-(void)didGetBuddyForGroup:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code != 0) {
        NSLog(@"problem occurs when getting members in a chatroom");
    }
    else{
        [self fRefetchTableData];
    }
    
    
}

-(void)didGetBuddy:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code != 0) {
        NSLog(@"problem occurs when getting a buddy");
    }
    else{
        [self fRefetchTableData];
    }
}

-(void)didGetGroupInfo:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString* groupid = [[notif userInfo] valueForKey:@"group_id"];
        if (groupid) {
            [WowTalkWebServerIF groupChat_GetGroupMembers:groupid withCallback:@selector(didGetGroupMembers:) withObserver:self];
        }
        [self.tb_messages reloadData];
    }
}

-(void)didGetGroupMembers:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        if (inEnterGroupChatRoomMode) {
            inEnterGroupChatRoomMode = FALSE;
            NSMutableArray* buddys = [Database fetchAllBuddysInGroupChatRoom:currentSelectedGroupID];
            [self createGroupChatRoom:buddys withGroupID:currentSelectedGroupID];
        }
        else
            [self.tb_messages reloadData];
    }
}

-(void)didGetGroupThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.tb_messages reloadData];
    }
    
}

-(void)didGetBuddyThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.tb_messages reloadData];
    }
    
}


- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date {
    return [self.gregorian components:(NSHourCalendarUnit |
                                       NSMinuteCalendarUnit |
                                       NSSecondCalendarUnit |
                                       NSDayCalendarUnit |
                                       NSWeekdayCalendarUnit |
                                       NSMonthCalendarUnit |
                                       NSYearCalendarUnit) fromDate:date];
}


#pragma  mark -- View handler
-(void)checkEmptyNotice
{
    if ([self.dataSource count] == 0) {
        [self.view addSubview:noChatsNoticeView];
    }
    else{
        if ([noChatsNoticeView superview] != nil) {
            [noChatsNoticeView removeFromSuperview];
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if (_isTemporaryChatPop){// 创建完临时群组会调用viewWillAppear，无需初始化。
        _isTemporaryChatPop = NO;
        return;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetBuddy:) name:GET_USER_BY_ID_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetGroupInfo:) name:WT_GET_GROUP_INFO object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRomveBuddy:) name:WT_REMOVE_BUDDY object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKickoutGroup:) name:WT_KICKOUT_GROUP object:nil];
    
    self.inMessageComposerView = FALSE;
    isInSystemMessageView = FALSE;
    
    self.msgComposer = nil;
    self.smvc = nil;
    
    if (IS_IOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.isShowing = FALSE;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_USER_BY_ID_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WT_GET_GROUP_INFO object:nil];
}

-(void)loadTile
{
    
}


// TODO: a temporary solution. the messages will be missing sometimes. we have to check the unread number of current chatrooms to make sure it will not have wrong count in tab bar.
-(void)checkUnreadNumber
{
    int number = 0;
    
    for (ChatMessage* msg in self.dataSource) {
        number += [Database countUnreadChatMessagesWithUser:msg.chatUserName];
    }
    
    [AppDelegate sharedAppDelegate].unread_message_count = number;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:number forKey:UNREAD_MESSAGE_NUMBER];
    [defaults synchronize];
    
    [[AppDelegate sharedAppDelegate].tabbarVC refreshCustomBarUnreadNum];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fRefetchTableData];
    
    [self checkEmptyNotice];
    
    [self checkUnreadNumber];
    
    self.isShowing = TRUE;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void) configNav
{
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  NSLocalizedString(@"messages",nil);
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *rightbarButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:@"icon_add_white.png"] selector:@selector(fContactPickUp)];
    [self.navigationItem addRightBarButtonItem:rightbarButton];
    [rightbarButton release];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
    
    
    
    self.view.backgroundColor = [Colors chatRoomBackgroundColor];
    self.tb_messages.backgroundColor = [Colors chatRoomBackgroundColor];
    
    self.gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *todayComponents = [self getDateComponentsFromDate:[NSDate date]];
    [todayComponents setHour:0];
    [todayComponents setMinute:0];
    [todayComponents setSecond:0];
    self.today = [self.gregorian dateFromComponents:todayComponents];
    
    
    NSDateComponents *minusComponents = [[[NSDateComponents alloc] init] autorelease];
    [minusComponents setDay:-7 ];
    self.sevenDaysAgo = [self.gregorian dateByAddingComponents:minusComponents toDate:self.today options:0];
    
    
    // set up swiper guestures
    UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipeTheRow:)];
    [swipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft)];
    [self.tb_messages addGestureRecognizer:swipeRecognizer];
    [swipeRecognizer release];
    
    
    
    self.inMessageComposerView = FALSE;
    
    [self configNav];
    
    
    
    noChatsNoticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar] - 49)];
    noChatsNoticeView.backgroundColor = [UIColor clearColor];
    
    UIImageView* noChatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 100, 110, 110)];
    noChatImageView.image = [UIImage imageNamed:CHAT_LIST_EMPTY_NOTICE];
    [noChatsNoticeView addSubview:noChatImageView];
    [noChatImageView release];
    
    
    UILabel *noChatLabel = [[[UILabel alloc] initWithFrame:CGRectMake(60, 220, 200, 44)] autorelease];
    noChatLabel.backgroundColor = [UIColor clearColor];
    noChatLabel.font = [UIFont boldSystemFontOfSize:16.0];
    noChatLabel.textAlignment = NSTextAlignmentCenter;
    noChatLabel.textColor = [Colors grayColor]; // change this color
    noChatLabel.text = NSLocalizedString(@"No Chat Ind",nil);
    [noChatsNoticeView addSubview:noChatLabel];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrationUpdateEvent:)
                                                 name:notif_WTRegistrationUpdate
                                               object:nil];
    
    
    
    self.searchDisplayController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatMessageByNotif:)
                                                 name:notif_WTChatMessageReceived
                                               object:nil];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = FALSE;
        [self.tb_messages setSeparatorInset:UIEdgeInsetsZero];
        
        [self.tb_messages setFrame:CGRectMake(0, 0, self.tb_messages.frame.size.width, [UISize screenHeight] - 20 - 44 - 49)];
    }
    
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    
    return YES;
}


- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    isSearchBarShown = TRUE;
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.searchDisplayController.searchBar setTintColor:[UIColor blackColor]];
}



- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.tb_messages reloadData];
    isSearchBarShown = FALSE;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
    if (self.filtedDataSource == nil) {
        self.filtedDataSource = [[[NSMutableArray alloc] init] autorelease];
    }
    else
        [self.filtedDataSource removeAllObjects];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)",searchText];
    
    for (ChatMessage* msg in self.dataSource) {
        if (msg.isGroupChatMessage) {
            GroupChatRoom* room = [Database getGroupChatRoomByGroupid:msg.chatUserName];
            if ([predicate evaluateWithObject:room.groupNameOriginal]) {
                [self.filtedDataSource addObject:msg];
                continue;
            }
            
            
            NSArray* buddys;
            buddys = [Database fetchAllBuddysInGroupChatRoom:room.groupID];
            
            for (Buddy* buddy in buddys) {
                if ([predicate evaluateWithObject:buddy.nickName]) {
                    [self.filtedDataSource addObject:msg];
                    break;
                }
            }
        }
        else{
            Buddy* buddy = [Database buddyWithUserID:msg.chatUserName];
            if ([predicate evaluateWithObject:buddy.nickName]) {
                [self.filtedDataSource addObject:msg];
                continue;
            }
        }
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notif_WTRegistrationUpdate
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notif_WTChatMessageReceived
                                                  object:nil];
    
    self.btn_addchat = nil;
    //    self.tb_messages = nil;
    
    self.gregorian= nil;
    
    self.sevenDaysAgo = nil;
    self.today = nil;
    self.smvc = nil;
    self.msgComposer = nil;
    self.filtedDataSource = nil;
    self.incomeMsgRingtonePlayer = nil;
    self.dataSource = nil;
    
    self.savedSearchTerm = nil;
    self.indexOfDeletingCell = nil;
    
    [super dealloc];
}


@end