//
//  OMMessageVC.m
//  dev01
//
//  Created by Huan on 15/4/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMMessageVC.h"
#import "Constants.h"
#import "ContactPickerViewController.h"
#import "PublicFunctions.h"
#import "MessageListCell.h"
#import "Database.h"
#import "WTHeader.h"
#import "WTOfficialMSGXMLDelegate.h"
#import "MessageCenter.h"
#import "AppDelegate.h"
#import "SystemMessageViewController.h"
#import "MsgComposerVC.h"
#import "ABPerson.h"
#import "AddressBookManager.h"
#import "TabBarViewController.h"

#import "OMNetWork_MyClass.h"



@interface OMMessageVC ()<UITableViewDelegate,UITableViewDataSource,MessageListCellDelegate,WTOfficialMSGXMLDelegate>
@property (retain, nonatomic) IBOutlet UITableView *chatList_tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSMutableArray *allItems;
@property (retain, nonatomic) NSMutableArray *searchItems;
@property (retain, nonatomic) IBOutlet UIImageView *noChat_ImageView;
@property (retain, nonatomic) IBOutlet UILabel *noChat_Label;
@property (retain, nonatomic) IBOutlet UIView *noChat_View;
@property (retain, nonatomic) SystemMessageViewController *smvc;
@property (retain, nonatomic) MsgComposerVC *msgComposer;
@property (retain, nonatomic) AVAudioPlayer *incomeMsgRingtonePlayer;
@property (assign, nonatomic) BOOL inMessageComposerView;
@property (assign, nonatomic) BOOL isShowing;
@property (assign, nonatomic) BOOL isInSystemMessageView;
@property (copy , nonatomic) NSString *currentSelectedGroupID;
@property (assign, nonatomic) BOOL inEnterGroupChatRoomMode;
@property (assign, nonatomic) BOOL isFromContactList;
@property (assign, nonatomic) BOOL wasKeyboardManagerEnabled;
@property (retain, nonatomic) NSMutableDictionary * buddyInfo_refresh_dic;

@end

@implementation OMMessageVC

- (void)dealloc {
    self.smvc = nil;
    self.allItems = nil;
    self.searchItems = nil;
    [_chatList_tableView release];
    [_searchBar release];
    [_noChat_ImageView release];
    [_noChat_Label release];
    [_noChat_View release];
    self.buddyInfo_refresh_dic = nil;
    
    [super dealloc];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self notification];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self notification];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self notification];
    }
    return self;
}

/**
 *  life cycle
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetBuddy:) name:GET_USER_BY_ID_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetGroupInfo:) name:WT_GET_GROUP_INFO object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRomveBuddy:) name:WT_REMOVE_BUDDY object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKickoutGroup:) name:WT_KICKOUT_GROUP object:nil];
    
    self.inMessageComposerView = FALSE;
    self.isInSystemMessageView = FALSE;
    self.msgComposer = nil;
    self.smvc = nil;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09f green:0.64f blue:0.89f alpha:1.00f];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
    
    [self prepareData];
    

    //    [self uiConfig];
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self fRefetchTableData];
    
    [self uiConfig];
    
    //    [self checkUnreadNumber];
    
    self.isShowing = TRUE;
    
    
    //    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    //    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

- (void)configNavigation{
    self.title = NSLocalizedString(@"Message", nil);
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:NAV_ADD_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(fContactPickUp)];
}

- (void)fContactPickUp{
    ContactPickerViewController *cpvc = [[ContactPickerViewController alloc] init];
    cpvc.isChosenToStartAChat = YES;
    [self.navigationController pushViewController:cpvc animated:YES];
    [cpvc release];
}

- (void)uiConfig{
    if (self.allItems.count) {
        self.chatList_tableView.hidden = NO;
        self.noChat_View.hidden = YES;
        
    }else{
        self.noChat_View.hidden = NO;
        self.chatList_tableView.hidden = YES;
    }
    self.chatList_tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (void)prepareData{
    self.allItems = [Database fetchAllChatMessages:YES];
}

- (void)notification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrationUpdateEvent:)
                                                 name:notif_WTRegistrationUpdate
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatMessageByNotif:)
                                                 name:notif_WTChatMessageReceived
                                               object:nil];
    
    //    [OMNotificationCenter addObserver:self
    //                             selector:@selector(didGetSchoolMember:)
    //                                 name:WT_GET_SCHOOL_MEMBERS
    //                               object:nil];
}


//- (void)didGetSchoolMember:(NSNotification *)notif{
//    [self fRefetchTableData];
//}

#pragma mark - tabelView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        rows = self.searchItems.count;
    }else{
        rows =  self.allItems.count;
    }
    return rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListCell *cell = [MessageListCell cellWithTableView:tableView];
    cell.delegate = self;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        cell.msg = self.searchItems[indexPath.row];
    }else{
        cell.msg = self.allItems[indexPath.row];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.chatList_tableView isEditing]) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        ChatMessage* msg;
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            msg	=(ChatMessage*) [self.searchItems objectAtIndex:indexPath.row];
        }
        else
        {
            msg	=(ChatMessage*) [self.allItems objectAtIndex:indexPath.row];
        }
        
        if ([msg.chatUserName isEqualToString:@"10000"]) {
            self.smvc = [[SystemMessageViewController alloc] init];
            [self.navigationController pushViewController:self.smvc animated:TRUE];
            [self.smvc release];
            self.isInSystemMessageView = TRUE;
            
            return;
        }
        
        if (msg.isGroupChatMessage) {
            GroupChatRoom* room = [Database getGroupChatRoomByGroupid:msg.chatUserName];
            if (room == nil) {
                self.currentSelectedGroupID = msg.chatUserName;
                self.inEnterGroupChatRoomMode = TRUE;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Database deleteChatMessageWithUser:((ChatMessage *)self.allItems[indexPath.row]).chatUserName];
        [self.allItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %zi", editingStyle);
    }
}





- (void)filterContentForSearchText:(NSString *)searchText{
    if (self.searchItems == nil) {
        self.searchItems = [[[NSMutableArray alloc] init] autorelease];
    }
    else
        [self.searchItems removeAllObjects];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)",searchText];
    
    for (ChatMessage* msg in self.allItems) {
        if (msg.isGroupChatMessage) {
            GroupChatRoom* room = [Database getGroupChatRoomByGroupid:msg.chatUserName];
            if ([predicate evaluateWithObject:room.groupNameOriginal]) {
                [self.searchItems addObject:msg];
                continue;
            }
            
            
            NSArray* buddys;
            buddys = [Database fetchAllBuddysInGroupChatRoom:room.groupID];
            
            for (Buddy* buddy in buddys) {
                if ([predicate evaluateWithObject:buddy.nickName]) {
                    [self.searchItems addObject:msg];
                    break;
                }
            }
        }
        else{
            Buddy* buddy = [Database buddyWithUserID:msg.chatUserName];
            if ([predicate evaluateWithObject:buddy.nickName]) {
                [self.searchItems addObject:msg];
                continue;
            }
        }
        
    }
    
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
    
    [self.navigationController pushViewController:self.msgComposer animated:!self.isFromContactList];
}

#pragma mark  add by liuhuan

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
    [self.navigationController pushViewController:self.msgComposer animated:!self.isFromContactList];
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
    [self.msgComposer getDataFromDAView:(DAViewController *)viewController];
    [self.navigationController pushViewController:self.msgComposer animated:YES];  // temp disabled.
    
}
- (void)fComposeWowTalkMsgToUser:(Buddy*)buddy withFirstChat:(BOOL)isFirstChat WithNoPushMessageContent:(NSString *)messageContent{
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
    [self.navigationController pushViewController:self.msgComposer animated:!self.isFromContactList];
    
}





#pragma mark - MessageListCellDelegate

- (void)messageTableViewReloadData{
    [self.chatList_tableView reloadData];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    return YES;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    //    isSearchBarShown = TRUE;
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
    [self.chatList_tableView reloadData];
    //    isSearchBarShown = FALSE;
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
}

-(void)getChatMessageByNotif:(NSNotification *)notif{
    if (self.allItems == nil) {
        self.allItems = [[[NSMutableArray alloc] init] autorelease];
    }
    
    ChatMessage* msg = (ChatMessage *)[notif.userInfo objectForKey: @"data"];
    
    if(msg==nil)  return;
    

    // 1. 确定刷新信息和头像数组中间有新消息发布者
    NSString *uid = msg.chatUserName;
    NSString *last_refresh_time = self.buddyInfo_refresh_dic[uid];
    NSTimeInterval now_time = [[NSDate date] timeIntervalSince1970];
    if (now_time - [last_refresh_time doubleValue] > 60){
        // 2. 调用get buddy info 接口获取用户最新的数据
        [OMNetWork_MyClass getSchoolInfoWithUID:uid withCallback:@selector(didGetSchoolInfo:) withObserver:self];
    }
    
    
    
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

-(NSMutableDictionary *)buddyInfo_refresh_dic{
    if (_buddyInfo_refresh_dic== nil){
        _buddyInfo_refresh_dic = [[NSMutableDictionary alloc]init];
    }
    return _buddyInfo_refresh_dic;
}

-(void)getChatMessage:(ChatMessage*)newmsg
{
    if (self.allItems == nil) {
        self.allItems = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if(newmsg==nil)  return;
    
    NSInteger oldKey = newmsg.primaryKey;
    
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
            
            //            [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum]; 刷新tabbar 未读数
            
            
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
        for (int i=0;i<[self.allItems count];i++){
            ChatMessage* tmpMsg =[self.allItems objectAtIndex:i];
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
                AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
                appDelegate.unread_message_count += 1;
                int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
                
                [defaults synchronize];
                //                [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC badgeValue:badgeValue withIndex:0];
                //                [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];  刷新tabbar 未读数
            }
            
        }
        
        if (needShowThisMessage) {
            if (found&&index > -1) {
                [self.allItems removeObjectAtIndex:index];
            }
            
            [self.allItems insertObject:msg atIndex:0];
            
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
            [self.chatList_tableView reloadData];
            
            
            [self uiConfig];
            
        }
    }
}


#pragma mark -
#pragma mark Table Data.
NSComparisonResult fSortChatMsgByDateDESC(ChatMessage* msg1, ChatMessage* msg2, void* context)
{
    return [msg2.sentDate compare:msg1.sentDate];
}

-(void)fRefetchTableData
{
    if (self.allItems){
        [self.allItems removeAllObjects];
    }
    
    self.allItems = [Database fetchAllChatMessages:YES];   // Get all the messages.
    
    [self.allItems sortUsingFunction:fSortChatMsgByDateDESC context:nil];
    
    for (int i = 0; i< [self.allItems count]; i ++){
        
        ChatMessage* msg = [self.allItems objectAtIndex:i];
        if (msg.isGroupChatMessage) {
            GroupChatRoom* room = [Database getGroupChatRoomByGroupid:msg.chatUserName];
            
            //if the group is invisible, we don't show its message until someone sends a message to the group.
            if (room.isInvisibile) {
                [self.allItems removeObject:msg];
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
    [self.chatList_tableView reloadData];
}


#pragma mark -
#pragma mark notification callback.
- (void)didKickoutGroup:(NSNotification *)notif{
    [self fRefetchTableData];
}
- (void)didRomveBuddy:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == 0) {
        [self fRefetchTableData];
    }
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
        [self.chatList_tableView reloadData];
    }
}

-(void)didGetGroupMembers:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        if (self.inEnterGroupChatRoomMode) {
            self.inEnterGroupChatRoomMode = FALSE;
            NSMutableArray* buddys = [Database fetchAllBuddysInGroupChatRoom:self.currentSelectedGroupID];
            [self createGroupChatRoom:buddys withGroupID:self.currentSelectedGroupID];
        }
        else
            [self.chatList_tableView reloadData];
    }
}


-(void)didGetSchoolInfo:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self fRefetchTableData];
    }
}



@end
