//
//  SetUserInforHeadCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SetUserInforHeadCell.h"
#import "OMHeadImgeView.h"
#import "SetCellFrameModel.h"

#import "Database.h"
#import "WTUserDefaults.h"
#import "Buddy.h"
#import "AvatarHelper.h"
#import "WowTalkWebServerIF.h"
#import "Constants.h"
#import "WTHeader.h"

@interface SetUserInforHeadCell ()
@property (retain, nonatomic) IBOutlet UILabel *name_leabel;
@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImage_view;
@property (retain, nonatomic) Buddy *user;

@end


@implementation SetUserInforHeadCell

- (void)dealloc {
    [_frameModel release];
    [_name_leabel release];
    [_headImage_view release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *SetUserInforHeadCellID = @"SetUserInforHeadCellID";
    SetUserInforHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:SetUserInforHeadCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetUserInforHeadCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)awakeFromNib{
    self.headImage_view.headImageCornerRadius = 6;
}


-(void)setFrameModel:(SetCellFrameModel *)frameModel{
    [_frameModel release],_frameModel = nil;
    _frameModel = [frameModel retain];
    
    if (!self.user){
        Buddy *user = [Database buddyWithUserID:[WTUserDefaults getUid]];
        self.user = user;
    }
    self.name_leabel.text = frameModel.title;
    
    [self loadHeadImageWithNetWork:YES];
}

- (void)loadHeadImageWithNetWork:(BOOL)needNetWorking{
    NSData *data = [AvatarHelper getThumbnailForUser:self.user.userID];
    self.headImage_view.buddy = self.user;
    if (data){
        self.headImage_view.headImage = [UIImage imageWithData:data];
    }else{
        self.headImage_view.headImage = [UIImage imageNamed:@"avatar_84"];
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
