//
//  SetUserInfoCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SetUserInfoCell.h"
#import "OMHeadImgeView.h"

#import "SetCellFrameModel.h"

#import "Buddy.h"

#import "Database.h"
#import "WTUserDefaults.h"
#import "WTHeader.h"
#import "AvatarHelper.h"
#import "WowTalkWebServerIF.h"


@interface SetUserInfoCell ()

@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;

@property (retain, nonatomic) IBOutlet UILabel *name_label;

@property (retain, nonatomic) Buddy *user;


@end

@implementation SetUserInfoCell

- (void)dealloc {
    [_user release];
    [_frameModel release];
    [_headImageView release];
    [_name_label release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *SetUserInfoCellID = @"SetUserInfoCellID";
    SetUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:SetUserInfoCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetUserInfoCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)awakeFromNib{
    self.headImageView.headImageCornerRadius = 6;
}


-(void)setFrameModel:(SetCellFrameModel *)frameModel{
    [_frameModel release],_frameModel = nil;
    _frameModel = [frameModel retain];
    
    if (!self.user){
        Buddy *user = [Database buddyWithUserID:[WTUserDefaults getUid]];
        self.user = user;
    }
    self.name_label.text = frameModel.title;
    
    [self loadHeadImageWithNetWork:YES];
}

- (void)loadHeadImageWithNetWork:(BOOL)needNetWorking{
    NSData *data = [AvatarHelper getThumbnailForUser:self.user.userID];
    self.headImageView.buddy = self.user;
    if (data){
        self.headImageView.headImage = [UIImage imageWithData:data];
    }else{
        self.headImageView.headImage = [UIImage imageNamed:@"avatar_84"];
        if (needNetWorking){
           [WowTalkWebServerIF getThumbnailForUserID:self.user.userID withCallback:@selector(didGetThumbnail:) withObserver:self];
        }
    }
}

-(void)didGetThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self loadHeadImageWithNetWork:NO];
    }
}




@end
