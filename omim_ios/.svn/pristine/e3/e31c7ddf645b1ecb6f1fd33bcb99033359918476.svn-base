//
//  BuddyDetailCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "BuddyDetailCell.h"
#import "OMHeadImgeView.h"

#import "AvatarHelper.h"
#import "WTHeader.h"
#import "WowTalkWebServerIF.h"
#import "Constants.h"
#import "PublicFunctions.h"

@interface BuddyDetailCell ()

@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;

@property (retain, nonatomic) IBOutlet UILabel *name_label;

//@property (retain, nonatomic) UIImage *head_image;


@end



@implementation BuddyDetailCell

- (void)dealloc {
//    [_head_image release];
    [_buddy release];
    [_headImageView release];
    [_name_label release];
    [super dealloc];
}



+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"BuddyDetailCellID";
    BuddyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BuddyDetailCell" owner:self options:nil] lastObject];
    }
    return cell;
}
/*
 *
 *  通过ChatMessage获得Group和Buddy
 */
- (void)setChatMessage:(ChatMessage *)chatMessage{
    if (_chatMessage != chatMessage) {
        [_chatMessage release];
        _chatMessage = [chatMessage retain];
    }
    if (chatMessage.isGroupChatMessage) {
        [WowTalkWebServerIF groupChat_GetGroupDetail:chatMessage.chatUserName withCallback:@selector(didGetGroupInfo:) withObserver:self];
        NSData *data = [AvatarHelper getThumbnailForGroup:chatMessage.chatUserName];
        if (data) {
            self.headImageView.headImage = [UIImage imageWithData:data];
            
        }else{
            self.headImageView.headImage = [UIImage imageNamed:DEFAULT_GROUP_AVATAR];
        }
        self.name_label.text = [PublicFunctions compositeNameOfMessage:chatMessage];
    }
    else{
        Buddy *buddy = [Database buddyWithUserID:chatMessage.chatUserName];
        self.headImageView.buddy = buddy;
        self.name_label.text = buddy.showName;
    }
}

- (void)didGetGroupInfo:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString* groupid = [[notif userInfo] valueForKey:@"group_id"];
        if (groupid) {
            [WowTalkWebServerIF groupChat_GetGroupMembers:groupid withCallback:@selector(didGetGroupMembers:) withObserver:self];
        }
    }
}
- (void)didGetGroupMembers:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSMutableArray* buddys = [Database fetchAllBuddysInGroupChatRoom:self.chatMessage.chatUserName];
        if ([_delegate respondsToSelector:@selector(CallBackBuddys:)]) {
            [_delegate CallBackBuddys:buddys];
        }
    }
}

- (void)setBuddyOrGroup:(id *)buddyOrGroup{
    
}

- (void)setUserGroup:(UserGroup *)userGroup{
    if (_userGroup != userGroup) {
        [_userGroup release];
        _userGroup = [userGroup retain];
    }
    NSData *data = [AvatarHelper getThumbnailForGroup:self.userGroup.groupID];
    if (data) {
        self.headImageView.headImage = [UIImage imageWithData:data];
    }else{
        self.headImageView.headImage = [UIImage imageNamed:DEFAULT_GROUP_AVATAR];
    }
    self.name_label.text = _userGroup.groupNameLocal;
}
-(void)setBuddy:(Buddy *)buddy{
    [_buddy release],_buddy = nil;
    _buddy = [buddy retain];
    
    if (_buddy != buddy) {
        [_buddy release];
        _buddy = [buddy retain];
    }
 
    if (_buddy.alias != nil) {
        self.name_label.text = _buddy.alias;
    }
    else
    {
        self.name_label.text = _buddy.nickName;
    }
    self.headImageView.buddy = _buddy;

}


#pragma mark - NetWork CallBack


- (void)awakeFromNib {
    self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
