//
//  MessageListCell.m
//  dev01
//
//  Created by Huan on 15/4/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MessageListCell.h"
#import "OMHeadImgeView.h"
#import "PublicFunctions.h"
#import "ChatMessage.h"
#import "SBJsonParser.h"
#import "Constants.h"
#import "NSDate+FromCurrentTime.h"
#import "AvatarHelper.h"
#import "Database.h"
#import "WowTalkWebServerIF.h"
#import "GroupChatRoom.h"
#import "UserGroup.h"
#import "NSFileManager+extension.h"
#import "WTError.h"
#import "KYCuteView.h"
@interface MessageListCell()
@property (retain, nonatomic) IBOutlet UILabel *name_label;
@property (retain, nonatomic) IBOutlet UILabel *content_label;
@property (retain, nonatomic) IBOutlet UILabel *time_label;

@property (assign, nonatomic) IBOutlet OMHeadImgeView *head_imageView;
@property (assign, nonatomic) BOOL inEnterGroupChatRoomMode;

@property (retain, nonatomic) IBOutlet KYCuteView *unReadMsgCount_View;

@end

@implementation MessageListCell

- (void)dealloc {
    [_name_label release];
    [_content_label release];
    [_time_label release];
//    self.head_imageView = nil;
    [_unReadMsgCount_View release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"MessageListCellID";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setMsg:(ChatMessage *)msg{
    [_msg release],_msg = nil;
    _msg = [msg retain];
    
    
    
    self.name_label.text = [PublicFunctions compositeNameOfMessage:msg];
    if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]])
    {
        self.content_label.text = msg.messageContent;
    }
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            self.content_label.text = NSLocalizedString(@"A voice message was sent", nil);
        }
        else
        {
            self.content_label.text = NSLocalizedString(@"A voice message was received", nil);
        }
        
    } // photo
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            self.content_label.text = NSLocalizedString(@"A photo was sent", nil);
        }
        else
        {
            self.content_label.text = NSLocalizedString(@"A photo was received", nil);
        }
        
    } // video
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            self.content_label.text = NSLocalizedString(@"A video clip was sent", nil);
        }
        else
        {
            self.content_label.text = NSLocalizedString(@"A video clip was received", nil);
        }
        
    }
    // location
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_LOCATION]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            self.content_label.text = NSLocalizedString(@"A location was sent", nil);
        }
        else
        {
            self.content_label.text = NSLocalizedString(@"A location was received", nil);
        }
        
    } // stamp
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_STAMP]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            self.content_label.text = NSLocalizedString(@"A stamp was sent", nil);
        }
        else
        {
            self.content_label.text = NSLocalizedString(@"A stamp was received", nil);
        }
        
    }
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_CALL_LOG]])
    {
        SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
        NSDictionary* dic = (NSDictionary*)[jp fragmentWithString: msg.messageContent];
        if ([[dic valueForKey:CALL_DIRECTION] isEqualToString:@"out"]) {
            self.content_label.text = NSLocalizedString(@"You just called others", nil);
        }
        else
        {
            if ([[dic valueForKey:CALL_RESULT_TYPE] isEqualToString:@"1"]) {
                self.content_label.text = NSLocalizedString(@"You had a missing call", nil);
            }
            else {
                self.content_label.text = NSLocalizedString(@"You had an incoming call", nil);
            }
        }
    }
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM]])
    {
        self.content_label.text = msg.messageContent;
        
    }
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM]])
    {
        self.content_label.text = msg.messageContent;
        
    }
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]])
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            self.content_label.text = NSLocalizedString(@"A pic-voice message was sent", nil);
        }
        else
        {
            self.content_label.text = NSLocalizedString(@"A pic-voice message was received", nil);
        }
        
    }
    // add more types.
    else
    {
        if ([msg.ioType isEqualToString:[ChatMessage IOTYPE_OUTPUT]])
        {
            self.content_label.text = NSLocalizedString(@"A multimedia message was sent", nil);
        }
        else
        {
            self.content_label.text = NSLocalizedString(@"A multimedia message was received", nil);
        }
    }
    
    self.time_label.text = NSLocalizedString([NSDate TimeFromTodayInMessageListVC:msg.sentDate], nil);
    
    NSInteger unReadCount = [Database countUnreadChatMessagesWithUser:msg.chatUserName];
    if (unReadCount == 0) {
        self.unReadMsgCount_View.bubbleLabel.text = [NSString stringWithFormat:@"%d",0];
        self.unReadMsgCount_View.frontView.hidden = YES;
    }
    else if (unReadCount > 0)
    {
        self.unReadMsgCount_View.frontView.hidden = NO;
        self.unReadMsgCount_View.msg = msg;
        self.unReadMsgCount_View.bubbleLabel.text = [NSString stringWithFormat:@"%ld",(long)unReadCount];
        
    }
    
    if (msg.isGroupChatMessage) {
        
        GroupChatRoom *room = [Database getGroupChatRoomByGroupid:msg.chatUserName];
        if (!room) {

            self.head_imageView.headImage = [UIImage imageNamed:@"colored_icon_avatar_color"];
            [WowTalkWebServerIF groupChat_GetGroupDetail:msg.chatUserName withCallback:@selector(didGetGroupInfo:) withObserver:self];
        }
        else{
            if (room.isTemporaryGroup) {
        
                self.head_imageView.headImage = [UIImage imageNamed:@"colored_icon_avatar_color@2x.png"];

                //图片上加载这个控件会有重复头像问题，等待解决
//                avatars.tag = 100;
//                [self.head_imageView addSubview:avatars];
                
            }
            else{
                NSData* data = [AvatarHelper getThumbnailForGroup:msg.chatUserName];
                if(data){
                    self.head_imageView.headImage = [[[UIImage alloc] initWithData:data] autorelease];
                }
                else{
                    self.head_imageView.headImage = [UIImage imageNamed:DEFAULT_GROUP_AVATAR];
                }
                UserGroup* group = [Database getFixedGroupByID:msg.chatUserName];
                if (group.needToDownloadThumbnail) {
                    [WowTalkWebServerIF getGroupAvatarThumbnail:msg.chatUserName withCallback:@selector(didGetGroupThumbnail:) withObserver:self];
                }
            }
        }
    }
    else{
        if ([msg.chatUserName isEqualToString:@"10000"]) {
            self.head_imageView.headImage = [UIImage imageNamed:@"chat_notification_icon.png"];
        }
        else{

            
            Buddy* buddy = [Database buddyWithUserID:msg.chatUserName];
            self.head_imageView.buddy = buddy;
        }
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
        //       让tableView去刷新
        if ([self.delegate respondsToSelector:@selector(messageTableViewReloadData)]) {
            [self.delegate messageTableViewReloadData];
        }
        
    }
}


-(void)didGetGroupMembers:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if (self.inEnterGroupChatRoomMode) {
            self.inEnterGroupChatRoomMode = FALSE;
            //            NSMutableArray* buddys = [Database fetchAllBuddysInGroupChatRoom:currentSelectedGroupID];
            //            [self createGroupChatRoom:buddys withGroupID:currentSelectedGroupID];
        }
        else{
            if ([self.delegate respondsToSelector:@selector(messageTableViewReloadData)]) {
                [self.delegate messageTableViewReloadData];
            }
        }
    }
}

-(void)didGetGroupThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
       // [self.tb_messages reloadData]; 让tableView去刷新
        NSData* data = [AvatarHelper getThumbnailForGroup:self.msg.chatUserName];
        UIImage *group_image = [UIImage imageWithData:data];
        self.head_imageView.headImage = group_image;
    }
    
}


-(KYCuteView *)unReadMsgCount_View{
    if (_unReadMsgCount_View == nil){
        _unReadMsgCount_View = [[KYCuteView alloc] initWithPoint:CGPointMake(self.contentView.frame.size.width - 25, self.contentView.frame.size.height - 20) superView:self.contentView];;
        self.unReadMsgCount_View.viscosity  = 15;
        self.unReadMsgCount_View.bubbleWidth = 17;
        self.unReadMsgCount_View.bubbleColor = [UIColor redColor];
        [self.unReadMsgCount_View setUp];
        [self.unReadMsgCount_View addGesture];
    }
    return _unReadMsgCount_View;
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
