//
//  GroupAdminCell.m
//  dev01
//
//  Created by 杨彬 on 15/2/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "GroupAdminCell.h"
#import "OMHeadImgeView.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"

@interface GroupAdminCell ()
@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;
@property (retain, nonatomic) IBOutlet UILabel *name_label;
@property (retain, nonatomic) IBOutlet UILabel *signature_label;
@property (retain, nonatomic) IBOutlet UIButton *admin_button;
- (IBAction)setmanageAction:(id)sender;

@end


@implementation GroupAdminCell

- (void)dealloc {
    [_headImageView release],_headImageView = nil;
    [_name_label release],_name_label = nil;
    [_signature_label release],_signature_label = nil;
    [_admin_button release],_admin_button = nil;
    [_buddy release],_buddy = nil;
    [super dealloc];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self UiConfig];
    }
    return self;
}


-(void)layoutSubviews{
    [self UiConfig];
}

- (void)UiConfig{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_admin_button.selected){
        _admin_button.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
    }else{
         _admin_button.backgroundColor = [UIColor colorWithRed:0.11 green:0.68 blue:0.98 alpha:1];
    }
    _admin_button.layer.cornerRadius = 3;
    _admin_button.layer.masksToBounds = YES;
    
    [_admin_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_admin_button setTitleColor:[UIColor colorWithRed:140.0/255 green:140.0/255 blue:140.0/255 alpha:1] forState:UIControlStateSelected];
    [_admin_button setTitle:NSLocalizedString(@"Set up as adminstrator",nil) forState:UIControlStateNormal];
    [_admin_button setTitle:NSLocalizedString(@"cancel adminstrator",nil) forState:UIControlStateSelected];

}


- (void)setBuddy:(GroupMember *)buddy{
    [_buddy release],_buddy = nil;
    _buddy = [buddy retain];
    _name_label.text = _buddy.nickName;
    _name_label.preferredMaxLayoutWidth = 200;
    _signature_label.text = _buddy.status;
    _signature_label.preferredMaxLayoutWidth = 100;
    
    _admin_button.selected = (_buddy.isCreator || _buddy.isManager) ? YES  : NO;
    
    
    NSData *data = [AvatarHelper getThumbnailForUser:self.buddy.userID];
    self.headImageView.buddy = _buddy;
    if (data){
        self.headImageView.headImage = [UIImage imageWithData:data];
    }else{
        if (self.buddy.userType == 0) {
            self.headImageView.headImage = [UIImage imageNamed:DEFAULT_OFFICIAL_AVARAR];
        } else {
            self.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR];
        }
    }
    if (self.buddy.needToDownloadThumbnail)
    {
        [WowTalkWebServerIF getThumbnailForUserID:self.buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
    }
    
}

- (void)getBuddyThumbnail:(NSNotification *)notification
{
    NSData *data = [AvatarHelper getThumbnailForUser:self.buddy.userID];
    self.headImageView.buddy = _buddy;
    if (data)
        self.headImageView.headImage = [UIImage imageWithData:data];
}


- (IBAction)setmanageAction:(id)sender {
    if (_admin_button.enabled == NO) return;
    
    if (_admin_button.selected ){// 当前是管理员
        [_delegate removeManageWithBuddyID:_buddy];
    }else{// 当前不是管理员
        [_delegate setManageWithBuddyID:_buddy];
    }
    _admin_button.selected = !_admin_button.selected;
}




@end
