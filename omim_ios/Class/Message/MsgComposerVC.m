
//
//  MsgComposerVC.m
//  omim
//
//  Created by Coca on 5/26/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import "MsgComposerVC.h"
#import <QuartzCore/QuartzCore.h>

#import "MessagesVC.h"
#import "AppDelegate.h"

#import "RecorderOutGoingCell.h"
#import "RecorderIncomingCell.h"
#import "MultimediaOutgoingCell.h"
#import "MultimediaIncomingCell.h"
#import "TextIncomingCell.h"
#import "TextOutgoingCell.h"
#import "LocationOutgoingCell.h"
#import "LocationIncomingCell.h"
#import "CallIncomingCell.h"
#import "CallOutgoingCell.h"

#import "Constants.h"

#import "VoiceMessagePlayer.h"
#import "PDColoredProgressView.h"
#import "CustomAnnotation.h"

#import "ContactPickerViewController.h"

#import "PublicFunctions.h"
#import "GroupInfoViewController.h"

#import "WTUserDefaults.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "DAViewController.h"

// NEW APIS
#import "WTHeader.h"
#import "TempChatRoomInfoViewController.h"
//#import "BizContactPickerViewController.h"
#import "CustomNavigationBar.h"
//#import "BizDepartmentViewController.h"
#import "OMNewPicVoiceMsgVC.h"

#import "OMHeadImgeView.h"
#import "OnlineHomeworkVC.h"

#import "OMNetWork_MyClass_Constant.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define INIT_MSG_SHOW 20

@interface MsgComposerVC()<UITextViewDelegate>{
    BOOL firstOpenTime;
    BOOL deactiveTheNotifCallback;
}

@property (nonatomic) BOOL moreBarShown;

@property (retain,nonatomic) NSIndexPath* longPressedCellIndex;

-(void)addMessageToMessageArray:(ChatMessage*)msg;
-(UIImage*)getMessageBuddyProfile:(ChatMessage*)msg;
-(void)getMessagesList;
-(void)rotateAnimationForView:(UIView*)oview;

@end

@implementation MsgComposerVC


//TODO: shadow not implemented
#define EXISTED_MSG_INPUT_MAXLINES 7 //9 when we dont use tab bar in new msg composer
#define NEW_MSG_INPUT_MAXLINES 7
#define UITableViewCellEditingStyleMultiSelect (3)
#define TABLEVIEW_HEIGHT_FOR_EXIST_CHAT 367.0
#define TABLEVIEW_HEIGHT_FOR_NEW_CHAT 367.0  //416.0  when we dont use tab bar in new msg composer

#define TOP_HEADERVIEW_INCRESE_LIMIT_BUTTON 99

#define TAG_MESSAGE_DATE 100
#define TAG_MESSAGE_IMAGE 101
#define TAG_MESSAGE_LABEL 102

#define TAG_MESSAGE_IMAGE_ANI 103
#define TAG_MESSAGE_LABEL_ANI 103

#define TAG_MESSAGE_MARK_SENT 104
#define TAG_MESSAGE_MARK_RECEIVED 105
#define TAG_MESSAGE_MARK_SENT_FAILED 106

#define TAG_SENTLABEL 107
#define TAG_SENTTIMELABEL 108

#define TAG_PROFILE 109
#define TAG_BUDDY_NAME 110

#define TAG_BUTTON_UPDATE 111

#define BUBBLE_MAX_WIDTH 204
#define BUBBLE_TEXT_FONTSIZE 17.0

@synthesize _buddy;
@synthesize _userName;
@synthesize _compositeName;
@synthesize _arrAllMsgs;
@synthesize _showLimit;
@synthesize _recordCnt;
@synthesize isGroupMode;
@synthesize isTalkingToOfficialUser;
@synthesize buddys;
@synthesize room;

@synthesize listOfMessages,dateOfMessages;
@synthesize txtView_Input;
@synthesize btn_send;
@synthesize tb_messages;
@synthesize lbl_namelist,btn_call,uv_navcontainer,btn_goback,btn_addtocontact;
//default operation bar
@synthesize btn_showmore,btn_record,uv_defaultoperationbar,btn_keyboard,btn_hidemore,btn_stamp;
@synthesize uv_micbar,uv_micbar_container,lbl_recorddesc,btn_gobacktext,iv_defaultoperationbar_bg;
// more operation bar
@synthesize uv_moreoperationbar;
@synthesize iv_moreoperationbar_bg;

@synthesize familyOperationBar = _familyOperationBar;
@synthesize familyOperationBarBackground = _familyOperationBarBackground;
@synthesize familyOperationBarIndicator = _familyOperationBarIndicator;

@synthesize btn_mic,btn_photo,btn_camera,btn_location,btn_pic_write,btn_pic_voice;
@synthesize iv_micbar_bg = _iv_micbar_bg;

@synthesize isFromSelection;

@synthesize parent;

@synthesize uv_barcontainer;

@synthesize _displayname;

@synthesize _refreshHeaderView;

@synthesize warningDesc;

@synthesize recordVC;

@synthesize mInputMode;

@synthesize pvc;

@synthesize cameraViewController = _cameraViewController;

@synthesize imageForProfile = _imageForProfile;

@synthesize needToDownloadMissingThumbnails = _needToDownloadMissingThumbnails;
@synthesize maxNumofThumbnailsToBeDownload= _maxNumofThumbnailsToBeDownload;

@synthesize arrayOfAutoUploadingIndexPaths = _arrayOfAutoUploadingIndexPaths;

@synthesize cllmanager = _cllmanager;
@synthesize expressionPickView = _expressionPickView;

@synthesize tapRecognizer = _tapRecognizer;

@synthesize arrayOfAutoplayMessages = _arrayOfAutoplayMessages;

@synthesize iv_mic_icon = _iv_mic_icon;
@synthesize iv_inputbox_bg = _iv_inputbox_bg;

@synthesize moreBarShown = _moreBarShown;

#pragma mark -
#pragma mark Download Thumbail

//TODO: add this fuction after build the data. improve the performance.
-(void)downloadMissingThumbnails
{
    int num = 0;
    
    for (NSInteger i = [self.dateOfMessages count]-1; i >= 0; i--) {
        if (num == self.maxNumofThumbnailsToBeDownload) break;
        
        for (NSInteger j = [[self.listOfMessages objectAtIndex:i] count]-1; j>=0 ; j--){
            if (num == self.maxNumofThumbnailsToBeDownload) break;
            
            ChatMessage* msg = (ChatMessage*)[[self.listOfMessages objectAtIndex:i] objectAtIndex:j];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j+1 inSection:i];   // the indexpath in the table.
            
            if (![msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]]){
                if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]|| [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]] || [msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]]){
                    if (![NSFileManager mediafileExistedAtPath:msg.pathOfThumbNail]){
                        num ++;
                        [self startDownloadingThumbnail:msg WithIndexpath:indexPath];
                    }
                }
            }
        }
    }
}

-(void)startToDownloadMissingStamp:(ChatMessage*) msg WithIndexpath:(NSIndexPath *)indexPath
{
    [WTHelper WTLog:@"We do not implement the stamp function in yuanqutong"];
    
}

-(void)startDownloadingThumbnail:(ChatMessage*) msg WithIndexpath:(NSIndexPath *)indexPath
{
    if (![NSFileManager mediafileExistedAtPath: msg.pathOfThumbNail])
        [WowTalkWebServerIF downloadMediaMessageThumbnail:msg withCallback:@selector(didDownloadThumbnail:) withObserver:nil];
    
    else  return;
}

-(BOOL)isTableBottom
{
    if ((self.tb_messages.contentSize.height - self.tb_messages.contentOffset.y) > self.tb_messages.frame.size.height + 80 ) {
        return FALSE;
    }
    return TRUE;
}

#pragma mark - update WowTalk button

-(void)updateWowTalk
{
    //TODO: have to change to yuanqutong.
    NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.com/apps/wowtalk"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark -
#pragma mark Income Message
-(void)fProcessNewIncomeMsg:(ChatMessage*)msg
{
    msg.ioType = [ChatMessage IOTYPE_INPUT_READED];  // user is in the msgcomposer, msg is readed.
    
    [self addMessageToMessageArray:msg];
    
    if (![msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM]]&& ![msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM]]){
        [WowTalkVoipIF fNotifyMessageReaded:[NSString stringWithFormat:@"%zi", msg.remoteKey] forUser:msg.chatUserName];
    }
    
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow: [[self.listOfMessages objectAtIndex:[self.dateOfMessages count]-1] count] inSection:[self.dateOfMessages count]-1];
    // download the message thumbnail from the internet if it is a multimedia msg.
    
    if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]||[msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]]){
        [self startDownloadingThumbnail:msg WithIndexpath:indexPath];

    }
    
    [Database setChatMessageReaded:msg];
    
    self._recordCnt++;
    
    // check whether it is viewing the history.
    if ([self isTableBottom]) {
        [self refreshMessageTableScrollToBottom:YES Animation:YES];
    }
    else
        [self refreshMessageTableScrollToBottom:FALSE Animation:FALSE];
    
}

#pragma mark -
#pragma mark Send Messages
-(void)forwardSelectedMessage:(ChatMessage*)forwardedmsg
{
    self._recordCnt++;
    
    ChatMessage* msg= [[[ChatMessage alloc]init] autorelease];
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.msgType = [ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE];
    
    msg.messageContent = forwardedmsg.messageContent;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.ioType = [ChatMessage IOTYPE_OUTPUT];
        msg.primaryKey = [Database storeNewChatMessage:msg];
        [WowTalkWebServerIF groupChat_SendMessage:msg toGroup:self._userName withCallback:@selector(didSendChatByWebIF:) withObserver:nil];
        
    }
    else{
        [WowTalkWebServerIF sendBuddyMessage:msg];
    }
    
    [self addMessageToMessageArray:msg];
    self.txtView_Input.text=@"";
    
    int diff = self.uv_defaultoperationbar.frame.size.height - 40;
    self.uv_barcontainer.frame = CGRectMake(0, self.uv_barcontainer.frame.origin.y + diff, self.uv_barcontainer.frame.size.width, self.uv_barcontainer.frame.size.height-diff);
    [self.uv_defaultoperationbar setFrame:CGRectMake(0, 0, 320, 40)];
    
    self.txtView_Input.frame = CGRectMake(75, 5, 185, 30);
    
    if ([self.expressionPickView superview]!=nil) {
        
        self.expressionPickView.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_defaultoperationbar.frame.size.height, self.expressionPickView.frame.size.width, self.expressionPickView.frame.size.height);
    }
    
    if ([self.uv_moreoperationbar superview]!=nil) {
        self.uv_moreoperationbar.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_defaultoperationbar.frame.size.height, self.uv_moreoperationbar.frame.size.width, self.uv_moreoperationbar.frame.size.height);
        
    }
    
    [self.iv_inputbox_bg setFrame: CGRectMake(75, 5, 185, 30)];
    self.btn_send.frame = CGRectMake(265, 4, 50, 32);
    self.btn_stamp.frame = CGRectMake(40, 4, 30, 32);
    self.btn_showmore.frame = CGRectMake(5, 4, 30, 32);
    self.btn_keyboard.frame = CGRectMake(40, 4, 30, 32);
    
    [self refreshMessageTableScrollToBottom:YES Animation:YES];
    
}


-(void)sendFirstMessage
{
    
    self._recordCnt++;
    
    ChatMessage* msg= [[[ChatMessage alloc]init] autorelease];
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.msgType = [ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE];
    
    msg.messageContent = [NSString stringWithFormat:@"我已通过了你的好友请求，让我们开始聊天吧"];
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    [WowTalkWebServerIF sendBuddyMessage:msg];
    
    [self addMessageToMessageArray:msg];
    self.txtView_Input.text=@"";
    
    int diff = self.uv_defaultoperationbar.frame.size.height - 40;
    self.uv_barcontainer.frame = CGRectMake(0, self.uv_barcontainer.frame.origin.y + diff, self.uv_barcontainer.frame.size.width, self.uv_barcontainer.frame.size.height-diff);
    [self.uv_defaultoperationbar setFrame:CGRectMake(0, 0, 320, 40)];
    
    self.txtView_Input.frame = CGRectMake(75, 5, 185, 30);
    
    if ([self.expressionPickView superview]!=nil) {
        
        self.expressionPickView.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_defaultoperationbar.frame.size.height, self.expressionPickView.frame.size.width, self.expressionPickView.frame.size.height);
    }
    
    if ([self.uv_moreoperationbar superview]!=nil) {
        self.uv_moreoperationbar.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_defaultoperationbar.frame.size.height, self.uv_moreoperationbar.frame.size.width, self.uv_moreoperationbar.frame.size.height);
        
    }
    
    [self.iv_inputbox_bg setFrame: CGRectMake(75, 5, 185, 30)];
    self.btn_send.frame = CGRectMake(265, 4, 50, 32);
    self.btn_stamp.frame = CGRectMake(40, 4, 30, 32);
    self.btn_showmore.frame = CGRectMake(5, 4, 30, 32);
    self.btn_keyboard.frame = CGRectMake(40, 4, 30, 32);
    
    [self refreshMessageTableScrollToBottom:YES Animation:YES];
}


-(void)sendTextMessage
{
    /*
    BOOL isFridend = [Database isFriendWithUID:_buddy.userID]; // 是否是好友
    BOOL isSchoolMember = [Database isSchollMember:_buddy.userID];  // 是否死学校成员
    //    BOOL isSelf = [[WTUserDefaults getUid] isEqualToString:_buddy.userID];// 是否是当前用户
    if ( !isFridend  && !isSchoolMember){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"你们还不是好友，请先添加好友后再聊天",nil) delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1];
        return;
    }
     */
    
    
    if (![self.txtView_Input hasText] || self._userName==nil){
        UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Message can't be empty", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertview show];
        [alertview release];
        
        return;
    }
    self._recordCnt++;
    
    ChatMessage* msg= [[[ChatMessage alloc]init] autorelease];
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.msgType = [ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE];
    
    msg.messageContent = self.txtView_Input.text;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.ioType = [ChatMessage IOTYPE_OUTPUT];
        msg.primaryKey = [Database storeNewChatMessage:msg];
        [WowTalkWebServerIF groupChat_SendMessage:msg toGroup:self._userName withCallback:@selector(didSendChatByWebIF:) withObserver:nil];
        
    }
    else{
        [WowTalkWebServerIF sendBuddyMessage:msg];
    }
    
    [self addMessageToMessageArray:msg];
    self.txtView_Input.text=@"";
    
    int diff = self.uv_defaultoperationbar.frame.size.height - 40;
    self.uv_barcontainer.frame = CGRectMake(0, self.uv_barcontainer.frame.origin.y + diff, self.uv_barcontainer.frame.size.width, self.uv_barcontainer.frame.size.height-diff);
    [self.uv_defaultoperationbar setFrame:CGRectMake(0, 0, 320, 40)];
    
    self.txtView_Input.frame = CGRectMake(75, 5, 185, 30);
    
    if ([self.expressionPickView superview]!=nil) {
        
        self.expressionPickView.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_defaultoperationbar.frame.size.height, self.expressionPickView.frame.size.width, self.expressionPickView.frame.size.height);
    }
    
    if ([self.uv_moreoperationbar superview]!=nil) {
        self.uv_moreoperationbar.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_defaultoperationbar.frame.size.height, self.uv_moreoperationbar.frame.size.width, self.uv_moreoperationbar.frame.size.height);
        
    }
    
    [self.iv_inputbox_bg setFrame: CGRectMake(75, 5, 185, 30)];
    self.btn_send.frame = CGRectMake(265, 4, 50, 32);
    self.btn_stamp.frame = CGRectMake(40, 4, 30, 32);
    self.btn_showmore.frame = CGRectMake(5, 4, 30, 32);
    self.btn_keyboard.frame = CGRectMake(40, 4, 30, 32);
    
    [self refreshMessageTableScrollToBottom:YES Animation:YES];
}




// Method to handle the scoll to the bottom.
-(void)refreshMessageTableScrollToBottom:(BOOL)isScrollToBottom Animation:(BOOL)isAnimated{
    
    
    
    self.tb_messages.frame =  CGRectMake(self.tb_messages.frame.origin.x, self.tb_messages.frame.origin.y ,self.view.frame.size.width, self.uv_barcontainer.frame.origin.y);//-[UISize heightOfStatusBarAndNavBar]);
    
    [self.tb_messages reloadData];
    
    if (isScrollToBottom){
        NSUInteger sections = [self.tb_messages numberOfSections];
        if (sections>0){
            NSUInteger rows = [self.tb_messages numberOfRowsInSection:(sections-1)];
            
            if (rows>0){
                [self.tb_messages scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(rows-1) inSection:(sections-1)]
                                        atScrollPosition:UITableViewScrollPositionBottom animated:isAnimated];
            }
            
        }
        
    }
}



#pragma mark -
#pragma mark table Handle

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(tableView == self.tb_messages)
        return [self.dateOfMessages count];
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.tb_messages){
        return [[self.listOfMessages objectAtIndex:section] count] +1;
        
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tb_messages)
    {
        // add a time cell here.
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"SectionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc]
                         initWithStyle:UITableViewCellStyleDefault
                         reuseIdentifier:CellIdentifier]
                        autorelease];
                
                if (IS_IOS7) {
                  cell.backgroundColor = [UIColor whiteColor];
                }
                
                
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [Colors blackColor];
            cell.textLabel.tag = TAG_MESSAGE_DATE;
            cell.textLabel.text = [self.dateOfMessages objectAtIndex:(indexPath.section)];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
        else
        {
            ChatMessage* msg=(ChatMessage*)[[self.listOfMessages objectAtIndex:([indexPath section])] objectAtIndex:[indexPath row]-1];
            
            //========================================LOG  TYPE=================================
            if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_CALL_LOG]])
            {
                
                SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
                
                NSString* direction = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:CALL_DIRECTION];
                if ([direction isEqualToString:@"out"]) {
                    
                    static NSString *CellIdentifier = @"CallOutgoingCell";
                    
                    CallOutgoingCell *cell = (CallOutgoingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"CallOutgoingCell" owner:nil options:nil];
                        cell = [topLevelObject objectAtIndex:0];
                        
                        //show time label;
                        
                        cell.lbl_senttime.backgroundColor = [UIColor clearColor];
                        cell.lbl_senttime.font = [UIFont boldSystemFontOfSize:10];
                        cell.lbl_senttime.textAlignment = NSTextAlignmentCenter;
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension: OUTGOINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        cell.iv_bg.image = newImage;
                        cell.lbl_senttime.textColor = [Colors chatTimeTextColor_R];
                        
                        CGFloat screenwidth = [UISize screenWidth];
                        
                        cell.iv_bg.frame = CGRectMake(screenwidth - OUTGOINGCELL_BG_DIST_R - DEFAULT_CALLCELL_BG_W, 0, DEFAULT_CALLCELL_BG_W + BG_TAIL_WIDTH, DEFAULT_CALLCELL_BG_H);
                        
                        cell.btn_call.frame = cell.iv_bg.frame;
                        
                        // TODO: problem when used in wowcity. layout again
                        cell.lbl_msg.frame = CGRectMake(cell.iv_bg.frame.origin.x + DURATION_LABEL_L_OFFSET_X,  (DEFAULT_CALLCELL_BG_H - BG_TAIL_HEIGHT - DEFAULT_CALLCELL_BG_H)/2 , DURATION_LABEL_W, DEFAULT_CALLCELL_BG_H);
                        
                        cell.iv_call.frame = CGRectMake(cell.iv_bg.frame.origin.x+IMAGE_PLAY_OFFSET_R_X,  (DEFAULT_CALLCELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAY_INIT_R_H)/2, IMAGE_PLAY_INIT_R_W, IMAGE_PLAY_INIT_R_H);  //same with voice message
                        
                        cell.lbl_senttime.frame = CGRectMake(cell.iv_bg.frame.origin.x - SENTTIMELABEL_W -OUTGOINGCELL_SENTTIMELABEL_BG_OFFSET_X , OUTGOINGCELL_SENTTIMELABEL_Y , SENTTIMELABEL_W, SENTTIMELABEL_H);
                        
                        [cell.iv_call setImage:[UIImage imageNamed:@"call_right.png"]];
                        
                        if (IS_IOS7) {
                            cell.contentView.backgroundColor = [UIColor whiteColor];
                        }
                    }
                    
                    cell.parent = self;
                    
                    cell.lbl_senttime.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    
                    NSString* durationstring = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:CALL_DURATION];
                    if(durationstring == nil || [durationstring isEqualToString:@""])
                    {
                        durationstring = @"0";
                    }
                    //     NSLog(@"duration for a call: %@",durationstring);
                    cell.lbl_msg.text = [TimeHelper getTimeFromSeconds:[durationstring intValue]];
                    cell.lbl_msg.textColor = [Colors chatTextColor_R];
                    cell.lbl_msg.font = [UIFont boldSystemFontOfSize:16];
                    
                    [cell setNeedsLayout];
                    
                    return cell;
                }
                
                else if ([direction isEqualToString:@"in"]){
                    
                    static NSString *CellIdentifier = @"CallIncomingCell";
                    
                    CallIncomingCell *cell = (CallIncomingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"CallIncomingCell" owner:nil options:nil];
                        cell = [topLevelObject objectAtIndex:0];
                        
                        //profile label;
                        cell.iv_profile.frame = CGRectMake(INCOMINGCELL_PROFILE_X, INCOMINGCELL_PROFILE_Y, INCOMINGCELL_PROFILE_W, INCOMINGCELL_PROFILE_H);
                        
                        [cell.iv_profile setImage:self.imageForProfile];
                        
                        // bg set up;
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:INCOMINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        
                        cell.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, DEFAULT_CALLCELL_BG_W, DEFAULT_CALLCELL_BG_H);
                        cell.iv_bg.image = newImage;
                        
                        //time label;
                        cell.lbl_senttime.textColor = [Colors chatTimeTextColor_L];
                        cell.lbl_senttime.backgroundColor = [UIColor clearColor];
                        cell.lbl_senttime.font = [UIFont boldSystemFontOfSize:10];
                        
                        cell.lbl_senttime.textAlignment = NSTextAlignmentCenter;
                        
                        cell.lbl_senttime.frame = CGRectMake(INCOMINGCELL_BG_X+ cell.iv_bg.frame.size.width+INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_X, INCOMINGCELL_BG_Y + cell.iv_bg.frame.size.height-INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_Y - SENTTIMELABEL_H, SENTTIMELABEL_W, SENTTIMELABEL_H);
                        
                        // play button
                        cell.btn_call.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, DEFAULT_CALLCELL_BG_W, DEFAULT_CALLCELL_BG_H);
                        
                        // duration lable;
                        cell.lbl_msg.frame =  CGRectMake(INCOMINGCELL_BG_X+DURATION_LABEL_L_OFFSET_X, INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + (DEFAULT_CALLCELL_BG_H - BG_TAIL_HEIGHT - DURATION_LABEL_H)/2, DURATION_LABEL_W, DURATION_LABEL_H);
                        
                        cell.lbl_msg.textColor = [Colors chatTextColor_L];
                        
                        cell.iv_call.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + (DEFAULT_CALLCELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAY_INIT_L_H)/2, IMAGE_PLAY_INIT_L_W, IMAGE_PLAY_INIT_L_H);
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        cell.btn_viewbuddy = [[[UIButton alloc] initWithFrame:cell.iv_profile.frame] autorelease];
                        [cell.btn_viewbuddy addTarget:cell action:@selector(viewBuddy) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btn_viewbuddy setBackgroundColor:[UIColor clearColor]];
                        [cell.contentView addSubview:cell.btn_viewbuddy];
                        
                        if (IS_IOS7) {
                            cell.contentView.backgroundColor = [UIColor whiteColor];
                        }
                        
                    }
                    
                    cell.parent = self;
                    cell.msg = msg;
                    // duration
                    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
                    
                    NSString* durationstring = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:CALL_DURATION];
                    
                    if(durationstring == nil || [durationstring isEqualToString:@""])
                    {
                        durationstring = @"0";
                    }
                    
                    cell.lbl_msg.text = [TimeHelper getTimeFromSeconds:[durationstring intValue]];
                    cell.lbl_msg.font = [UIFont boldSystemFontOfSize:16];
                    
                    NSString* result = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:CALL_RESULT_TYPE];
                    if ([result isEqualToString:@"0"]) {
                        cell.lbl_msg.textColor = [Colors chatTextColor_L];
                        [cell.iv_call setImage:[UIImage imageNamed:@"call_left.png"]];
                    }
                    else  if ([result isEqualToString:@"1"]){
                        cell.lbl_msg.textColor = [Colors orangeColor];
                        [cell.iv_call setImage:[UIImage imageNamed:@"call_missed.png"]];
                        cell.lbl_msg.text = NSLocalizedString(@"Missed call", nil);
                        cell.lbl_msg.adjustsFontSizeToFitWidth = TRUE;
                        cell.lbl_msg.minimumScaleFactor = 7;
                        
                    }
                    
                    cell.lbl_senttime.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    [cell setNeedsLayout];
                    
                    return cell;
                    
                }
                
                
            }
            //----------------------------------- MESSAGE TYPE=======================================
            
            // output cell;
            if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
            {
                
                // normal text message cell;
                if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]])
                {
                    
                    static NSString *CellIdentifier = @"TextOutgoingCell";
                    
                    TextOutgoingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"TextOutgoingCell" owner:nil options:nil];
                        cell = [topLevelObject objectAtIndex:0];
                        
                        [cell.btn_resend setBackgroundImage: [PublicFunctions imageNamedWithNoPngExtension:FAILMAEK_FILENAME] forState:UIControlStateNormal];
                        [cell.btn_resend addTarget:cell action:@selector(ResendTextMessage) forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.lbl_msg.font = [UIFont systemFontOfSize:TEXTCELL_FONT];
                        cell.lbl_msg.textColor = [Colors chatTextColor_R];
                        cell.lbl_msg.numberOfLines = 0; //---display multiple lines---
                        cell.lbl_msg.backgroundColor = [UIColor clearColor];
                        cell.lbl_msg.lineBreakMode = NSLineBreakByClipping;
                        
                        cell.lbl_status.backgroundColor = [UIColor clearColor];
                        cell.lbl_senttime.backgroundColor = [UIColor clearColor];
                        
                        cell.lbl_status.font = [UIFont systemFontOfSize:10];
                        cell.lbl_senttime.font = [UIFont boldSystemFontOfSize:10];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.contentView.backgroundColor = [Colors chatRoomBackgroundColor];
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension: OUTGOINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        cell.iv_bg.image = newImage;
                        
                        cell.lbl_senttime.textColor = [Colors chatTimeTextColor_R];
                    }
                    
                    cell.btn_resend.hidden = TRUE;
                    
                    cell.parent = self;
                    cell.msg = msg;
                    
                    cell.lbl_senttime.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    cell.lbl_msg.text = msg.messageContent;
                    cell.lblText.text = msg.messageContent;
                    
                    [cell setNeedsLayout];
                    
                    return cell;
                    
                }
                
                
                // multumedia voice note;
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]])
                {
                    
                    static NSString *CellIdentifier = @"RecorderOutGoingCell";
                    
                    RecorderOutGoingCell *cell = (RecorderOutGoingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"RecorderOutGoingCell" owner:nil options:nil];
                        cell = [topLevelObject objectAtIndex:0];
                        
                        
                        [cell.btn_resend setBackgroundImage: [PublicFunctions imageNamedWithNoPngExtension:FAILMAEK_FILENAME] forState:UIControlStateNormal];
                        [cell.btn_resend addTarget:cell action:@selector(resendVoiceMessage) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        cell.lbl_sentlabel.font = [UIFont systemFontOfSize:10];
                        
                        //show time label;
                        
                        cell.lbl_senttimeLabel.backgroundColor = [UIColor clearColor];
                        
                        
                        cell.lbl_senttimeLabel.font = [UIFont boldSystemFontOfSize:10];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:OUTGOINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        cell.iv_bg.image = newImage;
                        cell.lbl_senttimeLabel.textColor = [Colors chatTimeTextColor_R];
                        cell.progressView = [[[PDColoredProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
                        [cell.progressView setTintColor: [Colors orangeColor]];
                        [cell.contentView addSubview:cell.progressView];
                        
                    }
                    cell.btn_resend.hidden = TRUE;
                    
                    cell.progressView.hidden = TRUE;
                    
                    
                    cell.parent = self;
                    cell.msg = msg;
                    cell.indexPath = indexPath;
                    
                    cell.lbl_senttimeLabel.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
                    
                    NSString* durationstring = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:DURATION];
                    if(durationstring == nil || [durationstring isEqualToString:@""])
                    {
                        durationstring = @"0";
                    }
                    cell.totalLength = [durationstring intValue];
                    
                    cell.lbl_duration.text = [TimeHelper getTimeFromSeconds:[durationstring intValue]];
                    cell.lbl_duration.textColor = [Colors chatTextColor_R];
                    cell.lbl_duration.font = [UIFont boldSystemFontOfSize:16];
                    
                    WTNetworkTask* task = [[WTNetworkTaskManager defaultManager] taskforMessage:msg];
                    if (task && !task.isDataTransferDone) {
                        // start a timer and get the value of the progress view;
                        if (task.timer!=nil || [task.timer isValid]) {
                            [task.timer invalidate];
                            task.timer = nil;
                        }
                        
                        if (task.timer == nil) {
                            task.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:cell selector:@selector(getUploadProgress:) userInfo:task repeats:YES];
                            [task.timer fire];
                            cell.progressView.hidden = FALSE;
                            msg.fileTransfering = TRUE;
                            
                        }
                    }
                    
                    [cell setNeedsLayout];
                    
                    return cell;
                    
                }
                
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]] || [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]] || [msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]])
                {
                    
                    static NSString *CellIdentifier = @"MultimediaOutgoingCell";
                    
                    MultimediaOutgoingCell *cell = (MultimediaOutgoingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"MultimediaOutgoingCell" owner:nil options:nil];
                        cell = [topLevelObject objectAtIndex:0];
                        
                        cell.iv_content.layer.cornerRadius = CornerRadius;
                        cell.iv_content.layer.masksToBounds = YES;
                        
                        
                        cell.lbl_sentlabel.font = [UIFont systemFontOfSize:10];
                        
                        //show time label;
                        
                        
                        cell.lbl_senttimeLabel.backgroundColor = [UIColor clearColor];
                        
                        cell.lbl_senttimeLabel.font = [UIFont boldSystemFontOfSize:10];
                        
                        [cell.btn_resend addTarget:cell action:@selector(resendPhotoMessage) forControlEvents:UIControlEventTouchUpInside];
                        
//                        [cell.btn_resend setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:ERROR_INDICATOR] forState:UIControlStateNormal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension: OUTGOINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        cell.iv_bg.image = newImage;
                        
                        //      cell.lbl_sentlabel.textColor = [Theme sharedInstance].currentColorForOutgoingChatCellRecipient;
                        cell.lbl_senttimeLabel.textColor = [Colors chatTimeTextColor_R];
                        
                        cell.progressView = [[[PDColoredProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
                        [cell.progressView setTintColor: [Colors orangeColor]];
                        [cell.contentView addSubview:cell.progressView];
                        
                    }
                    
                    
                    cell.btn_resend.hidden = TRUE;
                    
                    cell.progressView.hidden = TRUE;
                    
                    
                    cell.parent = self;
                    cell.msg = msg;
                    cell.indexPath = indexPath;
                    
                    [cell.btn_view removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
                    
                    if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]] )
                    {
                        [cell.btn_view addTarget:cell action:@selector(viewThePhoto) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btn_view setImage:nil forState:UIControlStateNormal];
                    }
                    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
                    {
                        [cell.btn_view addTarget:cell action:@selector(watchTheMovie) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btn_view setImage:[PublicFunctions imageNamedWithNoPngExtension:PLAY_VIDEO] forState:UIControlStateNormal];
                        
                    }
                    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]])
                    {
                        [cell.btn_view addTarget:cell action:@selector(watchThePicVoice) forControlEvents:UIControlEventTouchUpInside];

                        [cell.btn_view setImage:[PublicFunctions imageNamedWithNoPngExtension:@"messages_preview_icon_left_green"] forState:UIControlStateNormal];
                        
                    }

                    
                    cell.lbl_senttimeLabel.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    WTNetworkTask* task = [[WTNetworkTaskManager defaultManager] taskforMessage:msg];
                    if (task && !task.isDataTransferDone ) {
                        // start a timer and get the value of the progress view;
                        if (task.timer!=nil || [task.timer isValid]) {
                            [task.timer invalidate];
                            task.timer = nil;
                        }
                        
                        if (task.timer == nil) {
                            task.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:cell selector:@selector(getUploadProgress:) userInfo:task repeats:YES];
                            [task.timer fire];
                            cell.progressView.hidden = FALSE;
                            msg.fileTransfering = TRUE;
                            
                        }
                    }
                    
                    [cell setNeedsLayout];
                    
                    return cell;
                    
                    
                }
                
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_LOCATION]])
                {
                    
                    static NSString *CellIdentifier = @"LocationOutgoingCell";
                    
                    LocationOutgoingCell *cell = (LocationOutgoingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"LocationOutgoingCell" owner:nil options:nil];
                        cell = [topLevelObject objectAtIndex:0];
                        
                        cell.iv_bg.frame = CGRectMake([UISize screenWidth] - OUTGOINGCELL_BG_DIST_R - MAP_W-CHATCELL_CONTENT_THIN_OFFSET_X*2 , 0 , MAP_W +CHATCELL_CONTENT_THIN_OFFSET_X*2 + BG_TAIL_WIDTH, MAP_H+ CHATCELL_CONTENT_THIN_OFFSET_Y*2+ BG_TAIL_HEIGHT);
                        
                        [cell.iv_content setFrame:CGRectMake([UISize screenWidth] - OUTGOINGCELL_BG_DIST_R - MAP_W-CHATCELL_CONTENT_THIN_OFFSET_X, CHATCELL_CONTENT_THIN_OFFSET_Y, MAP_W, MAP_H)];
                        
                        
                        cell.iv_content.layer.cornerRadius = CornerRadius;
                        cell.iv_content.layer.masksToBounds = YES;
                        
                        cell.iv_content.image = [PublicFunctions imageNamedWithNoPngExtension:DEFAULT_LOCATION_IMAGE];
                        
                        cell.lbl_address.numberOfLines = 2;
                        cell.lbl_address.textAlignment = NSTextAlignmentLeft;
                        cell.lbl_address.lineBreakMode = NSLineBreakByClipping;
                        cell.lbl_address.font = [UIFont systemFontOfSize:ADDRESS_TEXT_FONT];
                        cell.lbl_address.textColor = [Colors whiteColor];
                        // [cell.iv_content addSubview:cell.lbl_address];
                        
                        
                        cell.lbl_status.font = [UIFont systemFontOfSize:10];
                        
                        //show time label;
                        
                        cell.lbl_senttime.backgroundColor = [UIColor clearColor];
                        
                        cell.lbl_senttime.font = [UIFont boldSystemFontOfSize:10];
                        
                        [cell.btn_resend addTarget:cell action:@selector(resendLocationMessage) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btn_resend setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:ERROR_INDICATOR] forState:UIControlStateNormal];
                        
                        
                        
                        cell.lbl_status.frame = CGRectMake(cell.iv_bg.frame.origin.x-OUTGOINGCELL_STATUS_BG_OFFSET_X -OUTGOINGCELL_STATUS_W, OUTGOINGCELL_STATUS_Y , OUTGOINGCELL_STATUS_W, OUTGOINGCELL_STATUS_H);
                        cell.lbl_senttime.frame = CGRectMake(cell.iv_bg.frame.origin.x-OUTGOINGCELL_SENTTIMELABEL_BG_OFFSET_X-SENTTIMELABEL_W , OUTGOINGCELL_SENTTIMELABEL_Y , SENTTIMELABEL_W, SENTTIMELABEL_H);
                        
                        
                        cell.btn_resend.frame = CGRectMake(cell.iv_bg.frame.origin.x-OUTGOINGCELL_FAILMARK_BG_OFFSET_X - OUTGOINGCELL_FAILMARK_W, (cell.iv_bg.frame.size.height-BG_TAIL_HEIGHT-OUTGOINGCELL_FAILMARK_H)/2 , OUTGOINGCELL_FAILMARK_W, OUTGOINGCELL_FAILMARK_H);
                        
                        [cell.btn_view setFrame:cell.iv_bg.frame];
                        
                        cell.btn_view.clipsToBounds = NO;
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:OUTGOINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        
                        cell.iv_bg.image = newImage;
                        
                        //       cell.lbl_status.textColor = [Theme sharedInstance].currentColorForOutgoingChatCellRecipient;
                        cell.lbl_senttime.textColor = [Colors chatTimeTextColor_R];
                        
                    }
                    cell.btn_resend.hidden = TRUE;
                    
                    cell.parent = self;
                    cell.msg = msg;
                    
                    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
                    NSString* address = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:ADDRESS];
                    
                    cell.lbl_address.text = address;
                    
                    [cell.lbl_address setFrame:CGRectMake(cell.iv_content.frame.origin.x+ADDRESSLABEL_OFFSET_X, cell.iv_content.frame.origin.y, MAP_W-2*ADDRESSLABEL_OFFSET_X, ADDRESSLABEL_HEIGHT)];
                    
                    
                    cell.lbl_senttime.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    
                    [cell setNeedsLayout];
                    
                    return cell;
                }
                
            }
            // incoming message;
            else
            {
                
                // text message;
                if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]])
                {
                    
                    static NSString *CellIdentifier = @"TextIncomingCell";
                    
                    TextIncomingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"TextIncomingCell" owner:nil options:nil];
                        
                        cell = [topLevelObject objectAtIndex:0];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:INCOMINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        cell.iv_bg.image = newImage;
                        
                        if (!self.isGroupMode) {
                            cell.headImageView.buddy = _buddy;
//                            cell.headImageView.headImage = self.imageForProfile;
                            
                            cell.lbl_name.hidden = YES;
                            cell.lbl_name.text  = _compositeName;
                        }
                        
                        cell.lbl_name.backgroundColor = [UIColor clearColor];
                        cell.lbl_name.textColor = [Colors chatTextColor_L];
                        cell.lbl_name.font = [UIFont systemFontOfSize:10];
                        cell.lbl_name.textAlignment = NSTextAlignmentLeft;
                        //    cell.lbl_name.text  = _compositeName;
                        
                        cell.lbl_senttime.textColor = [Colors chatTimeTextColor_L];
                        cell.lbl_senttime.backgroundColor = [UIColor clearColor];
                        cell.lbl_senttime.font = [UIFont boldSystemFontOfSize:10];
                        
                        cell.lbl_msg.font = [UIFont systemFontOfSize:TEXTCELL_FONT];
                        cell.lbl_msg.textColor = [Colors chatTextColor_L];
                        cell.lbl_msg.backgroundColor = [UIColor clearColor];
                        cell.lbl_msg.numberOfLines = 0; //---display multiple lines---
                        cell.lbl_msg.lineBreakMode = NSLineBreakByClipping;
                        
                        cell.lblText.font = [UIFont systemFontOfSize:TEXTCELL_FONT];
                        
                        cell.contentView.backgroundColor = [Colors chatRoomBackgroundColor];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        cell.btn_viewbuddy = [[[UIButton alloc] initWithFrame:cell.headImageView.frame] autorelease];
                        [cell.btn_viewbuddy addTarget:cell action:@selector(viewBuddy) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btn_viewbuddy setBackgroundColor:[UIColor clearColor]];
                        [cell.contentView addSubview:cell.btn_viewbuddy];
                    }
                    if (self.isGroupMode) {
                        cell.headImageView.buddy = [Database buddyWithUserID:msg.groupChatSenderID];
                        cell.headImageView.headImage = [self getMessageBuddyProfile:msg];
                        cell.lbl_name.hidden = FALSE;
                        cell.lbl_name.text = [[Database buddyWithUserID:msg.groupChatSenderID] nickName];
                    }
                    
                    
                    cell.parent = self;
                    cell.msg = msg;
                    
                    cell.lbl_msg.text = msg.messageContent;
                    cell.lblText.text = msg.messageContent;
                    cell.lbl_senttime.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    [cell setNeedsLayout];
                    
                    return cell;
                    
                }
                
                // multimedia voice note;
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]])
                {
                    
                    
                    static NSString *CellIdentifier = @"RecorderIncomingCell";
                    
                    RecorderIncomingCell *cell = (RecorderIncomingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"RecorderIncomingCell" owner:nil options:nil];
                        cell = [topLevelObject objectAtIndex:0];
                        
                        //profile label;

                        if(!self.isGroupMode){
                            cell.headImageView.buddy = _buddy;
                            cell.headImageView.headImage = self.imageForProfile;
                        }
                        // bg set up;
                        // UIImage * preImage = [[Theme sharedInstance] tileColoredImageWithName:INCOMINGCELL_BG_FILENAME];
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:INCOMINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        
                        if (self.isGroupMode) {
                            cell.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, DEFAULT_VOICECELL_BG_W, DEFAULT_VOICECELL_BG_H + INCOMINGCELL_NAME_H);
                        }
                        else
                            cell.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, DEFAULT_VOICECELL_BG_W, DEFAULT_VOICECELL_BG_H);
                        
                        cell.iv_bg.image = newImage;
                        
                        // name label;
                        cell.lbl_name.frame = CGRectMake(INCOMINGCELL_NAME_X, INCOMINGCELL_NAME_Y, INCOMINGCELL_NAME_W, INCOMINGCELL_NAME_H);
                        cell.lbl_name.backgroundColor = [UIColor clearColor];
                        cell.lbl_name.textColor = [Colors chatTextColor_L];
                        cell.lbl_name.font = [UIFont systemFontOfSize:10];
                        cell.lbl_name.textAlignment = NSTextAlignmentLeft;
                        
                        if (!self.isGroupMode) {
                            cell.lbl_name.text  = self._compositeName;
                        }
                        //time label;
                        cell.lbl_senttimeLabel.textColor = [Colors chatTimeTextColor_L];
                        cell.lbl_senttimeLabel.backgroundColor = [UIColor clearColor];
                        cell.lbl_senttimeLabel.font = [UIFont boldSystemFontOfSize:10];
                        cell.lbl_senttimeLabel.frame = CGRectMake(INCOMINGCELL_BG_X+ cell.iv_bg.frame.size.width+INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_X, INCOMINGCELL_BG_Y + cell.iv_bg.frame.size.height-INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_Y - SENTTIMELABEL_H, SENTTIMELABEL_W, SENTTIMELABEL_H);
                        
                        // play button
                        cell.btn_play.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, DEFAULT_VOICECELL_BG_W, DEFAULT_VOICECELL_BG_H);
                        [cell.btn_play addTarget:cell action:@selector(downloadAndPlayVoiceMessage) forControlEvents:UIControlEventTouchUpInside];
                        
                        // duration lable;
                        if (self.isGroupMode) {
                            cell.lbl_duration.frame =  CGRectMake(INCOMINGCELL_BG_X+DURATION_LABEL_L_OFFSET_X, INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + INCOMINGCELL_NAME_H + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - DURATION_LABEL_H)/2, DURATION_LABEL_W, DURATION_LABEL_H);
                        }
                        else
                            cell.lbl_duration.frame =  CGRectMake(INCOMINGCELL_BG_X+DURATION_LABEL_L_OFFSET_X, INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - DURATION_LABEL_H)/2, DURATION_LABEL_W, DURATION_LABEL_H);
                        
                        cell.lbl_duration.textColor = [Colors whiteColor];
                        
                        // status
                        cell.iv_status.frame = CGRectMake(INCOMINGCELL_BG_X + DEFAULT_VOICECELL_BG_W +LISTEN_STATUS_OFFSET_X, LISTEN_STATUS_OFFSET_Y, LISTEN_STATUS_W, LISTEN_STATUS_H);
                        [cell.iv_status setImage:[PublicFunctions imageNamedWithNoPngExtension:INDICATOR]];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        cell.progressView = [[[PDColoredProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
                        [cell.progressView setTintColor: [Colors orangeColor]];
                        
                        [cell.contentView addSubview:cell.progressView];
                        
                        
                        cell.btn_viewbuddy = [[UIButton alloc] initWithFrame:cell.headImageView.frame];
                        [cell.btn_viewbuddy addTarget:cell action:@selector(viewBuddy) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btn_viewbuddy setBackgroundColor:[UIColor clearColor]];
                        [cell.contentView addSubview:cell.btn_viewbuddy];
                        [cell.btn_viewbuddy release];
                        
                        
                        
                    }
                    if (self.isGroupMode) {
                        cell.headImageView.buddy = [Database buddyWithUserID:msg.groupChatSenderID];
                        cell.headImageView.headImage = [self getMessageBuddyProfile:msg];
                    }
                    
                    
                    cell.progressView.hidden = TRUE;
                    
                    cell.parent = self;
                    cell.msg = msg;
                    cell.indexPath = indexPath;
                    
                    cell.lbl_senttimeLabel.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    
                    
                    // duration
                    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
                    
                    NSString* durationstring = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:DURATION];
                    
                    if(durationstring == nil || [durationstring isEqualToString:@""])
                    {
                        durationstring = @"0";
                    }
                    
                    cell.totalLength = [durationstring intValue];
                    
                    cell.lbl_duration.text = [TimeHelper getTimeFromSeconds:[durationstring intValue]];
                    cell.lbl_duration.font = [UIFont boldSystemFontOfSize:16];
                    cell.lbl_duration.textColor = [Colors chatTextColor_L];
                    
                    WTNetworkTask* task = [[WTNetworkTaskManager defaultManager] taskforMessage:msg];
                    if (task && !task.isDataTransferDone) {
                        // start a timer and get the value of the progress view;
                        if (task.timer!=nil || [task.timer isValid]) {
                            [task.timer invalidate];
                            task.timer = nil;
                        }
                        
                        if (task.timer == nil) {
                            task.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:cell selector:@selector(getDownloadProgress:) userInfo:task repeats:YES];
                            [task.timer fire];
                            cell.progressView.hidden = FALSE;
                            msg.fileTransfering = TRUE;
                        }
                    }
                    
                    [cell setNeedsLayout];
                    
                    return cell;
                    
                    
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]] ||[msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]] ||[msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]])
                {
                    
                    static NSString *CellIdentifier = @"MultimediaIncomingCell";
                    
                    MultimediaIncomingCell *cell = (MultimediaIncomingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"MultimediaIncomingCell" owner:nil options:nil];
                        cell = [topLevelObject objectAtIndex:0];
                        
                        //profile label;
                        
                        if (!self.isGroupMode) {
                            cell.headImageView.buddy = _buddy;
                            cell.headImageView.headImage = self.imageForProfile;
                        }
                        // bg image;
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:INCOMINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        cell.iv_bg.image = newImage;
                        
                        // content
                        cell.iv_content.layer.cornerRadius = CornerRadius;
                        cell.iv_content.layer.masksToBounds = YES;
                        
                        // name label;
                        cell.lbl_name.frame = CGRectMake(INCOMINGCELL_NAME_X, INCOMINGCELL_NAME_Y, INCOMINGCELL_NAME_W, INCOMINGCELL_NAME_H);
                        cell.lbl_name.textAlignment = NSTextAlignmentLeft;
                        cell.lbl_name.backgroundColor = [UIColor clearColor];
                        cell.lbl_name.textColor = [Colors chatTextColor_L];
                        cell.lbl_name.font = [UIFont systemFontOfSize:10];
                        
                        if (!self.isGroupMode) {
                            cell.lbl_name.text  = self._compositeName;
                        }
                        
                        
                        //time label;
                        cell.lbl_senttimeLabel.textColor = [Colors chatTimeTextColor_L];
                        cell.lbl_senttimeLabel.backgroundColor = [UIColor clearColor];
                        cell.lbl_senttimeLabel.font = [UIFont boldSystemFontOfSize:10];
                        
                        //view button
                        cell.btn_view.clipsToBounds = NO;
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.progressView = [[[PDColoredProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
                        [cell.progressView setTintColor: [Colors orangeColor]];
                        [cell.contentView addSubview:cell.progressView];
                        
                        
                        cell.btn_viewbuddy = [[[UIButton alloc] initWithFrame:cell.headImageView.frame] autorelease];
                        [cell.btn_viewbuddy addTarget:cell action:@selector(viewBuddy) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btn_viewbuddy setBackgroundColor:[UIColor clearColor]];
                        [cell.contentView addSubview:cell.btn_viewbuddy];
                        
                    }
                    
                    if (self.isGroupMode) {
                        cell.headImageView.buddy = [Database buddyWithUserID:msg.groupChatSenderID];
                        cell.headImageView.headImage = [self getMessageBuddyProfile:msg];
                    }
                    
                    cell.progressView.hidden = TRUE;
                    
                    cell.parent = self;
                    cell.msg = msg;
                    cell.indexPath = indexPath;
                    
                    cell.lbl_senttimeLabel.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    
                    WTNetworkTask* task = [[WTNetworkTaskManager defaultManager] taskforMessage:msg];
                    if (task && !task.isDataTransferDone) {
                        // start a timer and get the value of the progress view;
                        if (task.timer!=nil || [task.timer isValid]) {
                            [task.timer invalidate];
                            task.timer = nil;
                        }
                        
                        if (task.timer == nil) {
                            task.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:cell selector:@selector(getDownloadProgress:) userInfo:task repeats:YES];
                            [task.timer fire];
                            cell.progressView.hidden = FALSE;
                            msg.fileTransfering = TRUE;
                            
                        }
                    }
                    
                    [cell setNeedsLayout];
                    
                    return cell;
                    
                    
                    
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_LOCATION]])
                {
                    
                    static NSString *CellIdentifier = @"LocationIncomingCell";
                    
                    LocationIncomingCell *cell = (LocationIncomingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"LocationIncomingCell" owner:nil options:nil];
                        cell = [topLevelObject objectAtIndex:0];
                        
                        //profile label;
                        
                        if (!self.isGroupMode) {
                            cell.headImageView.buddy = _buddy;
                            cell.headImageView.headImage = self.imageForProfile;
                        }
                        // bg image;
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:INCOMINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        cell.iv_bg.image = newImage;
                        
                        if (self.isGroupMode) {
                            [cell.iv_bg setFrame:CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, 2*CHATCELL_CONTENT_THIN_OFFSET_X+ MAP_W + BG_TAIL_WIDTH, CHATCELL_CONTENT_THIN_OFFSET_Y+MAP_H+BG_TAIL_HEIGHT + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y)];
                            [cell.iv_content setFrame:CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X + BG_TAIL_WIDTH, INCOMINGCELL_BG_Y+BG_TAIL_HEIGHT+ INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y, MAP_W, MAP_H)];
                        }
                        else{
                            [cell.iv_bg setFrame:CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, 2*CHATCELL_CONTENT_THIN_OFFSET_X+ MAP_W + BG_TAIL_WIDTH, 2*CHATCELL_CONTENT_THIN_OFFSET_Y+MAP_H+BG_TAIL_HEIGHT)];
                            [cell.iv_content setFrame:CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X + BG_TAIL_WIDTH, INCOMINGCELL_BG_Y+BG_TAIL_HEIGHT+CHATCELL_CONTENT_THIN_OFFSET_Y, MAP_W, MAP_H)];
                        }
                        
                        // content
                        cell.iv_content.layer.cornerRadius = CornerRadius;
                        cell.iv_content.layer.masksToBounds = YES;
                        cell.iv_content.image= [PublicFunctions imageNamedWithNoPngExtension:DEFAULT_LOCATION_IMAGE];
                        
                        // name label;
                        cell.lbl_name.frame = CGRectMake(INCOMINGCELL_NAME_X, INCOMINGCELL_NAME_Y, INCOMINGCELL_NAME_W, INCOMINGCELL_NAME_H);
                        cell.lbl_name.backgroundColor = [UIColor clearColor];
                        cell.lbl_name.textColor = [Colors chatTextColor_L];
                        cell.lbl_name.font = [UIFont systemFontOfSize:10];
                        cell.lbl_name.textAlignment = NSTextAlignmentLeft;
                        
                        //time label;
                        cell.lbl_senttime.textColor = [Colors chatTimeTextColor_L];
                        cell.lbl_senttime.backgroundColor = [UIColor clearColor];
                        cell.lbl_senttime.font = [UIFont boldSystemFontOfSize:10];
                        cell.lbl_senttime.frame = CGRectMake(INCOMINGCELL_BG_X+ cell.iv_bg.frame.size.width+INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_X, INCOMINGCELL_BG_Y + cell.iv_bg.frame.size.height-INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_Y - SENTTIMELABEL_H, SENTTIMELABEL_W, SENTTIMELABEL_H);
                        
                        //view button
                        [cell.btn_view setFrame:cell.iv_bg.frame];
                        cell.btn_view.clipsToBounds = NO;
                        
                        cell.lbl_address.numberOfLines = 2;
                        cell.lbl_address.textAlignment = NSTextAlignmentLeft;
                        cell.lbl_address.lineBreakMode = NSLineBreakByClipping;
                        cell.lbl_address.textColor = [Colors whiteColor];
                        cell.lbl_address.font = [UIFont systemFontOfSize:ADDRESS_TEXT_FONT];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        cell.btn_viewbuddy = [[UIButton alloc] initWithFrame:cell.headImageView.frame];
                        [cell.btn_viewbuddy addTarget:cell action:@selector(viewBuddy) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btn_viewbuddy setBackgroundColor:[UIColor clearColor]];
                        [cell.contentView addSubview:cell.btn_viewbuddy];
                        [cell.btn_viewbuddy release];
                        
                        
                        if (IS_IOS7) {
                            cell.contentView.backgroundColor = [UIColor whiteColor];
                        }
                        
                    }
                    
                    if (self.isGroupMode) {
                        
                        cell.lbl_name.frame = CGRectMake(INCOMINGCELL_NAME_X, INCOMINGCELL_NAME_Y, INCOMINGCELL_NAME_W, INCOMINGCELL_NAME_H);
                        cell.headImageView.buddy = [Database buddyWithUserID:msg.groupChatSenderID];
                        cell.headImageView.headImage = [self getMessageBuddyProfile:msg];
                        cell.lbl_name.text  = [[Database buddyWithUserID:msg.groupChatSenderID] nickName];
                        [cell.lbl_name setHidden:FALSE];
                        [cell addSubview:cell.lbl_name];
                    }
                    else{
                        cell.lbl_name.text  = self._compositeName;
                        [cell.lbl_name setHidden:TRUE];
                        [cell addSubview:cell.lbl_name];
                    }
                    
                    
                    cell.parent = self;
                    cell.msg = msg;
                    
                    
                    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
                    NSString* address = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:ADDRESS];
                    
                    cell.lbl_address.text = address;
                    
                    [cell.lbl_address setFrame:CGRectMake(cell.iv_content.frame.origin.x + ADDRESSLABEL_OFFSET_X, cell.iv_content.frame.origin.y, MAP_W - 2*ADDRESSLABEL_OFFSET_X, ADDRESSLABEL_HEIGHT)];
                    
                    cell.lbl_senttime.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    return cell;
                    
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM]])
                {
                    NSString* cellIdentifier = @"notificationCell";
                    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (cell == nil) {
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                        [cell setFrame:CGRectMake(0, 0, DEFAULT_NOTIFICATIONCELL_W, DEFAULT_NOTIFICATIONCELL_H)];
                        cell.detailTextLabel.hidden = TRUE;
                        cell.textLabel.hidden = TRUE;
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 15)];
                        label.tag = 101;
                        [cell.contentView addSubview:label];
                        
                        label.textColor = [Colors grayColorThree];
                        label.textAlignment = NSTextAlignmentCenter;
                        label.backgroundColor = [UIColor clearColor];
                        label.font = [UIFont systemFontOfSize:13];
                        [label release];
                    }
                    
                    UILabel* label = (UILabel*)[cell.contentView viewWithTag:101];
                    NSString* str = msg.messageContent;
                    label.text = str;
                    return cell;
                    
                    
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM]])
                {
                    NSString* cellIdentifier = @"notificationCell";
                    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (cell == nil) {
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                        [cell setFrame:CGRectMake(0, 0, DEFAULT_NOTIFICATIONCELL_W, DEFAULT_NOTIFICATIONCELL_H)];
                        cell.detailTextLabel.hidden = TRUE;
                        cell.textLabel.hidden = TRUE;
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 15)];
                        
                        label.tag = 100;
                        [cell.contentView addSubview:label];
                        label.textColor = [Colors grayColorThree];
                        label.textAlignment = NSTextAlignmentCenter;
                        label.backgroundColor = [UIColor clearColor];
                        label.font = [UIFont systemFontOfSize:13];
                        [label release];
                    }
                    
                    UILabel* label = (UILabel*)[cell.contentView viewWithTag:100];
                    NSString* str = msg.messageContent;
                    label.text = str;
                    return cell;
                    
                }

                
                // If it is not text message, show a link to the old version user;
                else
                {
                    static NSString *CellIdentifier = @"IncomeMessageCell_OtherTypes";
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    UIImageView * messageBG = nil;
                    UILabel* messageLabel = nil;
                    UILabel* sentTimeLabel = nil;
                    OMHeadImgeView* headImageView = nil;
                    UILabel* lbl_name = nil;
                    UIButton* btn_toupdate = nil;
                    
                    if (cell == nil)
                    {
                        cell = [[[UITableViewCell alloc]
                                 initWithStyle:UITableViewCellStyleSubtitle
                                 reuseIdentifier:CellIdentifier]
                                autorelease];
                        
                        sentTimeLabel = [[[UILabel alloc] init] autorelease];
                        sentTimeLabel.tag = TAG_SENTTIMELABEL;
                        [cell.contentView addSubview:sentTimeLabel];
                        
                        messageBG = [[[UIImageView alloc] init] autorelease];
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:INCOMINGCELL_BG_FILENAME];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
                        messageBG.image = newImage;
                        messageBG.tag = TAG_MESSAGE_IMAGE;
                        [cell.contentView addSubview:messageBG];
                        
                        messageLabel = [[[UILabel alloc] init] autorelease];
                        messageLabel.tag = TAG_MESSAGE_LABEL;
                        messageLabel.font = [UIFont systemFontOfSize:TEXTCELL_FONT];
                        
                        messageLabel.textColor = [Colors blackColor];
                        messageLabel.backgroundColor = [UIColor clearColor];
                        
                        messageLabel.numberOfLines = 0; //---display multiple lines---
                        messageLabel.lineBreakMode = NSLineBreakByClipping;
                        [cell.contentView addSubview:messageLabel];
                        
                        headImageView = [[[OMHeadImgeView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)] autorelease];
                        headImageView.tag = TAG_PROFILE;
                        [cell.contentView addSubview:headImageView];
                        
                        lbl_name = [[[UILabel alloc] initWithFrame:CGRectMake(45, 5, 200, 12)] autorelease];
                        lbl_name.tag = TAG_BUDDY_NAME;
                        
                        lbl_name.backgroundColor = [UIColor clearColor];
                        lbl_name.textColor = [Colors chatTextColor_L];
                        lbl_name.font = [UIFont systemFontOfSize:10];
                        lbl_name.textAlignment = NSTextAlignmentLeft;
                        
                        [cell.contentView addSubview:lbl_name];
                        
                        
                        btn_toupdate = [[[UIButton alloc] init] autorelease];
                        btn_toupdate.tag = TAG_BUTTON_UPDATE;
                        [cell.contentView addSubview:btn_toupdate];
                        if (!self.isGroupMode) {
                            headImageView.buddy = _buddy;
                            headImageView.headImage = self.imageForProfile;
                        }
                        //TODO: we are not implementing viewing the avatar here, to do this, we have to build cells. leave it for future.
                        
                    }
                    
                    else
                    {
                        messageBG = (UIImageView*)[cell.contentView viewWithTag:TAG_MESSAGE_IMAGE];
                        messageLabel = (UILabel*)[cell.contentView viewWithTag:TAG_MESSAGE_LABEL];
                        sentTimeLabel = (UILabel*)[cell.contentView viewWithTag:TAG_SENTTIMELABEL];
                        lbl_name = (UILabel*)[cell.contentView viewWithTag:TAG_BUDDY_NAME];
                        btn_toupdate = (UIButton*)[cell.contentView viewWithTag:TAG_BUTTON_UPDATE];
                    }
                    
                    
                    
                    int labelHeight = [UILabel labelHeight:self.warningDesc FontType:TEXTCELL_CACULATED_FONT withInMaxWidth:TEXTCELL_MAX_WIDTH];
                    int labelWidth = [UILabel labelWidth:self.warningDesc FontType:TEXTCELL_CACULATED_FONT withInMaxWidth:TEXTCELL_MAX_WIDTH];
                    int imageWidth = labelWidth+20;
                    
                    int cellHeight = CHATCELL_CONTENT_LARGE_OFFSET_Y*2 + labelHeight + 30;
                    
                    // TODO: problems here. You have to take care of the layout in the future.
                    
                    if (self.isGroupMode) {
                        headImageView.buddy = [Database buddyWithUserID:msg.groupChatSenderID];
                        headImageView.headImage = [self getMessageBuddyProfile:msg];
                        lbl_name.frame = CGRectMake(INCOMINGCELL_NAME_X, INCOMINGCELL_NAME_Y, INCOMINGCELL_NAME_W, INCOMINGCELL_NAME_H);
                        lbl_name.text  = [[Database buddyWithUserID:msg.groupChatSenderID] nickName];
                        lbl_name.hidden = FALSE;
                        messageBG.frame = CGRectMake(45, 17 , imageWidth, labelHeight+CHATCELL_CONTENT_LARGE_OFFSET_Y+5 + INCOMINGCELL_NAME_MSG_GAP_Y + INCOMINGCELL_NAME_H  );
                        
                        messageLabel.frame = CGRectMake(55, INCOMINGCELL_BG_Y + INCOMINGCELL_NAME_H+ INCOMINGCELL_NAME_MSG_GAP_Y , labelWidth, labelHeight);
                        
                    }
                    else {
                        lbl_name.text  = _compositeName;
                        [lbl_name setHidden:YES];
                        messageBG.frame = CGRectMake(45, 17 , imageWidth, labelHeight+CHATCELL_CONTENT_LARGE_OFFSET_Y*2+5 );
                        
                        messageLabel.frame = CGRectMake(55, 22 + CHATCELL_CONTENT_LARGE_OFFSET_Y , labelWidth, labelHeight);
                    }
                    sentTimeLabel.textColor = [Colors chatTimeTextColor_L];
                    sentTimeLabel.backgroundColor = [UIColor clearColor];
                    sentTimeLabel.font = [UIFont boldSystemFontOfSize:10];
                    
                    sentTimeLabel.text = [TimeHelper getHourAndMinuteFromTime:msg.sentDate];
                    
                    
                    
                    sentTimeLabel.frame = CGRectMake(imageWidth + 45 +15 , cellHeight-25, 45, 12);
                    btn_toupdate .frame = CGRectMake(45, 17 , imageWidth, labelHeight+CHATCELL_CONTENT_LARGE_OFFSET_Y*2+5);
                    
                    [btn_toupdate addTarget:self action:@selector(updateWowTalk) forControlEvents:UIControlEventTouchUpInside];
                    
                    messageLabel.text = self.warningDesc;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.contentView.backgroundColor = [Colors chatRoomBackgroundColor];
                    return cell;
                }
                
            }
            
        }
    }
    
    
    return nil;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.tb_messages)
    {
        if (indexPath.row == 0)
        {
            return 20;
        }
        else{
            
            ChatMessage* msg=(ChatMessage*)[[self.listOfMessages objectAtIndex:([indexPath section])] objectAtIndex:[indexPath row]-1];
            
            // outgoing msg;
            if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
            {
                if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]]){
                    return [TextOutgoingCell getCellHeight:msg.messageContent];

                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]])
                {
                    
                    return DEFAULT_VOICECELL_BG_H + OUTGOINGCELL_OFFSET_Y;
                    
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]|| [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]]|| [msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]] )
                {
                    
                    UIImage* thumbnail = [[[UIImage alloc] initWithContentsOfFile:[NSFileManager absolutePathForFileInDocumentFolder: msg.pathOfThumbNail]] autorelease];
                    return OUTGOINGCELL_OFFSET_Y + BG_TAIL_HEIGHT + thumbnail.size.height*MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR+ CHATCELL_CONTENT_THIN_OFFSET_Y*2;
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_LOCATION]])
                {
                    return OUTGOINGCELL_OFFSET_Y + BG_TAIL_HEIGHT + MAP_H + CHATCELL_CONTENT_THIN_OFFSET_Y*2;
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_STAMP]])
                {
                    
                    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
                    NSDictionary* dic = (NSDictionary*)[jp fragmentWithString: msg.messageContent];
                    
                    
                    NSString* type = [dic objectForKey:STAMP_TYPE];
                    
                    
                    if ([type isEqualToString:STAMP_TYPE_ANIME])
                    {
                        int height = [[dic objectForKey:STAMP_ANIME_H] integerValue] /2 ;
                        
                        return OUTGOINGCELL_OFFSET_Y + height;
                    }
                    else if([type isEqualToString:STAMP_TYPE_IMAGE])
                    {
                        int height = [[dic objectForKey:STAMP_IMAGE_H] integerValue] /2 ;
                        return OUTGOINGCELL_OFFSET_Y + height;
                        
                    }
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_CALL_LOG]]){
                    return DEFAULT_VOICECELL_BG_H + OUTGOINGCELL_OFFSET_Y;
                    
                }
                
            }
            
            // incoming msg
            else
            {
                
                if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]])
                {
                    return [TextIncomingCell getCellHeight:msg.messageContent forGroupMsg:msg.isGroupChatMessage];

                }
                
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]])
                {
                    
                    if (msg.isGroupChatMessage) {
                        return INCOMINGCELL_BG_Y + DEFAULT_VOICECELL_BG_H + INCOMINGCELL_OFFSET_Y + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y ;
                        
                    }
                    return INCOMINGCELL_BG_Y + DEFAULT_VOICECELL_BG_H + INCOMINGCELL_OFFSET_Y;
                }
                
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]|| [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]] || [msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]])
                {
                    if (![NSFileManager mediafileExistedAtPath:msg.pathOfThumbNail])
                    {
                        if (msg.isGroupChatMessage) {
                            return INCOMINGCELL_BG_Y + DEFAULT_PHOTOCELL_BG_H +INCOMINGCELL_OFFSET_Y + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y ;
                        }
                        return INCOMINGCELL_BG_Y + DEFAULT_PHOTOCELL_BG_H +INCOMINGCELL_OFFSET_Y;
                    }
                    else
                    {
                        
                        UIImage* thumbnail = [[[UIImage alloc] initWithContentsOfFile:[NSFileManager absolutePathForFileInDocumentFolder: msg.pathOfThumbNail]] autorelease];
                        if (msg.isGroupChatMessage) {
                            return INCOMINGCELL_BG_Y + thumbnail.size.height*MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR + CHATCELL_CONTENT_THIN_OFFSET_Y+BG_TAIL_HEIGHT + INCOMINGCELL_OFFSET_Y + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y ;
                        }
                        return INCOMINGCELL_BG_Y + thumbnail.size.height*MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR + 2*CHATCELL_CONTENT_THIN_OFFSET_Y+BG_TAIL_HEIGHT + INCOMINGCELL_OFFSET_Y;
                    }
                    
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_LOCATION]])
                {
                    if (msg.isGroupChatMessage) {
                        return INCOMINGCELL_BG_Y + MAP_H + CHATCELL_CONTENT_THIN_OFFSET_Y+BG_TAIL_HEIGHT + INCOMINGCELL_OFFSET_Y + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y ;
                    }
                    return INCOMINGCELL_BG_Y + MAP_H + 2*CHATCELL_CONTENT_THIN_OFFSET_Y+BG_TAIL_HEIGHT + INCOMINGCELL_OFFSET_Y;
                }
                
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_CALL_LOG]])
                {
                    if (msg.isGroupChatMessage) {
                        return INCOMINGCELL_BG_Y + DEFAULT_CALLCELL_BG_H + INCOMINGCELL_OFFSET_Y + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y;
                    }
                    return INCOMINGCELL_BG_Y + DEFAULT_CALLCELL_BG_H + INCOMINGCELL_OFFSET_Y;
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM]])
                {
                    return DEFAULT_NOTIFICATIONCELL_H;
                }
                else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM]])
                {
                    return DEFAULT_NOTIFICATIONCELL_H;
                }
                else
                {
                    int labelHeight = [UILabel labelHeight:self.warningDesc FontType:TEXTCELL_CACULATED_FONT withInMaxWidth:TEXTCELL_MAX_WIDTH];
                    
                    if (msg.isGroupChatMessage) {
                        return CHATCELL_CONTENT_LARGE_OFFSET_Y + labelHeight + 30 + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y;
                    }
                    
                    //int imageWidth = labelWidth>=BUBBLE_MAX_WIDTH?(labelWidth+15):(labelWidth+30);
                    
                    return CHATCELL_CONTENT_LARGE_OFFSET_Y*2 + labelHeight + 30;
                    
                }
                
                
            }
        }
    }
    
    return 0;
}



#pragma mark -
#pragma mark Start a chat with a user.

-(void)startChatWithUser:(NSString *)username withCompositeName:(NSString *)compositename withDisplayname:(NSString *)displayname
{
    
    self._userName = username;
    self._compositeName = compositename;
    self._displayname = displayname;
    
    
    self._showLimit = INIT_MSG_SHOW;
    
    NSString* dirname = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:username];
    
    [NSFileManager createDirectoryInDocumentsFolderWithName:dirname];
    
    self._buddy = [Database buddyWithUserID:username];
    
    
    NSData* data = [AvatarHelper getThumbnailForUser:self._userName];
    if (data != nil)
    {
        self.imageForProfile = [UIImage imageWithData:data];
    }
    else
    {
        if ([self._buddy.buddy_flag isEqualToString:@"2"]) {
            self.imageForProfile = [UIImage imageNamed:DEFAULT_AVATAR_OFFLINE_IMAGE_90];
        }
        else
            self.imageForProfile = [UIImage imageNamed:DEFAULT_AVATAR];
    }
    [self getMessagesList];
}

-(void)getMessagesList
{
    
    if (self.arr_photomsgs) {
        [self.arr_photomsgs removeAllObjects];
    }
    else{
        self.arr_photomsgs = [[[NSMutableArray alloc] init] autorelease];
    }
    NSInteger msgRecordCnt = [Database countChatMessagesWithUser:self._userName];
    
    if (msgRecordCnt>0)
    {
        self._recordCnt = msgRecordCnt;
        int offset = (self._showLimit > msgRecordCnt)?0:(msgRecordCnt-self._showLimit);
        self._arrAllMsgs = [Database fetchChatMessagesWithUser:self._userName withLimit:self._showLimit fromOffset:offset];
        
    } // NOTE that we have not change the the unread msgs in the _arrmsg.
    
    if (self.dateOfMessages==nil) {
        self.dateOfMessages =[[[NSMutableArray alloc] init] autorelease];
    }
    else {
        [self.dateOfMessages removeAllObjects];
    }
    
    if (self.listOfMessages==nil) {
        self.listOfMessages =[[[NSMutableArray alloc] init] autorelease];
    }
    else {
        [self.listOfMessages removeAllObjects];
    }
    
    if (self._arrAllMsgs)
    {
        NSString* dayinfo;
        int count = [self._arrAllMsgs count];
        int idx=0;
        
        while (idx<count)
        {
            ChatMessage *msg1=[self._arrAllMsgs objectAtIndex:idx];
            
            dayinfo = [TimeHelper getDayFromTime:msg1.sentDate];
            
            NSMutableArray* arrMsg =[[[NSMutableArray alloc] init] autorelease];
            
            [arrMsg addObject:msg1];
            
            if ([msg1.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]) {
                [self.arr_photomsgs addObject:msg1];
            }
            idx++;
            
            if (idx<count) {
                while (idx<count) {
                    ChatMessage *msg2=[self._arrAllMsgs objectAtIndex:idx];
                    if ([[TimeHelper getDayFromTime:msg2.sentDate] isEqualToString:dayinfo]) {
                        
                        if ([msg2.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]) {
                            [self.arr_photomsgs addObject:msg2];
                        }
                        // the same day.
                        [arrMsg addObject:msg2];
                        idx++;
                        
                    }
                    else {
                        break;
                    }
                }
            }
            [self.dateOfMessages addObject:dayinfo];
            [self.listOfMessages addObject:arrMsg];
        }
    }
}

-(void)updateGroupChatName:(NSString *) groupId
{
    GroupChatRoom *groupName=[Database getGroupChatRoomByGroupid:self._userName];
    if (nil != groupName) {
        if (groupName.isTemporaryGroup) {
            if (![PublicFunctions isTmpChatRoomNameChanged:groupName]) {
                self._compositeName = NSLocalizedString(@"fix_tmp_group_chat_title", nil);
            } else {
                self._compositeName = groupName.groupNameLocal;
            }
        } else {
//            self._compositeName = NSLocalizedString(@"fix_group_chat_title", nil);
            self._compositeName = groupName.groupNameLocal;
        }
    }
}

-(void)startGroupChat:(NSString*) groupID withBuddys:(NSArray*)chatbuddys withCompositeName:(NSString*)compositename;
{
    
    self._userName = groupID;
    
    self.buddys = [NSMutableArray arrayWithArray:chatbuddys];
    
    if (compositename == nil) {
        if (self.buddys == nil || [self.buddys count] == 0) {
            self._compositeName = NSLocalizedString(@"No member", nil);
        }
        else{
            Buddy* first_buddy = [self.buddys objectAtIndex:0];
            self._compositeName = [NSString stringWithFormat:@"%@...",[first_buddy nickName]];
        }
        
    }
    else
        self._compositeName = compositename;
    
    [self updateGroupChatName:groupID];
    
    self._displayname = self._compositeName;
    
    self._showLimit = INIT_MSG_SHOW;
    
    NSString* dirname = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self._userName];
    
    [NSFileManager createDirectoryInDocumentsFolderWithName:dirname];
    
    self._buddy = [Database buddyWithUserID:self._userName];
    
    NSInteger msgRecordCnt = [Database countChatMessagesWithUser: self._userName];
    
    if (msgRecordCnt>0)
    {
        self._recordCnt = msgRecordCnt;
        int offset = (self._showLimit > msgRecordCnt)?0:(msgRecordCnt-self._showLimit);
        self._arrAllMsgs = [Database fetchChatMessagesWithUser: self._userName withLimit:self._showLimit fromOffset:offset];
        
    } // NOTE that we have not change the the unread msgs in the _arrmsg.
    
    [self getMessagesList];
}


#pragma mark -
#pragma mark TextView Delegate
-(void)resignTextView
{
    [self.txtView_Input resignFirstResponder];
    _isKeyboardShown = FALSE;
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.txtView_Input resignFirstResponder];
    _isKeyboardShown = FALSE;
}


// this is called when the mode is changed to keyboard mode or the inputbox is clicked
-(void) keyboardWillShow:(NSNotification *)note{
    
    _isKeyboardShown = YES;
    
   // self.uv_barcontainer.hidden = FALSE;
    
    NSInteger kbSizeH = 216;
    
    CGRect keyboardFrame = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbSizeH = keyboardFrame.size.height;
    CGRect frame = self.uv_barcontainer.frame;
    frame.origin.y = self.view.frame.size.height  - kbSizeH - self.uv_defaultoperationbar.frame.size.height;
    
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
    
    self.uv_barcontainer.frame = frame;
    [self ScrollChatTableToLatestMessageRow:NO];
    
    [UIView commitAnimations];
    
    
    if (self.mInputMode != KEYBOARD_MODE)
    {
        self.mInputMode = TEXT_MODE;
    }
    
    self.btn_keyboard.hidden = YES;
    self.btn_stamp.hidden = NO;
    
    
    if (isCloseIcon) {
        [self rotateAnimationForView:self.btn_showmore];
    }
    
    
}

// we hide it when the textfield lost focus. Text_Mode and special mode is different.
-(void) keyboardWillHide:(NSNotification *)note{
    
    _isKeyboardShown = NO;
    
    if (resetDefaultOperationBar)
    {
        
    }
    else
    {
        if (self.mInputMode == STAMP_MODE) {
        }
        else
        {
            // animations settings
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
            [UIView setAnimationDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
            
            self.uv_barcontainer.frame = CGRectMake(self.uv_barcontainer.frame.origin.x, self.view.frame.size.height - self.uv_defaultoperationbar.frame.size.height, self.uv_barcontainer.frame.size.width, self.uv_defaultoperationbar.frame.size.height);
            
            [self ScrollChatTableToLatestMessageRow:NO];
            
            // commit animations
            [UIView commitAnimations];
        }
    }
    
    resetDefaultOperationBar = FALSE;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    
    
    float diff = (self.txtView_Input.frame.size.height - height);
    
    [self.iv_inputbox_bg setFrame:CGRectMake( 75, 5, self.txtView_Input.frame.size.width,height)];
    
    CGRect frame = self.uv_barcontainer.frame;
    frame.origin.y += diff;
    frame.size.height -= diff;
    self.uv_barcontainer.frame= frame;
    
    [self.uv_defaultoperationbar setFrame:CGRectMake(self.uv_defaultoperationbar.frame.origin.x, self.uv_defaultoperationbar.frame.origin.y, self.uv_defaultoperationbar.frame.size.width, self.uv_defaultoperationbar.frame.size.height - diff)];
    
    if ([self.expressionPickView superview]!=nil) {
        self.expressionPickView.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_defaultoperationbar.frame.size.height, self.expressionPickView.frame.size.width, self.expressionPickView.frame.size.height);
    }
    
    if ([self.uv_moreoperationbar superview]!=nil) {
        self.uv_moreoperationbar.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_defaultoperationbar.frame.size.height, self.uv_moreoperationbar.frame.size.width, self.uv_moreoperationbar.frame.size.height);
    }
    
    frame = self.btn_send.frame;
    
    frame.origin.y = (self.uv_defaultoperationbar.frame.size.height-self.btn_send.frame.size.height - 4);
    
    self.btn_send.frame = frame;
    
    frame = self.btn_showmore.frame;
    
    frame.origin.y = (self.uv_defaultoperationbar.frame.size.height-self.btn_showmore.frame.size.height - 4);
    
    self.btn_showmore.frame = frame;
    
    frame = self.btn_stamp.frame;
    frame.origin.y = (self.uv_defaultoperationbar.frame.size.height-self.btn_stamp.frame.size.height - 4);
    self.btn_stamp.frame = frame;
    
    
    frame = self.btn_keyboard.frame;
    frame.origin.y = (self.uv_defaultoperationbar.frame.size.height-self.btn_keyboard.frame.size.height - 4);
    self.btn_keyboard.frame = frame;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
    [self ScrollChatTableToLatestMessageRow:YES];
}

- (void)ScrollChatTableToLatestMessageRow:(BOOL)animated
{
    self.tb_messages.frame =  CGRectMake(self.tb_messages.frame.origin.x, self.tb_messages.frame.origin.y ,self.view.frame.size.width, self.uv_barcontainer.frame.origin.y);
    NSUInteger sections = [self.tb_messages numberOfSections];
    if (sections>0){
        NSUInteger rows = [self.tb_messages numberOfRowsInSection:(sections-1)];
        if (rows>0){
            [self.tb_messages scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(rows-1) inSection:(sections-1)]  atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    }
}



#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self fIncreaseShowLimit];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _shouldReloadMsg; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark Data Source Loading / Reloading Methods

-(void)fIncreaseShowLimit
{
    // TODO: have to check whether some network is running now.
    self._recordCnt = [Database countChatMessagesWithUser:self._userName];
    
    // no need to change while all the records are already read.
    if (self._showLimit > self._recordCnt) {
        [self._refreshHeaderView performSelector:@selector(egoRefreshScrollViewDataSourceDidFinishedLoading:) withObject:self.tb_messages afterDelay:0.3];
        return;
    }
    
    if (self.arr_photomsgs == nil) {
        self.arr_photomsgs = [[[NSMutableArray alloc] init] autorelease];
    }
    
    self._showLimit += 50;
    
    int currentNumOfMessage = [self._arrAllMsgs count]; // current number
    int offset = (self._showLimit>self._recordCnt)?0:(self._recordCnt-self._showLimit);
    self._arrAllMsgs = [Database fetchChatMessagesWithUser:self._userName withLimit:self._showLimit fromOffset:offset];  // fetch more messages.
    
    int count = [self._arrAllMsgs count];
    int idx= count - currentNumOfMessage -1;
    
    NSString* dayinfo;
    
    while (idx > -1){
        ChatMessage *msg1=[self._arrAllMsgs objectAtIndex:idx];
        dayinfo = [TimeHelper getDayFromTime:msg1.sentDate];
        
        NSMutableArray* arrMsg =[[[NSMutableArray alloc] init] autorelease];
        if ([arrMsg count] == 0) {
            [arrMsg addObject:msg1];
        }
        else{
            [arrMsg insertObject:msg1 atIndex:0];
        }
        
        if ([msg1.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]){
            if ([self.arr_photomsgs count] == 0) {
                [self.arr_photomsgs addObject:msg1];
            }
            else
                [self.arr_photomsgs insertObject:msg1 atIndex:0];
        }
        idx--;
        if (idx > -1){
            while (idx > -1){
                ChatMessage *msg2=[self._arrAllMsgs objectAtIndex:idx];
                if ([[TimeHelper getDayFromTime:msg2.sentDate] isEqualToString:dayinfo]){
                    if ([msg2.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]) {
                        if ([self.arr_photomsgs count] == 0) {
                            [self.arr_photomsgs addObject:msg2];
                        }
                        else
                            [self.arr_photomsgs insertObject:msg2 atIndex: 0];
                    }
                    if ([arrMsg count] == 0) {
                        [arrMsg addObject:msg2];
                    }
                    else{
                        [arrMsg insertObject:msg2 atIndex:0];
                    }
                    idx--;
                }
                else{
                    break;
                }
            }
        }
        
        if ([self.dateOfMessages count] == 0) {
            [self.dateOfMessages addObject:dayinfo];
            [self.listOfMessages addObject:arrMsg];
        }
        else{
            if ([[self.dateOfMessages objectAtIndex:0] isEqualToString:dayinfo]) {
                NSMutableArray* arr =  [self.listOfMessages objectAtIndex:0];
                int index = 0;
                for (ChatMessage* msg in arrMsg) {
                    [arr insertObject:msg atIndex:index];
                    index++;
                }
            }
            else{
                [self.dateOfMessages insertObject:dayinfo atIndex:0];
                [self.listOfMessages insertObject:arrMsg atIndex:0];
            }
        }
    }
    
    [self.tb_messages reloadData];
    
    _shouldReloadMsg = TRUE;
    
    [self performSelector:@selector(doneLoadingContactTableViewData) withObject:nil afterDelay:0.5];
    
    return;
    
}


- (void)doneLoadingContactTableViewData
{
    if (_shouldReloadMsg) {
        _shouldReloadMsg = NO;
        
        [self._refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tb_messages];
        [self.tb_messages reloadData];
        self.tb_messages.frame =  CGRectMake(self.tb_messages.frame.origin.x, self.tb_messages.frame.origin.y ,self.view.frame.size.width, self.uv_barcontainer.frame.origin.y);
        
        [self.tb_messages scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:NO];
        
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -- delegate for animation view
-(void)selectTextExpression:(NSString *)string fromExpicker:(ExpressionPickView *)picker
{
    NSMutableString* tempstring = [NSMutableString stringWithString: self.txtView_Input.internalTextView.text];
    [tempstring appendString:string];
    
    self.txtView_Input.internalTextView.text  =  tempstring;
    [self.txtView_Input textViewDidChange:self.txtView_Input.internalTextView];
}

#pragma mark -- mode change method
-(void)rotateAnimationForView:(UIView*)oview
{
    rotatecount ++;
    
    UIButton* btn = (UIButton*)oview;
    if (rotatecount%2 == 0) {
        isCloseIcon = FALSE;
        rotatecount = 0;
        [btn setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_SHOW_MORE]  forState:UIControlStateNormal];
    }
    else{
        [btn setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_CLOSE_MORE]  forState:UIControlStateNormal];
        isCloseIcon = TRUE;
        rotatecount = 1;
    }
}


-(void)resetTheDefaultOperationBar
{
    
    resetDefaultOperationBar = TRUE;
    
    if (_isKeyboardShown) {
        [self.txtView_Input.internalTextView resignFirstResponder];   // dismiss the keyboard.
    }
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDidStopSelector:@selector(afterAnimation)];
    
    self.uv_barcontainer.frame = CGRectMake(self.uv_barcontainer.frame.origin.x, self.view.frame.size.height- self.uv_defaultoperationbar.frame.size.height, self.uv_barcontainer.frame.size.width, self.uv_defaultoperationbar.frame.size.height);
    
    if (isCloseIcon) {
        [self rotateAnimationForView:self.btn_showmore];
    }
    
    [self ScrollChatTableToLatestMessageRow:NO];
    changeBackFromKeyboardToStamp = FALSE;
    self.btn_stamp.hidden = NO;
    self.btn_keyboard.hidden = YES;
    
    self.mInputMode = TEXT_MODE;   // go back to normal mode.
    resetDefaultOperationBar = FALSE;
    
    [UIView commitAnimations];
}


-(void)cancleTheExtraBoard:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (containsTapGuesture) {
            [self.tb_messages removeGestureRecognizer:self.tapRecognizer];
            containsTapGuesture = FALSE;
        }
        
        [self resetTheDefaultOperationBar];
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.uv_barcontainer.frame =
                             CGRectMake(0, self.view.frame.size.height - self.familyOperationBar.frame.size.height, 320, self.familyOperationBar.frame.size.height);
                             //                             self.uv_moreoperationbar.frame = CGRectMake(0, self.familyOperationBar.frame.size.height, 320, 0);
                         }
                         completion:^(BOOL finished){
                             [self.familyOperationBarIndicator setImage:[UIImage imageNamed:@"sms_unfold_btn.png"]
                                                               forState:UIControlStateNormal];
                             self.moreBarShown = NO;
                         }];
    }
    
}

// press stamp button
-(IBAction)ChangeToStampMode:(id)sender
{
    /*
    BOOL isFridend = [Database isFriendWithUID:_buddy.userID]; // 是否是好友
    BOOL isSchoolMember = [Database isSchollMember:_buddy.userID];  // 是否死学校成员
    //    BOOL isSelf = [[WTUserDefaults getUid] isEqualToString:_buddy.userID];// 是否是当前用户
    if ( !isFridend  && !isSchoolMember){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"你们还不是好友，请先添加好友后再聊天",nil) delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1];
        return;
    }
     */
    
    if (isCloseIcon) {
        [self rotateAnimationForView:self.btn_showmore];
    }
    
    self.mInputMode = STAMP_MODE;
    
    resetDefaultOperationBar = FALSE;
    
    if ([self.uv_moreoperationbar superview]!= nil) {
        [self.uv_moreoperationbar removeFromSuperview];
    }
    
    if ( _isKeyboardShown){
        [self.txtView_Input.internalTextView resignFirstResponder];
    }
    
    
    if ( nil == _expressionPickView) {
        
        self.expressionPickView = [[[ ExpressionPickView alloc] initWithFrame:CGRectMake(0, self.uv_defaultoperationbar.frame.size.height, [UISize screenWidth], STAMPBOARD_HEIGHT)] autorelease];
        self.expressionPickView.delegate = self;
    }
    
    if ([self.expressionPickView superview]==nil){
        
        [self.uv_barcontainer addSubview:self.expressionPickView];
    }
    
    int height =self.uv_defaultoperationbar.frame.size.height + STAMPBOARD_HEIGHT;
    self.expressionPickView.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_barcontainer.frame.size.height, self.expressionPickView.frame.size.width, self.expressionPickView.frame.size.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    
    
    // set the uv_barcontainer to fit the stampboard.
    [self.uv_barcontainer setFrame:CGRectMake(self.uv_barcontainer.frame.origin.x, self.view.frame.size.height - height, self.uv_barcontainer.frame.size.width, height)];
    
    self.expressionPickView.frame = CGRectMake(self.uv_barcontainer.frame.origin.x , self.uv_defaultoperationbar.frame.size.height, self.expressionPickView.frame.size.width, self.expressionPickView.frame.size.height);
    
    
    [self ScrollChatTableToLatestMessageRow:NO];
    
    if (!containsTapGuesture) {
        
        [self.tb_messages addGestureRecognizer:self.tapRecognizer];
        containsTapGuesture = TRUE;
    }
    
    self.btn_stamp.hidden = YES;
    self.btn_keyboard.hidden = NO;
    
    self.mInputMode = STAMP_MODE;
    [UIView commitAnimations];
    
    changeBackFromKeyboardToStamp = FALSE;
    
}

// press keyboard button
-(IBAction)ChangeToKeyboardMode:(id)sender
{
    resetDefaultOperationBar = FALSE;
    
    
    if (self.mInputMode!= KEYBOARD_MODE) {
        
        self.mInputMode = KEYBOARD_MODE;
        
        [self.txtView_Input.internalTextView becomeFirstResponder];
        
        self.btn_stamp.hidden = NO;
        self.btn_keyboard.hidden = YES;
        
        if (!containsTapGuesture) {
            
            [self.tb_messages addGestureRecognizer:self.tapRecognizer];
            containsTapGuesture = TRUE;
        }
        changeBackFromKeyboardToStamp = TRUE;
    }
    
}

- (void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}


// press add button.
-(void)showMoreMessageOptions:(id)sender
{
    /*
    BOOL isFridend = [Database isFriendWithUID:_buddy.userID]; // 是否是好友
    BOOL isSchoolMember = [Database isSchollMember:_buddy.userID];  // 是否死学校成员
//    BOOL isSelf = [[WTUserDefaults getUid] isEqualToString:_buddy.userID];// 是否是当前用户
    if ( !isFridend  && !isSchoolMember){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"你们还不是好友，请先添加好友后再聊天",nil) delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1];
        return;
    }
     */
    
    
    resetDefaultOperationBar = FALSE;
    
    if (_isKeyboardShown){
        [self.txtView_Input.internalTextView resignFirstResponder];
    }
    
    self.btn_stamp.hidden = FALSE;
    self.btn_keyboard.hidden = TRUE;
    changeBackFromKeyboardToStamp = FALSE;
    
    if (self.mInputMode != MORE_OPERATION_MODE )  // if it is not a more operation mode.
    {
        
        self.mInputMode= MORE_OPERATION_MODE;
        
        if (!isCloseIcon) {    // change to the up arrow only if it is not.
            [self rotateAnimationForView:sender];
        }
        
        [self.uv_moreoperationbar setFrame:CGRectMake(0, self.uv_barcontainer.frame.size.height, 320, 216)];
        
        if ([self.uv_moreoperationbar superview] == nil) {
            [self.uv_barcontainer addSubview:self.uv_moreoperationbar];
        }
        
        if (!containsTapGuesture) {
            
            [self.tb_messages addGestureRecognizer:self.tapRecognizer];
            
            containsTapGuesture = TRUE;
        }
        
        //set up the image for the default bar background.
        /*UIImage *image = [PublicFunctions imageNamedWithNoPngExtension:SMS_MORE_BG];
        image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
        [self.iv_moreoperationbar_bg setImage:image];*/
        [self.iv_moreoperationbar_bg setBackgroundColor:[UIColor whiteColor]];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2];
        
        [self.uv_barcontainer setFrame:CGRectMake(0, self.view.frame.size.height - (self.uv_defaultoperationbar.frame.size.height + self.uv_moreoperationbar.frame.size.height), 320, self.uv_defaultoperationbar.frame.size.height + 216)];
        
        [self.uv_moreoperationbar setFrame:CGRectMake(0, self.uv_defaultoperationbar.frame.size.height, 320, 216)];
        
        [self ScrollChatTableToLatestMessageRow:NO];
        
        [UIView commitAnimations];
        
    }
    
    // hide the more operation view. set the inputmode as textmode.
    else
    {
        
        self.mInputMode = TEXT_MODE;
        
        [self rotateAnimationForView:sender];
        
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDidStopSelector:@selector(afterAnimation)];
        
        /*
         [UIView animateWithDuration:0.3f
         animations:^{
         [self.uv_barcontainer setFrame:CGRectMake(0, [UISize screenHeight] - self.uv_defaultoperationbar.frame.size.height , 320, self.uv_defaultoperationbar.frame.size.height)];
         [self.uv_moreoperationbar setFrame:CGRectMake(0, self.uv_barcontainer.frame.size.height, 320, 216)];
         
         
         }
         completion:^(BOOL finished){
         [self.uv_moreoperationbar removeFromSuperview];
         
         
         }];
         
         */
        
        [self.uv_barcontainer setFrame:CGRectMake(0, self.view.frame.size.height - self.uv_defaultoperationbar.frame.size.height , 320, self.uv_defaultoperationbar.frame.size.height)];
        [self.uv_moreoperationbar setFrame:CGRectMake(0, self.uv_barcontainer.frame.size.height, 320, 216)];
        
        if (containsTapGuesture) {
            [self.tb_messages removeGestureRecognizer:self.tapRecognizer];
            containsTapGuesture = FALSE;
        }
        [self ScrollChatTableToLatestMessageRow:NO];
        
        [UIView commitAnimations];
    }
    
}


-(void)afterAnimation
{
    
    if ([self.expressionPickView superview] != nil) {
        [self.expressionPickView removeFromSuperview];
    }
    
    if ([self.uv_moreoperationbar superview] != nil) {
        [self.uv_moreoperationbar removeFromSuperview];
    }
    
}

#pragma mark -- location methods
-(void)getDataFromMap:(ViewDetailedLocationVC *)requestor
{
    self._recordCnt ++;
    
    ChatMessage * msg = [[[ChatMessage alloc] init] autorelease];
    
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.msgType = [ChatMessage MSGTYPE_LOCATION];
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    
    NSDictionary* dictonary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%.6f",requestor.annotation.coordinate.latitude],[NSString stringWithFormat:@"%.6f",requestor.annotation.coordinate.longitude], requestor.annotation.subtitle, nil] forKeys:[NSArray arrayWithObjects:LATITUDE, LONGITUDE, ADDRESS, nil]];
    
    SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
    
    msg.messageContent = [jw stringWithFragment:dictonary];
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.ioType = [ChatMessage IOTYPE_OUTPUT];
        msg.primaryKey = [Database storeNewChatMessage:msg];
        [WowTalkWebServerIF groupChat_SendMessage:msg toGroup:self._userName withCallback:@selector(didSendChatByWebIF:) withObserver:nil];
    }
    else{
        [WowTalkWebServerIF sendBuddyMessage:msg];
    }
    
    [self addMessageToMessageArray:msg];
    
    [self refreshMessageTableScrollToBottom:YES Animation:NO];
    
    
}

-(void)sendCurrentLocation
{
    //  [self.btn_location setBackgroundColor: [Theme sharedInstance].currentBGColorForButtonInOperationContainer];
    
    ViewDetailedLocationVC* vdl = [[[ViewDetailedLocationVC alloc] initWithNibName:@"ViewDetailedLocationVC" bundle:nil] autorelease];
    
    vdl.mode = PICK_TO_SEND;
    vdl.delegate = self;
    vdl.parent = self;
    
    [self.navigationController pushViewController:vdl animated:YES];
    
   // [self.uv_barcontainer setHidden:YES];
    
}
#pragma mark -- HomeWorkCamera related;

-(void)getDataFromHomeworkCamera:(OnlineHomeworkVC *)requestor
{
    self._recordCnt ++;
    
    ChatMessage * msg = [[[ChatMessage alloc] init] autorelease];
    
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.pathOfThumbNail = requestor.thumbnailPath;
    msg.msgType = [ChatMessage MSGTYPE_MULTIMEDIA_PHOTO];
    msg.pathOfMultimedia = requestor.imagePath;
        
   
    
    
    msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    
    msg.sentStatus = [ChatMessage SENTSTATUS_FILE_UPLOADINIT];   // this is used to controle whether to show failed mark;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    }
    
    [self addMessageToMessageArray:msg];
    
    
    
    
    NSDictionary* dictonary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"", nil] forKeys:[NSArray arrayWithObjects:PATH_OF_THE_THUMBNAIL_IN_SERVER, PATH_OF_THE_ORIGINAL_FILE_IN_SERVER, nil]];
    SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
    msg.messageContent = [jw stringWithFragment:dictonary];
    msg.primaryKey = [Database storeNewChatMessage:msg]; // save it in the databse;
    msg.fileTransfering = TRUE;
    
    [WowTalkWebServerIF uploadMediaMessageThumbnail:msg withCallback:@selector(didUploadThumbnail:) withObserver:self];
    [WowTalkWebServerIF uploadMediaMessageOriginalFile:msg withCallback:@selector(didUploadOriginalFile:) withObserver:nil];
    
    [self refreshMessageTableScrollToBottom:YES Animation:NO];
    
    
}

- (void)getDataFromSignInContent:(NSString *)content{
    self._recordCnt++;
    
    ChatMessage* msg= [[[ChatMessage alloc]init] autorelease];
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.msgType = [ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE];
    
    msg.messageContent = content;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.ioType = [ChatMessage IOTYPE_OUTPUT];
        msg.primaryKey = [Database storeNewChatMessage:msg];
        [WowTalkWebServerIF groupChat_SendMessage:msg toGroup:self._userName withCallback:@selector(didSendChatByWebIF:) withObserver:nil];
        
    }
    else{
        [WowTalkWebServerIF sendBuddyMessage:msg];
    }
    
    [self addMessageToMessageArray:msg];
    self.txtView_Input.text=@"";
    [self refreshMessageTableScrollToBottom:YES Animation:YES];
}

#pragma mark -- camera related;

-(void)captureUseCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        self.cameraViewController = [[[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil] autorelease];
        
        self.cameraViewController.parent = self;
        self.cameraViewController.delegate =self;
        
        self.cameraViewController.maxThumbnailSize = CGSizeMake(MULTIMEDIACELL_THUMBNAIL_MAX_X, MULTIMEDIACELL_THUMBNAIL_MAX_Y);
        
        self.cameraViewController.dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self._userName];
        
        
        [self.cameraViewController startCamera];
        
     //   self.uv_barcontainer.hidden = YES;
    }
}

-(void)getDataFromCamera:(CameraViewController *)requestor
{
    self._recordCnt ++;
    
    ChatMessage * msg = [[[ChatMessage alloc] init] autorelease];
    
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.pathOfThumbNail = requestor.thumbnailPath;
    
    if(requestor.mmtType == MMT_PHOTO)
    {
        msg.msgType = [ChatMessage MSGTYPE_MULTIMEDIA_PHOTO];
        msg.pathOfMultimedia = requestor.imagePath;
        
    }
    else if(requestor.mmtType == MMT_MOVIE)
    {
        msg.msgType = [ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE];
        msg.pathOfMultimedia = requestor.videoPath;
    }
    
    msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    
    msg.sentStatus = [ChatMessage SENTSTATUS_FILE_UPLOADINIT];   // this is used to controle whether to show failed mark;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    }
    
    [self addMessageToMessageArray:msg];
    
    
    
    
    NSDictionary* dictonary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"", nil] forKeys:[NSArray arrayWithObjects:PATH_OF_THE_THUMBNAIL_IN_SERVER, PATH_OF_THE_ORIGINAL_FILE_IN_SERVER, nil]];
    SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
    msg.messageContent = [jw stringWithFragment:dictonary];
    msg.primaryKey = [Database storeNewChatMessage:msg]; // save it in the databse;
    msg.fileTransfering = TRUE;
    
    [WowTalkWebServerIF uploadMediaMessageThumbnail:msg withCallback:@selector(didUploadThumbnail:) withObserver:self];
    [WowTalkWebServerIF uploadMediaMessageOriginalFile:msg withCallback:@selector(didUploadOriginalFile:) withObserver:nil];
    
    [self refreshMessageTableScrollToBottom:YES Animation:NO];
    
   
}


#pragma mark -- pic voice related;
-(void)sendPicVoice{
    OMNewPicVoiceMsgVC *pvvc = [[OMNewPicVoiceMsgVC alloc]init];
    pvvc.dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self._userName];
    pvvc.delegate = self;
    [self.navigationController pushViewController:pvvc animated:YES];

}


#pragma mark -- pic write related;
-(void)sendPicWrite{
    UIActionSheet* actionsheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open album", nil),NSLocalizedString(@"Take a photo", nil), nil];
    [actionsheet showInView:self.view];
    [actionsheet release];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请在【设置-隐私-相机】中允许访问相机。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
                alertView.tag = 3003;
                [alertView show];
                [alertView release];
                return;
                
            }
        }
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }
    
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController* pickerVC = [[[UIImagePickerController alloc] init] autorelease];
        pickerVC.delegate = self;
        pickerVC.allowsEditing = NO;
        pickerVC.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *)
                                   kUTTypeImage, nil] autorelease];
        [pickerVC setSourceType:sourceType];

        if (sourceType==UIImagePickerControllerSourceTypeCamera) {
            pickerVC.showsCameraControls = TRUE;
        }
        
        [self presentViewController:pickerVC animated:YES completion:nil];
        
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}



//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    UIImage *pitToWrite = [AvatarHelper getPhotoFromImage:image];
    DAViewController *myDaVC = [[[DAViewController alloc]init] autorelease];
    myDaVC.myImage=pitToWrite;
    
    myDaVC.parent = self;
    myDaVC.delegate =self;
    
    myDaVC.maxThumbnailSize = CGSizeMake(MULTIMEDIACELL_THUMBNAIL_MAX_X, MULTIMEDIACELL_THUMBNAIL_MAX_Y);
    
    myDaVC.dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self._userName];
    
    [self.navigationController pushViewController:myDaVC animated:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getDataFromDAView:(DAViewController*)requestor{
    self._recordCnt ++;
    
    ChatMessage * msg = [[[ChatMessage alloc] init] autorelease];
    
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.pathOfThumbNail = requestor.thumbnailPath;
    msg.msgType = [ChatMessage MSGTYPE_MULTIMEDIA_PHOTO];
    msg.pathOfMultimedia = requestor.imagePath;
   
    
    msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    
    msg.sentStatus = [ChatMessage SENTSTATUS_FILE_UPLOADINIT];   // this is used to controle whether to show failed mark;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    }
    
    [self addMessageToMessageArray:msg];
    
    
    
    
    NSDictionary* dictonary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"", nil] forKeys:[NSArray arrayWithObjects:PATH_OF_THE_THUMBNAIL_IN_SERVER, PATH_OF_THE_ORIGINAL_FILE_IN_SERVER, nil]];
    SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
    msg.messageContent = [jw stringWithFragment:dictonary];
    msg.primaryKey = [Database storeNewChatMessage:msg]; // save it in the databse;
    msg.fileTransfering = TRUE;
    
    [WowTalkWebServerIF uploadMediaMessageThumbnail:msg withCallback:@selector(didUploadThumbnail:) withObserver:self];
    [WowTalkWebServerIF uploadMediaMessageOriginalFile:msg withCallback:@selector(didUploadOriginalFile:) withObserver:nil];
    
    [self refreshMessageTableScrollToBottom:YES Animation:NO];

}

#pragma mark - pic-voice handler
- (void)getDataFromPVMP:(PicVoiceMsgPreview*)requestor{
    self._recordCnt ++;
    
    ChatMessage * msg = [[[ChatMessage alloc] init] autorelease];
    
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.pathOfThumbNail = requestor.thumbnailPath;
    msg.msgType = [ChatMessage MSGTYPE_PIC_VOICE];
    msg.pathOfMultimedia = requestor.imagePath;
    
    
    msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    
    msg.sentStatus = [ChatMessage SENTSTATUS_FILE_UPLOADINIT];   // this is used to controle whether to show failed mark;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    }
    
    [self addMessageToMessageArray:msg];
    
    
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"", nil] forKeys:[NSArray arrayWithObjects:PATH_OF_THE_THUMBNAIL_IN_SERVER, PATH_OF_THE_ORIGINAL_FILE_IN_SERVER, nil]];
    

    
    if (requestor.recordMsg) {
        
        NSData *nsdata = [requestor.textMsg dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        [dictionary setValue:base64Encoded forKey:@"text"];
        [dictionary setValue:requestor.recordMsg.fileid forKey:@"audio_pathoffileincloud"];
        [dictionary setValue:[NSString stringWithFormat:@"%u",(int)requestor.recordMsg.duration] forKey:@"duration"];
        [dictionary setValue:@"jpg" forKey:@"ext"];
    }
    

    SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
    msg.messageContent = [jw stringWithFragment:dictionary];
    msg.primaryKey = [Database storeNewChatMessage:msg]; // save it in the databse;
    msg.fileTransfering = TRUE;
    
    [WowTalkWebServerIF uploadMediaMessageThumbnail:msg withCallback:@selector(didUploadThumbnail:) withObserver:self];
    [WowTalkWebServerIF uploadMediaMessageOriginalFile:msg withCallback:@selector(didUploadOriginalFile:) withObserver:nil];

    
    [self refreshMessageTableScrollToBottom:YES Animation:NO];
    
}


#pragma mark -- album related;

-(void)selectFromAlbum
{
    
    //  NSLog(@"select photo to send");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        self.pvc = [[[AlbumPickerViewController alloc] initWithNibName:@"AlbumPickerViewController" bundle:nil] autorelease];
        self.pvc.parent = self;
        self.pvc.delegate =self;
        self.pvc.needCropping = NO;
        
        self.pvc.maxThumbnailSize = CGSizeMake(MULTIMEDIACELL_THUMBNAIL_MAX_X, MULTIMEDIACELL_THUMBNAIL_MAX_Y);
        
        self.pvc.dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self._userName];
        
        [self.pvc openAlbum];
        
      //  self.uv_barcontainer.hidden = YES;
    }
}


-(void)getDataFromAlbum:(AlbumPickerViewController *)requestor
{
    self._recordCnt ++;
    
    ChatMessage * msg = [[[ChatMessage alloc] init] autorelease];
    
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.pathOfThumbNail = requestor.thumbnailPath;
    
    if(requestor.mmtType == MMT_PHOTO)
    {
        msg.msgType = [ChatMessage MSGTYPE_MULTIMEDIA_PHOTO];
        msg.pathOfMultimedia = requestor.imagePath;
        
    }
    else if(requestor.mmtType == MMT_MOVIE)
    {
        msg.msgType = [ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE];
        msg.pathOfMultimedia = requestor.videoPath;
    }
    
    msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    
    msg.sentStatus = [ChatMessage SENTSTATUS_FILE_UPLOADINIT];   // this is used to controle whether to show failed mark;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.displayName = self._displayname;
    }
    
    
    [self addMessageToMessageArray:msg];
    
    NSDictionary* dictonary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"", nil] forKeys:[NSArray arrayWithObjects:PATH_OF_THE_THUMBNAIL_IN_SERVER, PATH_OF_THE_ORIGINAL_FILE_IN_SERVER, nil]];
    
    SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
    
    msg.messageContent = [jw stringWithFragment:dictonary];
    
    msg.primaryKey = [Database storeNewChatMessage:msg]; // save it in the databse;
    
    msg.fileTransfering = TRUE;
    
    [WowTalkWebServerIF uploadMediaMessageThumbnail:msg withCallback:@selector(didUploadThumbnail:) withObserver:self];
    [WowTalkWebServerIF uploadMediaMessageOriginalFile:msg withCallback:@selector(didUploadOriginalFile:) withObserver:nil];
    
    [self refreshMessageTableScrollToBottom:YES Animation:NO];
    

}

#pragma mark -- Voice Message Related;


-(IBAction)fBackToTextInput:(id)sender
{
    
    [self.uv_barcontainer setFrame:CGRectMake(0, self.view.frame.size.height- self.uv_barcontainer.frame.size.height, 320, self.uv_barcontainer.frame.size.height)];
    self.uv_defaultoperationbar.hidden = NO;
    
    self.uv_micbar_container.alpha = 0;
    self.uv_defaultoperationbar.alpha = 0;
    self.uv_moreoperationbar.alpha = 0;
    
    [UIView beginAnimations:@"hideMicBar" context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    
    self.uv_defaultoperationbar.alpha = 1;
    self.uv_moreoperationbar.alpha = 1;
    
    [self ScrollChatTableToLatestMessageRow:NO];
    [UIView commitAnimations];
    
    
    [self.recordVC dismissThisView];
    
}

-(IBAction)fPressToRecord:(id)sender
{
    self.btn_gobacktext.enabled = NO;
    
    /*
     if(self._buddy!=nil){
     if( [ self._buddy.appVer intValue] <1000){
     UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle: NSLocalizedString( @"Cannot use this function",nil)
     message: NSLocalizedString( @"Your buddy's WowTalk version is too old to receive this message.",nil)
     delegate: self
     cancelButtonTitle:NSLocalizedString( @"OK",nil)
     otherButtonTitles:nil,nil];
     [alert show];
     [alert release];
     
     return;
     
     }
     
     }
     */
    
    // self.uv_moreoperationbar.hidden = TRUE;
    
    self.recordVC.view.hidden = NO;
    [self.recordVC startRecording];
    
}

-(IBAction)fReleaseToEnd:(id)sender
{
    
    self.btn_gobacktext.enabled = YES;
    [self.recordVC stopRecording];
    
}


-(void) chooseToRecord
{
    
    [self.txtView_Input resignFirstResponder];
    
    [self.uv_barcontainer setFrame:CGRectMake(0, self.view.frame.size.height-40, 320, self.uv_barcontainer.frame.size.height)];
    
    [self refreshMessageTableScrollToBottom:TRUE Animation:TRUE];
    
    self.uv_micbar_container.hidden = NO;
    
    self.uv_micbar_container.alpha = 0;
    
    self.uv_defaultoperationbar.alpha = 1;
    
    self.uv_moreoperationbar.alpha = 1;
    
    [UIView beginAnimations:@"hideDefaulteBar" context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    self.uv_micbar_container.alpha = 1;
    self.uv_defaultoperationbar.alpha = 0;
    self.uv_moreoperationbar.alpha  = 0;
    [UIView commitAnimations];
    
    self.recordVC = [[[AVRecorderVC alloc] initWithNibName:@"AVRecorderVC" bundle:nil] autorelease];
    
    self.recordVC.delegate = self;
    
    self.recordVC.parent = self;
    
    self.recordVC.dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self._userName];
    
    self.recordVC.relativeFilePath = [NSFileManager randomRelativeFilePathInDir:self.recordVC.dirName ForFileExtension:AAC];
    
    self.recordVC.fullFilePath = [NSFileManager absolutePathForFileInDocumentFolder:self.recordVC.relativeFilePath];
    
    
    [[[AppDelegate sharedAppDelegate] window] addSubview:self.recordVC.view];
    
    self.recordVC.view.frame = CGRectMake(0, 20, 320, [UISize screenHeightNotIncludingStatusBar] - 40);
    self.recordVC.view.hidden = YES;  // hide the view;
    
    
}

-(void)sendRecord:(AVRecorderVC *)requestor
{
    
    self._recordCnt ++;
    
    ChatMessage * msg = [[[ChatMessage alloc] init] autorelease];
    
    msg.chatUserName = self._userName;
    
    msg.displayName = self._displayname;
    
    msg.pathOfMultimedia = requestor.relativeFilePath;
    
    msg.msgType = [ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE];
    
    msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    
    msg.sentStatus = [ChatMessage SENTSTATUS_FILE_UPLOADINIT];   // this is used to controle whether to show failed mark;
    
    if (self.isGroupMode) {
        msg.isGroupChatMessage = TRUE;
        msg.groupChatSenderID = [WTUserDefaults getUid];
        msg.displayName = self._displayname;
    }
    
    NSString* duration = [NSString stringWithFormat:@"%u" ,requestor.totalSeconds];
    
    NSDictionary* dictonary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:duration,@"", VoiceMessageNotReaded,AAC, nil] forKeys:[NSArray arrayWithObjects:DURATION, PATH_OF_THE_ORIGINAL_FILE_IN_SERVER, STATUS,VOICE_MESSAGE_EXT, nil]];
    
    SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
    
    msg.messageContent = [jw stringWithFragment:dictonary];
    
    //   msg.fileTransfering = TRUE;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    [self addMessageToMessageArray:msg];
    
    
    /////////////////////////////////////// DO send animation.
    
    
    msg.primaryKey = [Database storeNewChatMessage:msg]; // save it in the databse;
    
    
    
    [WowTalkWebServerIF uploadMediaMessageOriginalFile:msg withCallback:@selector(didUploadOriginalFile:) withObserver:nil];
    
    [self refreshMessageTableScrollToBottom:YES Animation:YES];
    
}


-(void)addMessageToMessageArray:(ChatMessage*)msg
{
    if (self._arrAllMsgs== nil){
        self._arrAllMsgs = [[[NSMutableArray alloc] init] autorelease];
    }
    if (self.arr_photomsgs == nil) {
        self.arr_photomsgs = [[[NSMutableArray alloc] init] autorelease];
    }
    
    [self._arrAllMsgs addObject:msg];
    
    if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]) {
        [self.arr_photomsgs addObject:msg];
    }
    
    if (self.dateOfMessages==nil){
        self.dateOfMessages =[[[NSMutableArray alloc] init] autorelease];
    }
    if (self.listOfMessages==nil) {
        self.listOfMessages =[[[NSMutableArray alloc] init] autorelease];
    }
    
    if ([self.dateOfMessages count]>0 && [[TimeHelper getDayFromTime:msg.sentDate] isEqualToString:[self.dateOfMessages objectAtIndex:([self.dateOfMessages count]-1)]] ){
        [[self.listOfMessages objectAtIndex:([self.listOfMessages count]-1)] addObject:msg];
    }
    else{
        NSMutableArray* arrTmp=[NSMutableArray arrayWithObjects:msg,nil];
        [self.listOfMessages addObject:arrTmp];
        [self.dateOfMessages addObject:[TimeHelper getDayFromTime:msg.sentDate]];
    }
}

#pragma mark - notification callback method
-(NSIndexPath*)indexPathForMessage:(ChatMessage*)msg
{
    int sections = [self numberOfSectionsInTableView:self.tb_messages];
    for (int i = 0; i< sections; i++) {
        int rows = [self tableView:self.tb_messages numberOfRowsInSection:i];
        for (int j = 0; j< rows-1; j++) {
            ChatMessage* oldmsg = (ChatMessage*)[[self.listOfMessages objectAtIndex:i] objectAtIndex:j];
            if (oldmsg.primaryKey == msg.primaryKey) {
                return [NSIndexPath indexPathForRow:j+1 inSection:i];
            }
        }
    }
    return nil;
    
}

-(void)didDownloadThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        ChatMessage* msg = [[notif userInfo] valueForKey:WT_MESSAGE];
        
        NSIndexPath* indexPath = [self indexPathForMessage:msg];
        if (indexPath){
            ChatMessage* oldmsg = (ChatMessage*)[[self.listOfMessages objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
            oldmsg.pathOfThumbNail = msg.pathOfThumbNail;
            [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
}
-(void)didDownloadOriginalFile:(NSNotification*) notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        ChatMessage* msg = [[notif userInfo] valueForKey:WT_MESSAGE];
        
        NSIndexPath* indexPath = [self indexPathForMessage:msg];
        if (indexPath){
            ChatMessage* oldmsg = (ChatMessage*)[[self.listOfMessages objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
            oldmsg.pathOfMultimedia = msg.pathOfMultimedia;
            oldmsg.fileTransfering = FALSE;
            
            [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            /*
             if ([oldmsg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]) {
             //     MultimediaIncomingCell* cell = (MultimediaIncomingCell*)[self.tb_messages cellForRowAtIndexPath:indexPath];
             //      [cell viewThePhoto];
             }
             else
             */
            if ([oldmsg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]]){
                MultimediaIncomingCell* cell = (MultimediaIncomingCell*)[self.tb_messages cellForRowAtIndexPath:indexPath];
                [cell watchTheMovie];
            }
            else if ([oldmsg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]]){
                RecorderIncomingCell* cell = (RecorderIncomingCell*) [self.tb_messages cellForRowAtIndexPath:indexPath];
                [cell playRecord];
            }
        }
    }
}

-(void)didUploadOriginalFile:(NSNotification*) notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        BOOL isSent = [[[notif userInfo] valueForKey:WT_DID_SEND_THE_MESSAGE] boolValue];
        BOOL isSendingGroupMessage = [[[notif userInfo] valueForKey:WT_IS_SENDING_GROUP_MESSAGE] boolValue];
        ChatMessage* msg = [[notif userInfo] valueForKey:WT_MESSAGE];
        
        NSIndexPath* indexPath = [self indexPathForMessage:msg];
        if (indexPath){
            ChatMessage* oldmsg = (ChatMessage*)[[self.listOfMessages objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
            if (isSent && !isSendingGroupMessage) {
                oldmsg.sentStatus = [ChatMessage SENTSTATUS_SENT];
                
            }
            oldmsg.fileTransfering = FALSE;
            [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else{
        
        ChatMessage* msg = [[notif userInfo] valueForKey:WT_MESSAGE];
        
        NSIndexPath* indexPath = [self indexPathForMessage:msg];
        if (indexPath){
            ChatMessage* oldmsg = (ChatMessage*)[[self.listOfMessages objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
            
            oldmsg.sentStatus = [ChatMessage SENTSTATUS_FILE_UPLOADINIT];
            oldmsg.fileTransfering = FALSE;
            [self.tb_messages reloadData];
            // below will crash. wierd
            //  [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
}
-(void)didUploadThumbnail:(NSNotification*) notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        BOOL isSent = [[[notif userInfo] valueForKey:WT_DID_SEND_THE_MESSAGE] boolValue];
        BOOL isSendingGroupMessage = [[[notif userInfo] valueForKey:WT_IS_SENDING_GROUP_MESSAGE] boolValue];
        ChatMessage* msg = [[notif userInfo] valueForKey:WT_MESSAGE];
        NSIndexPath* indexPath = [self indexPathForMessage:msg];
        if (indexPath) {
            ChatMessage* oldmsg = (ChatMessage*)[[self.listOfMessages objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
            if (isSent && !isSendingGroupMessage){
                oldmsg.sentStatus = [ChatMessage SENTSTATUS_SENT];
            }
            oldmsg.fileTransfering = FALSE;
            [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else{
        ChatMessage* msg = [[notif userInfo] valueForKey:WT_MESSAGE];
        
        NSIndexPath* indexPath = [self indexPathForMessage:msg];
        if (indexPath){
            ChatMessage* oldmsg = (ChatMessage*)[[self.listOfMessages objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
            
            oldmsg.sentStatus = [ChatMessage SENTSTATUS_FILE_UPLOADINIT];
            oldmsg.fileTransfering = FALSE;
            [self.tb_messages reloadData];
            //    [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
    
}

-(void)didSendChatByWebIF:(NSNotification*) notif
{
    ChatMessage* msg = [[notif userInfo] valueForKey:WT_MESSAGE];
    
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    
    /**
     * 已经被请出群组，提示消息
     */
    if(error.code == 37 && self.isGroupMode){
        [Database deleteFixedGroupByID:_userName];
        [Database deleteChatMessageWithUser:_userName];
        [[NSNotificationCenter defaultCenter]postNotificationName:WT_KICKOUT_GROUP object:nil];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"You have been out of the group",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
        alertView.tag = 3000;
        [alertView show];
        [alertView release];
        return;
    }
    
    if (error.code != NO_ERROR) {
        NSLog(@"send chatmsg by webif failed.");
        
    }
    
    NSIndexPath* indexPath = [self indexPathForMessage:msg];
    
    if (indexPath) {
        //   ChatMessage* oldmsg = (ChatMessage*)[[self.listOfMessages objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
        //   oldmsg.sentStatus = msg.sentStatus;
        [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

-(void)getChatMessage_ReachedReceipt:(NSNotification*)notif
{
    /*TODO: if we want to be consistent with wowtalk, we have to take care of the old wowtalkers*/
    NSString* messageID = [notif.userInfo objectForKey: @"data"];
    if (messageID) {
        for (int i=0; i<[self.listOfMessages count]; i++) {
            NSArray* arrTmp = (NSArray*)[self.listOfMessages objectAtIndex:i];
            for (int j=0; j<[arrTmp count]; j++) {
                ChatMessage* msgTmp = (ChatMessage*)[arrTmp objectAtIndex:j];
                if (msgTmp.primaryKey == [messageID integerValue]) {
                    
                    if(![msgTmp.sentStatus isEqualToString:[ChatMessage SENTSTATUS_READED_BY_CONTACT]]){
                        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j+1 inSection:i];
                        msgTmp.sentStatus = [ChatMessage SENTSTATUS_REACHED_CONTACT];
                        [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    break;
                }
            }
        }
    }
}

-(void)getChatMessage_ReadedReceipt:(NSNotification*)notif
{
    NSString* messageID = [notif.userInfo objectForKey: @"data"];
    
    for (int i=0; i<[self.listOfMessages count]; i++) {
        NSArray* arrTmp = (NSArray*)[self.listOfMessages objectAtIndex:i];
        for (int j=0; j<[arrTmp count]; j++) {
            ChatMessage* msgTmp = (ChatMessage*)[arrTmp objectAtIndex:j];
            if (msgTmp.primaryKey == [messageID integerValue]) {
                //TODO: you may want to change the read count for the group message here. in the future.
                msgTmp.sentStatus = [ChatMessage SENTSTATUS_READED_BY_CONTACT];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j+1 inSection:i];
                [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
}

-(void) sendChatMessageUpdate:(NSNotification*)notif{
    
    ChatMessage* msg = (ChatMessage *)[notif.userInfo objectForKey: @"data"];
    for (int i=0; i<[self.listOfMessages count]; i++) {
        NSArray* arrTmp = (NSArray*)[self.listOfMessages objectAtIndex:i];
        for (int j=0; j<[arrTmp count]; j++) {
            ChatMessage* msgTmp = (ChatMessage*)[arrTmp objectAtIndex:j];
            if (msgTmp.primaryKey == msg.primaryKey) {
                msgTmp.sentStatus = msg.sentStatus;
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j+1 inSection:i];
                [self.tb_messages reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
}

#pragma mark -- button touch down and up methods
-(IBAction)buttonIsTouchedDown:(id)sender
{
    //  [(UIButton*)sender setBackgroundColor:[Theme sharedInstance].currentTileColor];
}

-(IBAction)buttonIsTouchedUp:(id)sender
{
    if (sender == self.btn_mic) {
        [self chooseToRecord];
    }
    else if(sender == self.btn_location){
        [self sendCurrentLocation];
    }
    
    else if(sender == self.btn_camera){
        [self captureUseCamera];
    }
    else if(sender == self.btn_photo)
    {
        [self selectFromAlbum];
    }
    else if (sender == self.btn_videocall){
        [self callWithVideo:TRUE];
    }
    else if (sender == self.btn_call){
        [self callWithVideo:FALSE];
    }
    else if (sender == self.btn_pic_write){
        [self sendPicWrite];
    }
    else if (sender == self.btn_pic_voice){
        [self sendPicVoice];
    }
}


-(UIImage*)getMessageBuddyProfile:(ChatMessage*) msg
{
    UIImage* image;
    if (msg.isGroupChatMessage) {
        image = [UIImage imageWithData:[AvatarHelper getThumbnailForUser:msg.groupChatSenderID]];
    }
    else
        image = [UIImage imageWithData:[AvatarHelper getThumbnailForUser:self._userName]];
    
    if (image == nil) {
        Buddy* buddy = [Database buddyWithUserID:msg.groupChatSenderID];
        if ([buddy.buddy_flag isEqualToString:@"2"]) {
            image = [UIImage imageNamed:DEFAULT_AVATAR_OFFLINE_IMAGE_90];
        }
        else
            image = [UIImage imageNamed:DEFAULT_AVATAR];
    }
    return image;
}


#pragma mark -
#pragma mark View Handle
-(void) setMessageNotAutoPlay
{
    for (ChatMessage* msg in self.arrayOfAutoplayMessages)
    {
        SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
        
        NSMutableDictionary* dic = (NSMutableDictionary*)[jp fragmentWithString:msg.messageContent];
        
        [dic setValue:STAMP_NO_AUTOPLAY forKey:STAMP_AUTO_PLAY];
        
        SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
        msg.messageContent = [jw stringWithFragment:dic];
        [Database updateChatMessage:msg];
        
    }
}

-(void)goBack
{
    [self.uv_barcontainer removeFromSuperview];
    
    if (self.recordVC != nil)
    {
        [self.recordVC.view removeFromSuperview];
    }
    
    if ([[VoiceMessagePlayer sharedInstance] isPlaying]) {
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
    }
    
    [VoiceMessagePlayer sharedInstance].isLocked = TRUE;
    
    self.maxNumofThumbnailsToBeDownload = 0;
    
    self.needToDownloadMissingThumbnails = FALSE;
    
    [[AppDelegate sharedAppDelegate] setIsCallFromMsgComposer:NO];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self setMessageNotAutoPlay];
    
}

-(void)callWithVideo:(BOOL)withVideo
{
    
    BOOL callsuccess =  [WowTalkVoipIF fNewOutgoingCall:self._userName withDisplayName:self._displayname withVideo:withVideo];
    
    [self.txtView_Input resignFirstResponder];
    
 //   self.uv_barcontainer.hidden = YES;
    
    [[AppDelegate sharedAppDelegate] setIsCallFromMsgComposer:YES];
    
    if (self.recordVC != nil) {
        [self.recordVC.view removeFromSuperview];
    }
    
    if (!callsuccess){
      //  self.uv_barcontainer.hidden = NO;
        [[AppDelegate sharedAppDelegate] setIsCallFromMsgComposer:NO];
    }
}

- (void)detailClicked
{
    if (self.isGroupMode)
    {
        [self.txtView_Input resignFirstResponder];
        //   self.uv_barcontainer.hidden = YES;
        _isKeyboardShown = FALSE;
        
        if (self.recordVC != nil) {
            [self.recordVC.view removeFromSuperview];
        }

        
        BOOL isTempGroup = [Database getGroupChatRoomByGroupid:self._userName].isTemporaryGroup;
        
        if (!isTempGroup) {
            GroupInfoViewController *groupinfoviewcontroller = [[GroupInfoViewController alloc] init];
            groupinfoviewcontroller.groupid = self._userName;
            [self.navigationController pushViewController:groupinfoviewcontroller animated:YES];
            [groupinfoviewcontroller release];
        }
        else{
            
            TempChatRoomInfoViewController* tcrivc = [[TempChatRoomInfoViewController alloc] init];
            tcrivc.groupid = self._userName;
            [self.navigationController pushViewController:tcrivc animated:TRUE];
            [tcrivc release];
        }
    }
    else{
        
        [self.txtView_Input resignFirstResponder];
        //  self.uv_barcontainer.hidden = YES;
        _isKeyboardShown = FALSE;
        
        if (self.recordVC != nil) {
            [self.recordVC.view removeFromSuperview];
        }
        ContactPickerViewController *cpvc = [[ContactPickerViewController alloc] initWithNibName:@"ContactPickerViewController" bundle:nil];
        cpvc.isAddMembersToStartAGroupChat = TRUE;
        cpvc.exsitingBuddys = [NSMutableArray arrayWithObject:[Database buddyWithUserID:self._userName]];
        [self.navigationController pushViewController:cpvc animated:YES];
        [cpvc release];         
    }
}


-(IBAction)addStrangerToContact:(id)sender
{
    
    [WTHelper WTLog:@"No contact function "];
}

- (IBAction)shouldToggleMoreOperationBar:(id)sender {
    if (!self.moreBarShown) {
        // open the more operation bar
        if ([self.uv_moreoperationbar superview] != self.uv_barcontainer) {
            [self.uv_barcontainer addSubview:self.uv_moreoperationbar];
        }
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.uv_barcontainer.frame =
                             CGRectMake(0, self.view.frame.size.height - self.familyOperationBar.frame.size.height - self.uv_moreoperationbar.frame.size.height, 320, self.familyOperationBar.frame.size.height + 216);
                             self.uv_moreoperationbar.frame =
                             CGRectMake(0, self.familyOperationBar.frame.size.height, 320, 216);
                         }
                         completion:^(BOOL finished){
                             [self.familyOperationBarIndicator setImage:[UIImage imageNamed:@"sms_fold_btn.png"]
                                                               forState:UIControlStateNormal];
                             self.moreBarShown = YES;
                             if (!containsTapGuesture) {
                                 
                                 [self.tb_messages addGestureRecognizer:self.tapRecognizer];
                                 
                                 containsTapGuesture = YES;
                             }
                         }];
    } else {
        // close the more operation bar
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.uv_barcontainer.frame =
                             CGRectMake(0, self.view.frame.size.height - self.familyOperationBar.frame.size.height, 320, self.familyOperationBar.frame.size.height);
//                             self.uv_moreoperationbar.frame = CGRectMake(0, self.familyOperationBar.frame.size.height, 320, 0);
                         }
                         completion:^(BOOL finished){
                             [self.familyOperationBarIndicator setImage:[UIImage imageNamed:@"sms_unfold_btn.png"]
                                                               forState:UIControlStateNormal];
                             self.moreBarShown = NO;
                             if (containsTapGuesture) {
                                 [self.tb_messages removeGestureRecognizer:self.tapRecognizer];
                                 containsTapGuesture = NO;
                             }
                         }];
    }
}



-(void) configNav
{
    
    self.uv_navcontainer.backgroundColor = [UIColor clearColor];
    
    self.lbl_namelist.text = _compositeName;
    self.lbl_namelist.backgroundColor = [UIColor clearColor];
    self.lbl_namelist.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    //   self.lbl_namelist.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.lbl_namelist.textAlignment = NSTextAlignmentCenter;
    self.lbl_namelist.textColor = [Colors whiteColor]; // change this color
    
    
    self.navigationItem.titleView = self.uv_navcontainer;
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
         [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
    if (!self.isTalkingToOfficialUser) {
        UIBarButtonItem *rightbarButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAC_CHAT_INFO] selector:@selector(detailClicked)];
           [self.navigationItem addRightBarButtonItem:rightbarButton];
        [rightbarButton release];
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configNav];
    
    self.view.frame = CGRectMake(0, [UISize heightOfStatusBarAndNavBar], 320, [UISize screenHeightNotIncludingStatusBarAndNavBar]);
    
    self.view.backgroundColor =  [Colors chatRoomBackgroundColor];
    self.tb_messages.backgroundColor = [Colors chatRoomBackgroundColor];
    
    self.uv_barcontainer = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)] autorelease] ;
    [self.view addSubview:uv_barcontainer];
    
    
    
    
    // init default operation bar.
    [self.uv_defaultoperationbar setFrame:CGRectMake(0, 0, 320, 40)];
    [self.uv_barcontainer addSubview:self.uv_defaultoperationbar];
    self.uv_defaultoperationbar .backgroundColor =[UIColor clearColor];
    
    
    // family operation bar
    [self.familyOperationBar setFrame:CGRectMake(0, 0, 320, 40)];
    [self.uv_barcontainer addSubview:self.familyOperationBar];
    self.familyOperationBar.backgroundColor = [UIColor clearColor];
    self.moreBarShown = NO;
    
    
    [self.familyOperationBar setHidden:YES];
    [self.uv_defaultoperationbar setHidden:NO];
    
    
    [self.iv_defaultoperationbar_bg setBackgroundColor:[UIColor whiteColor]];
    [self.iv_micbar_bg setBackgroundColor:[UIColor whiteColor]];
    [self.familyOperationBarBackground setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [self.btn_send setBackgroundImage:[PublicFunctions strecthableImage:MESSAGE_SEND_BUTTON_IMAGE] forState:UIControlStateNormal];
    [self.btn_send setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [self.btn_send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btn_send addTarget:self action:@selector(sendTextMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn_showmore setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_SHOW_MORE ] forState:UIControlStateNormal];
    
    [self.btn_stamp setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_STAMP] forState:UIControlStateNormal];
    
    [self.btn_keyboard setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension: SMS_KEYBOARD] forState:UIControlStateNormal];
    
    [self.btn_keyboard setHidden:YES];
    
    
    // mic bar customization
    self.uv_micbar_container.frame = CGRectMake(0, 0, 320, 40);
    
    self.uv_micbar_container.backgroundColor = [UIColor clearColor];
    
    
    self.uv_micbar.frame = CGRectMake(40, 4, 275, 32);
    
    self.uv_micbar.backgroundColor =[UIColor clearColor];
    
    [self.iv_micbar_bg setFrame:CGRectMake(0, 0, 320, 40)];
    
    [self.iv_mic_icon setImage:[PublicFunctions imageNamedWithNoPngExtension:SMALL_MIC_ICON]];
    [self.iv_mic_icon setFrame:CGRectMake(65, 30, 4, 24)];
    
    [self.iv_mic_icon setHidden:TRUE];
    
    
    
    CALayer *btn_record_myLayer = [self.btn_record layer];
    [btn_record_myLayer setMasksToBounds:YES];
    [btn_record_myLayer setCornerRadius:10.0f];
    [btn_record_myLayer setBorderWidth:1.0f];
    [btn_record_myLayer setBorderColor: [[UIColor clearColor] CGColor]];
    
    
    [self.btn_record setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
    
    self.lbl_recorddesc.text = NSLocalizedString(@"Press and talk", nil);
    self.lbl_recorddesc.backgroundColor = [UIColor clearColor];
    self.lbl_recorddesc.textColor = [Colors whiteColor];
    
    [self.uv_barcontainer addSubview:self.uv_micbar_container];
    ////////////////////////////////////////////////////////////////////////
    
    // minheight is 35;
    self.txtView_Input = [[[HPGrowingTextView alloc] initWithFrame:CGRectMake(75, 5, 185, 30)] autorelease];
    txtView_Input.delegate = self;
    
    
    // input box bg.
    UIImage* image = [PublicFunctions strecthableImage:SMS_TEXT_INPUT_BG];
    [self.iv_inputbox_bg setFrame:CGRectMake(75, 5, 185, 30)];
    [self.iv_inputbox_bg setImage:image];
    
    // the corner radius of the button
    CALayer* txtinput_Layer = [self.txtView_Input layer];
    [txtinput_Layer setMasksToBounds:YES];
    [txtinput_Layer setCornerRadius:10.0f];
    [txtinput_Layer setBorderWidth:1.0f];
    [txtinput_Layer setBorderColor: [[UIColor clearColor] CGColor]];
    [txtinput_Layer setBackgroundColor: [[UIColor clearColor] CGColor]];
    
    CALayer* txtview_input_internal_layer = [txtView_Input.internalTextView layer];
    [txtview_input_internal_layer setMasksToBounds:YES];
    [txtview_input_internal_layer setCornerRadius:10.0f];
    [txtview_input_internal_layer setBorderWidth:1.0f];
    [txtview_input_internal_layer setBorderColor: [[UIColor clearColor] CGColor]];
    //  [txtview_input_internal_layer setBackgroundColor: [[Theme sharedInstance].currentColorForOutgoingChatCellBG CGColor]];
    [txtview_input_internal_layer setBackgroundColor:[[UIColor clearColor] CGColor]];
    
    [self.txtView_Input  setPlaceholder:@""];
    
    [self.uv_defaultoperationbar addSubview:self.txtView_Input];
    
    [txtView_Input sizeToFit];
    
    
    // pull to refresh header
    EGORefreshTableHeaderView *view = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tb_messages.bounds.size.height, self.view.frame.size.width, self.tb_messages.bounds.size.height)] autorelease];
    
    view.delegate = self;
    
    [self.tb_messages addSubview:view];
    self._refreshHeaderView = view;
    self._refreshHeaderView.backgroundColor = [UIColor clearColor];
    self._refreshHeaderView.updateString = NSLocalizedString(@"Loading more messages...", @"Loading Status");
    
    self.warningDesc = NSLocalizedString(@"WowTalk supports more types of messages now, please click me to update wowtalk to see this message!", nil);
    
    
    //  [[wowtalkAppDelegate sharedAppDelegate] setIsCallFromMsgComposer:YES];
    
    
    // input mode
    self.mInputMode = TEXT_MODE;
    
    self.uv_micbar_container.hidden = YES;
    self.uv_defaultoperationbar.hidden = NO;
    
    
    UITapGestureRecognizer *gestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)] autorelease];
    gestureRecognizer.delegate = self;
    
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.tb_messages addGestureRecognizer:gestureRecognizer];
    
    [VoiceMessagePlayer sharedInstance].isLocked = FALSE;
    
    
    [self.uv_moreoperationbar setBackgroundColor:[UIColor clearColor]];
    [self.btn_location setBackgroundColor:[UIColor clearColor]];
    [self.btn_photo setBackgroundColor:[UIColor clearColor]];
    [self.btn_mic setBackgroundColor:[UIColor clearColor]];
    [self.btn_camera setBackgroundColor:[UIColor clearColor]];
    [self.btn_call setBackgroundColor:[UIColor clearColor]];
    [self.btn_videocall setBackgroundColor:[UIColor clearColor]];
    [self.btn_pic_write setBackgroundColor:[UIColor clearColor]];
    [self.btn_pic_voice setBackgroundColor:[UIColor clearColor]];
    
//    [self.btn_photo setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_ALBUM] forState:UIControlStateNormal];
//    
//    [self.btn_mic setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_MIC] forState:UIControlStateNormal];
//    
//    [self.btn_location setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_LOCATION] forState:UIControlStateNormal];
//    
//    [self.btn_camera setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_CAMERA] forState:UIControlStateNormal];
//    
//    // [self.btn_gobacktext setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_CLOSE_MORE] forState:UIControlStateNormal];
//    
//    [self.iv_goback setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_CLOSE_MORE]];
//    
//    
//    [self.btn_videocall setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_VIDEOCALL] forState:UIControlStateNormal];
//    [self.btn_call setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_CALL] forState:UIControlStateNormal];
//    
//    [self.btn_pic_write setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_PICWRITE] forState:UIControlStateNormal];
//    [self.btn_pic_voice setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_PICVOICE] forState:UIControlStateNormal];
    
    
    
    /**
     *  新UI
     */
    [self.btn_photo setImage:[UIImage imageNamed:@"icon_messages_more_pic"] forState:UIControlStateNormal];
    [self.btn_photo setImage:[UIImage imageNamed:@"icon_messages_more_pic_p"] forState:UIControlStateHighlighted];
    
    
    
    
    [self.btn_mic setImage:[UIImage imageNamed:@"icon_messages_more_call"] forState:UIControlStateNormal];
    [self.btn_mic setImage:[UIImage imageNamed:@"icon_messages_more_call_p"] forState:UIControlStateHighlighted];
    
    
    
    [self.btn_location setImage:[UIImage imageNamed:@"icon_messages_more_location"] forState:UIControlStateNormal];
    [self.btn_location setImage:[UIImage imageNamed:@"icon_messages_more_location_p"] forState:UIControlStateHighlighted];
    
    [self.btn_camera setImage:[UIImage imageNamed:@"icon_messages_more_camera"] forState:UIControlStateNormal];
    [self.btn_camera setImage:[UIImage imageNamed:@"icon_messages_more_camera_p"] forState:UIControlStateHighlighted];
    
    
    // [self.btn_gobacktext setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_CLOSE_MORE] forState:UIControlStateNormal];
    
    [self.iv_goback setImage:[PublicFunctions imageNamedWithNoPngExtension:SMS_CLOSE_MORE]];
    
    [self.btn_videocall setImage:[UIImage imageNamed:@"icon_messages_more_video"] forState:UIControlStateNormal];
    [self.btn_videocall setImage:[UIImage imageNamed:@"icon_messages_more_video_p"] forState:UIControlStateHighlighted];
    [self.btn_call setImage:[UIImage imageNamed:@"icon_messages_more_call"] forState:UIControlStateNormal];
    [self.btn_call setImage:[UIImage imageNamed:@"icon_messages_more_call_p"] forState:UIControlStateHighlighted];
    [self.btn_pic_write setImage:[UIImage imageNamed:@"icon_messages_more_pic_write"] forState:UIControlStateNormal];
    [self.btn_pic_write setImage:[UIImage imageNamed:@"icon_messages_more_pic_write_p"] forState:UIControlStateHighlighted];
    [self.btn_pic_voice setImage:[UIImage imageNamed:@"icon_messages_more_pic_voice"] forState:UIControlStateNormal];
    [self.btn_pic_voice setImage:[UIImage imageNamed:@"icon_messages_more_pic_voice_p"] forState:UIControlStateHighlighted];
    
    
    
    if (self.isGroupMode) {
        [self.btn_videocall setHidden:TRUE];
        [self.btn_call setHidden:TRUE];
    }
    else
    {
        [self.btn_call setHidden:false];
        [self.btn_videocall setHidden:false];
    }
    
    //   self.expressionPickView = [[[ ExpressionPickView alloc] initWithFrame:CGRectMake(0, [UISize screenHeight] - 216, [UISize screenWidth], 216)] autorelease];
    
    //   self.expressionPickView.delegate = self;
    
    // tap gesture set up.
    self.tapRecognizer = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleTheExtraBoard:)] autorelease];
    self.tapRecognizer.delegate = self;
    
    self.arrayOfAutoplayMessages = [[[NSMutableArray alloc] init] autorelease];
    
    
    if ([self.buddys count] == 1) {
        [self.btn_send setEnabled:FALSE];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadThumbnail:) name:WT_DOWNLOAD_MEDIAMESSAGE_THUMBNAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadOriginalFile:) name:WT_DOWNLOAD_MEDIAMESSAGE_ORIGINAL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSendChatByWebIF:) name:WT_SEND_GROUP_MESSAGES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSendChatByWebIF:) name:WT_SEND_MSG_TO_OFFICIAL_USER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUploadOriginalFile:) name:WT_UPLOAD_MEDIAMESSAGE_ORIGINAL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUploadThumbnail:) name:WT_UPLOAD_MEDIAMESSAGE_THUMBNAIL object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatMessage_ReachedReceipt:)
                                                 name:notif_WTSentMsgReachedReceiptReceived
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatMessage_ReadedReceipt:)
                                                 name:notif_WTSentMsgReadedReceiptReceived
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendChatMessageUpdate:)
                                                 name:notif_WTChatMessageSentStatusUpdate
                                               object:nil];
    
    /** 学生*/
//    [OMNotificationCenter addObserver:self selector:@selector(reloadDataForBuddyInfoChanged) name:MY_CLASS_GETSCHOOLINFO object:nil];
    
    firstOpenTime = TRUE;
    
    
    // add label to buttons in more operation rect
    
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 80, 18)];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Colors wowtalkbiz_Text_grayColorThree];
    lbl.text = NSLocalizedString(@"Voice", nil);
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.btn_mic addSubview:lbl];
    [lbl release];
    
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 80, 18)];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Colors wowtalkbiz_Text_grayColorThree];
    lbl.text = NSLocalizedString(@"Photo", nil);
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.btn_photo addSubview:lbl];
    [lbl release];
    
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 80, 18)];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Colors wowtalkbiz_Text_grayColorThree];
    lbl.text = NSLocalizedString(@"Camera", nil);
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.btn_camera addSubview:lbl];
    [lbl release];
    
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 80, 18)];
    lbl.font = [UIFont systemFontOfSize:15];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Colors wowtalkbiz_Text_grayColorThree];
    lbl.text = NSLocalizedString(@"Location", nil);
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.btn_location addSubview:lbl];
    [lbl release];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 80, 18)];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Colors wowtalkbiz_Text_grayColorThree];
    lbl.text = NSLocalizedString(@"NormalCall", nil);
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.btn_call addSubview:lbl];
    [lbl release];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 80, 18)];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Colors wowtalkbiz_Text_grayColorThree];
    lbl.text = NSLocalizedString(@"Video Call", nil);
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.btn_videocall addSubview:lbl];
    [lbl release];
    
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 80, 18)];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Colors wowtalkbiz_Text_grayColorThree];
    lbl.text = NSLocalizedString(@"Hand-writing", nil);
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.btn_pic_write addSubview:lbl];
    [lbl release];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 80, 18)];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Colors wowtalkbiz_Text_grayColorThree];
    lbl.text = NSLocalizedString(@"Pic-voice", nil);
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.btn_pic_voice addSubview:lbl];
    [lbl release];
    
    
    
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tb_messages setFrame:CGRectMake(0, 0, self.tb_messages.frame.size.width, [UISize screenHeight] - 20 - 44)];
        
        self.view.backgroundColor = [UIColor whiteColor];
        [self.tb_messages setBackgroundColor:[UIColor whiteColor]];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    if ([AppDelegate sharedAppDelegate].needRefreshMsgComposer) {
        [self getMessagesList];                     // TODO: we do not need to get the messages if it is entering the room for the first time.
        [self.tb_messages reloadData];
        [AppDelegate sharedAppDelegate].needRefreshMsgComposer = FALSE;
    }
    
    if (firstOpenTime) {
        [self refreshMessageTableScrollToBottom:YES Animation:NO];
        firstOpenTime = FALSE;
    }
    
    if (isGroupMode) {
        self._compositeName = [Database getGroupChatRoomByGroupid:self._userName].groupNameOriginal;
        [self updateGroupChatName:self._userName];
        
        self.lbl_namelist.text = self._compositeName;
        
    }
//    [self.uv_barcontainer setHidden:NO];
    
    
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tb_messages addGestureRecognizer:longPressRecognizer];
    [longPressRecognizer release];
    
    
    if (!_isKeyboardShown) {
        [self resignTextView];
    }
    
    if (IS_IOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ////////////////////////////////////////////////////////////////////////
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideEditMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
    
    
    ////////////////////////////////////////////////////////////////////////
    
    [[AppDelegate sharedAppDelegate] setIsCallFromMsgComposer:YES];
    
    [VoiceMessagePlayer sharedInstance].isLocked = FALSE;
    
    
    if (self.needToDownloadMissingThumbnails)
    {
        [self downloadMissingThumbnails];
    }
    
    if ( nil == _expressionPickView) {
        
        self.expressionPickView = [[[ ExpressionPickView alloc] initWithFrame:CGRectMake(0, self.uv_defaultoperationbar.frame.size.height, [UISize screenWidth], STAMPBOARD_HEIGHT)] autorelease];
        self.expressionPickView.delegate = self;
    }
    
    
    if ([AppDelegate sharedAppDelegate].isForwarding) {
        [AppDelegate sharedAppDelegate].isForwarding = FALSE;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Forward this message", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
        [alert show];
        [alert release];
    }
    
    if (_isRemoveBuddyPop && !isGroupMode){
        _isRemoveBuddyPop = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
    if (_isFristChat && !isGroupMode){
        [self sendFirstMessage];
    }
//    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.uv_barcontainer.frame.size.height + self.uv_barcontainer.frame.origin.y);
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3000){
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (buttonIndex != alertView.cancelButtonIndex && alertView.tag != 3003) {
        [self forwardSelectedMessage:[AppDelegate sharedAppDelegate].forwardingmsg];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    _isFristChat = NO;
    if (_isKeyboardShown) {
        [self resignTextView];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    
    for (UIGestureRecognizer* gesture in self.tb_messages.gestureRecognizers) {
        if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [self.tb_messages removeGestureRecognizer:gesture];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.expressionPickView finishTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
    
}


-(void)didReceiveMemoryWarning
{
    if (!self.isViewLoaded && !self.view.window) {
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.tb_messages=nil;;
    
    // navigation bar
    self.btn_goback=nil;
    self.btn_call = nil;
    self.btn_videocall = nil;
    self.uv_navcontainer = nil;
    self.btn_addtocontact = nil;
    self.lbl_namelist =nil;
    
    
    self.uv_barcontainer = nil;
    
    //default operation bar
    self.uv_defaultoperationbar = nil;
    
    self.iv_defaultoperationbar_bg = nil;
    
    self.txtView_Input = nil;
    self.btn_send = nil;
    self.btn_showmore = nil;
    self.btn_hidemore = nil;
    self.btn_keyboard = nil;
    
    self.btn_record = nil;
    self.lbl_recorddesc = nil;
    self.uv_micbar = nil;
    
    
    //more operation bar
    self.uv_moreoperationbar = nil;
    self.iv_moreoperationbar_bg = nil;
    
    self.btn_mic = nil;
    self.btn_location = nil;
    self.btn_photo = nil;
    
    self.btn_camera = nil;
    
    self.btn_pic_write = nil;
    self.btn_pic_voice = nil;
    
    self.recordVC = nil;
    self.pvc = nil;
    self.cameraViewController = nil;
    
    self._arrAllMsgs = nil;
    self.dateOfMessages = nil;
    self.listOfMessages = nil;
    self._displayname = nil;
    self._userName = nil;
    self._buddy = nil;
    self.imageForProfile = nil;
    
    self._refreshHeaderView = nil;
    self.warningDesc = nil;
    
    self.arrayOfAutoUploadingIndexPaths = nil;
    
    self.cllmanager = nil;
    self.expressionPickView = nil;
    self.tapRecognizer = nil;
    
    self.arrayOfAutoplayMessages = nil;
    self.buddys = nil;

    
    [super dealloc];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return 0;
}
#pragma mark - 
#pragma mark - UITextViewDelegate

-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{
    /*
    BOOL isFridend = [Database isFriendWithUID:_buddy.userID]; // 是否是好友
    BOOL isSchoolMember = [Database isSchollMember:_buddy.userID];  // 是否死学校成员
    //    BOOL isSelf = [[WTUserDefaults getUid] isEqualToString:_buddy.userID];// 是否是当前用户
    if (!isFridend  && !isSchoolMember){
        [self.view endEditing:YES];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"你们还不是好友，请先添加好友后再聊天",nil) delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1];
    }
     */
}

#pragma mark -- copy and paste
-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{
    
    if (pGesture.state == UIGestureRecognizerStateRecognized)
    {
        //Do something to tell the user!
    }
    if (pGesture.state == UIGestureRecognizerStateEnded)
    {
        UITableView* tableView = (UITableView*)self.tb_messages;
        CGPoint touchPoint = [pGesture locationInView:self.tb_messages];
        NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:touchPoint];
        
        if (indexPath.row == 0) {
            return;
        }
        if (indexPath != nil) {
            
            ChatMessage* msg=(ChatMessage*)[[self.listOfMessages objectAtIndex:([indexPath section])] objectAtIndex:[indexPath row]-1];
            
            UIMenuController *menu = [UIMenuController sharedMenuController];
            
            UIMenuItem* item1 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Delete", nil) action:@selector(deleteMessage:)];
            
            self.longPressedCellIndex = indexPath;
            
            if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]]) {
                if (![menu isMenuVisible])
                {

                    [menu setMenuItems:[NSArray arrayWithObjects:item1, nil]];
                    [item1 release];

                    
                    if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]]) {
                        TextOutgoingCell* cell = (TextOutgoingCell*)[self.tb_messages cellForRowAtIndexPath:indexPath];
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:@"sms_right_balloon_p"];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:15 topCapHeight:22];
                        [cell.iv_bg setImage:newImage];
                        
                        if (cell) {
                            [self becomeFirstResponder];
                            [menu setTargetRect:CGRectMake(cell.frame.origin.x + cell.iv_bg.frame.origin.x,cell.frame.origin.y+ cell.iv_bg.frame.origin.y, cell.iv_bg.frame.size.width, 0) inView:self.tb_messages];
                            [menu setMenuVisible:YES animated:YES];
                        }
                    }
                    else{
                        
                        TextIncomingCell* cell = (TextIncomingCell*)[self.tb_messages cellForRowAtIndexPath:indexPath];
                        
                        UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:@"sms_left_balloon_p"];
                        UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:15 topCapHeight:22];
                        [cell.iv_bg setImage:newImage];
                        
                        if (cell) {
                            [self becomeFirstResponder];
                            [menu setTargetRect:CGRectMake(cell.frame.origin.x + cell.iv_bg.frame.origin.x,cell.frame.origin.y+ cell.iv_bg.frame.origin.y, + cell.iv_bg.frame.size.width, 0) inView:self.tb_messages];
                            [menu setMenuVisible:YES animated:YES];
                        }
                    }
                }
            }
        }
    }
}

-(void)copy:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    ChatMessage* msg=(ChatMessage*)[[self.listOfMessages objectAtIndex:([self.longPressedCellIndex section])] objectAtIndex:[self.longPressedCellIndex row]-1];
    
    [pasteboard setString:msg.messageContent];
    // [pasteboard setImage:self.image];
}

-(void)forwardMessage:(id)sender
{
    ChatMessage* msg=(ChatMessage*)[[self.listOfMessages objectAtIndex:([self.longPressedCellIndex section])] objectAtIndex:[self.longPressedCellIndex row]-1];
    
    [AppDelegate sharedAppDelegate].forwardingmsg = msg;
 /*
    BizContactPickerViewController* bpvc = [[BizContactPickerViewController alloc] init];
    bpvc.isChosenToStartAChat = TRUE;
    bpvc.isForwardingMode = TRUE;
    
    UINavigationController *navController = [CustomNavigationBar navigationControllerWithRootViewController:bpvc];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:navController animated:YES];
    [bpvc release];
  */
    // TODO: implement in wowcity
}


-(void)deleteMessage:(id)sender
{
    
    ChatMessage* msg=(ChatMessage*)[[self.listOfMessages objectAtIndex:([self.longPressedCellIndex section])] objectAtIndex:[self.longPressedCellIndex row]-1];
    
    
    // set the cell background back
    if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]]) {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]]) {
            UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension: OUTGOINGCELL_BG_FILENAME];
            UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
            TextOutgoingCell* cell = (TextOutgoingCell*)[self.tb_messages cellForRowAtIndexPath:self.longPressedCellIndex];
            [cell.iv_bg setImage:newImage];
        }
        else{
            
            UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:INCOMINGCELL_BG_FILENAME];
            UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
            
            TextIncomingCell* cell = (TextIncomingCell*)[self.tb_messages cellForRowAtIndexPath:self.longPressedCellIndex];
            [cell.iv_bg setImage:newImage];
        }
    }
    
    
    
    if ([[self.listOfMessages objectAtIndex:([self.longPressedCellIndex section])] count] > 1) {
        [[self.listOfMessages objectAtIndex:([self.longPressedCellIndex section])] removeObject:msg];
    }
    else{
        [self.dateOfMessages removeObjectAtIndex:self.longPressedCellIndex.section];
        [[self.listOfMessages objectAtIndex:([self.longPressedCellIndex section])] removeObject:msg];
        [self.listOfMessages removeObjectAtIndex:[self.longPressedCellIndex section]];
    }
    
    [Database deleteChatMessage:msg];
    
    deactiveTheNotifCallback = TRUE;
    
    [self.tb_messages reloadData];
    
}


-(BOOL)canBecomeFirstResponder
{
    return TRUE;
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (self.isFirstResponder) {
        if (action == @selector(copy:) || action == @selector(deleteMessage:)||action == @selector(forwardMessage:)) {
            return TRUE;
        }
        return NO;
    }
    else{
        //we donot allow the callback if the menu is called from internaltextview
        deactiveTheNotifCallback = TRUE;
        
        if (action == @selector(deleteMessage:)||action == @selector(forwardMessage:)) {
            return FALSE;
        }
        return [self.txtView_Input.internalTextView canPerformAction:action withSender:sender];
    }
}

-(void)willShowEditMenu:(NSNotification*)notif
{
    [WTHelper WTLog:@"show the menu"];
}

-(void)willHideEditMenu:(NSNotification*)notif
{
    [self resignFirstResponder];
    
    if (deactiveTheNotifCallback) {
        deactiveTheNotifCallback = FALSE;
        return;
    }
    
    ChatMessage* msg=(ChatMessage*)[[self.listOfMessages objectAtIndex:([self.longPressedCellIndex section])] objectAtIndex:[self.longPressedCellIndex row]-1];
    
    if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]]) {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]]) {
            UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension: OUTGOINGCELL_BG_FILENAME];
            UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:15 topCapHeight:22];
            TextOutgoingCell* cell = (TextOutgoingCell*)[self.tb_messages cellForRowAtIndexPath:self.longPressedCellIndex];
            [cell.iv_bg setImage:newImage];
        }
        else{
            
            UIImage * preImage = [PublicFunctions imageNamedWithNoPngExtension:INCOMINGCELL_BG_FILENAME];
            UIImage * newImage = [preImage stretchableImageWithLeftCapWidth:20 topCapHeight:16];
            
            TextIncomingCell* cell = (TextIncomingCell*)[self.tb_messages cellForRowAtIndexPath:self.longPressedCellIndex];
            [cell.iv_bg setImage:newImage];
        }
    }
    
}



- (void)reloadDataForBuddyInfoChanged{
    [self.tb_messages reloadData];
}



- (void)viewDidUnload {
    [self setFamilyOperationBar:nil];
    [self setFamilyOperationBarBackground:nil];
    [self setFamilyOperationBarIndicator:nil];
    [super viewDidUnload];
}
@end
