//
//  OMHeadImgeView.m
//  dev01
//
//  Created by 杨彬 on 15/1/26.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMHeadImgeView.h"

#import "AvatarHelper.h"
#include "WowTalkWebServerIF.h"
#import "WTHeader.h"
#import "OMNetWork_MyClass_Constant.h"

@interface OMHeadImgeView ()

@property (nonatomic,retain)UIImageView *headImageView;
@property (nonatomic,retain)UIImageView *identityImageView;

@end


@implementation OMHeadImgeView

-(void)dealloc{
    self.group = nil;
    [OMNotificationCenter removeObserver:self];
    [_headImage release],_headImage = nil;
    [_buddy release],_buddy = nil;
    [_headImageView release],_headImageView = nil;
    [_identityImageView release],_identityImageView = nil;
    [super dealloc];
}

+ (instancetype)headImageView{
    return [[[self alloc]init] autorelease];
}



-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.headImageView.frame = self.bounds;
    self.headImageView.layer.cornerRadius = self.bounds.size.width/2;
    
    CGFloat identityImageViewWH = self.bounds.size.width / 3;
    CGFloat identityImageViewX = self.bounds.size.width - identityImageViewWH;
    CGFloat identityImageViewY = self.bounds.size.height - identityImageViewWH;
    
    self.identityImageView.frame = CGRectMake(identityImageViewX, identityImageViewY, identityImageViewWH, identityImageViewWH);
}


-(UIImageView *)headImageView{
    if (_headImageView == nil){
        UIImageView *headImageView = [[UIImageView alloc]init];
        headImageView.layer.masksToBounds = YES;
        headImageView.image = [UIImage imageNamed:@"avatar_84"];
        
        [self addSubview:headImageView];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImageView = headImageView;
        
        [headImageView release];
    }
    return _headImageView;
}

-(UIImageView *)identityImageView{
    if (_identityImageView == nil){
        UIImageView * identityImageView = [[UIImageView alloc]init];
        identityImageView.image = [UIImage imageNamed:@"icon_avatar_teacher"];
        identityImageView.hidden = YES;
        [self addSubview:identityImageView];
        self.identityImageView = identityImageView;
        [identityImageView release];
    }
    return _identityImageView;
}


-(void)setBuddy:(Buddy *)buddy{
    [_buddy release],_buddy = nil;
    [_group release],_group = nil;
    _buddy = [buddy retain];
    
    if (_buddy == nil){
        _identityImageView.hidden = YES;
        self.headImage = nil;
        return;
    }
    
    if (_buddy.userType == 0){
        
    }else if (_buddy.userType == 2){
        _identityImageView.hidden = NO;
    }else{
        _identityImageView.hidden = YES;
    }
    
    NSString *uid = _buddy.userID;
    if (_buddy.userType == 3){
        uid = _buddy.pathOfPhoto;
    }
    
    NSData *data = [AvatarHelper getThumbnailForUser:uid];
    if (_buddy.photoUploadedTimeStamp == -1){// 用户压根没头像
        self.headImage = [UIImage imageNamed:@"avatar_84.png"];
        return;
    }
    if (data) {
        self.headImage = [UIImage imageWithData:data];
    }else {
        self.headImage = [UIImage imageNamed:@"avatar_84.png"];
        
        if (_buddy.userType == 3){
            [WowTalkWebServerIF getSchoolAvatarWithFileName:uid withCallback:@selector(didGetSchoolMemberThumbnail:) withObserver:self];
        }else{
            [WowTalkWebServerIF getSchoolMemberThumbnailWithUID:uid withCallback:@selector(didGetSchoolMemberThumbnail:) withObserver:self];
        }
    }
}



-(void)setGroup:(UserGroup *)group{
    [_group release],_group = nil;
    [_buddy release],_buddy = nil;
    _group = [group retain];
    
    self.identityImageView.hidden = YES;
    
    NSString *group_id = _group.groupID;
    NSData *data = [AvatarHelper getThumbnailForGroup:group_id];
    
    if (data) {
        self.headImage = [UIImage imageWithData:data];
    }else {
        self.headImage = [UIImage imageNamed:@"default_group_avatar_90.png"];
        
        if (_group.needToDownloadThumbnail)
        {
            [WowTalkWebServerIF getGroupAvatarThumbnail:_group.groupID withCallback:@selector(didGetGroupAvatarThumbnail:) withObserver:self];
        }
    }
}


- (void)didGetSchoolMemberThumbnail:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *uid = [[notif userInfo] valueForKey:@"buddy_id"];
        if (self.buddy.userType == 3){
            if ([uid isEqualToString:self.buddy.pathOfPhoto]){
                NSData *data = [AvatarHelper getThumbnailForUser:uid];
                self.headImage = [UIImage imageWithData:data];
            }
        }else{
            if ([uid isEqualToString:self.buddy.userID]){
                NSData *data = [AvatarHelper getThumbnailForUser:uid];
                self.headImage = [UIImage imageWithData:data];
            }
        }
    }
}


- (void)didGetGroupAvatarThumbnail:(NSNotification *)notif{
    NSData *data = [AvatarHelper getThumbnailForGroup:self.group.groupID];
    if (data)
        self.headImage = [UIImage imageWithData:data];
}



-(void)setHeadImage:(UIImage *)headImage{
    [_headImage release],_headImage = nil;
    _headImage = [headImage retain];
    _headImageView.image = _headImage;
}

- (void)setIdentityType:(OMHeadImageViewIdentityType)identityType{
    _identityType = identityType;
    if (_identityType == Teacher_OMHeadImageViewIdentity){
        _identityImageView.hidden = NO;
    }else if (_identityType == Student_OMHeadImageViewIdentity){
        _identityImageView.hidden = YES;
    }
}

-(void)setShapeType:(OMHeadImageViewShapeType)shapeType{
    _shapeType = shapeType;
    if (_shapeType == Circle_OMHeadImageViewType){
        _headImageView.layer.cornerRadius = self.bounds.size.width/2;
    }else if (_shapeType == Square_OMHeadImageViewType){
        _headImageView.layer.cornerRadius = 0;
    }
}


-(void)setHeadImageCornerRadius:(CGFloat)headImageCornerRadius{
    _headImageView.layer.cornerRadius = headImageCornerRadius;
}

@end
