//
//  OMBuddyDetailHeadView.m
//  dev01
//
//  Created by Starmoon on 15/7/29.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBuddyDetailHeadView.h"

#import "Buddy.h"

#import "OMHeadImgeView.h"

@interface OMBuddyDetailHeadView ()

@property (retain, nonatomic) IBOutlet OMHeadImgeView *head_view;

@property (retain, nonatomic) IBOutlet UILabel *name_label;
@property (retain, nonatomic) IBOutlet UILabel *user_name_label;
@property (retain, nonatomic) IBOutlet UILabel *nick_name_label;

@end


@implementation OMBuddyDetailHeadView

- (void)dealloc {
    [_head_view release];
    [_name_label release];
    [_user_name_label release];
    [_nick_name_label release];
    self.buddy = nil;
    [super dealloc];
}


+ (instancetype)buddyDetailHeadView{
    return [[[NSBundle mainBundle]loadNibNamed:@"OMBuddyDetailHeadView" owner:self options:nil] lastObject];
}

#pragma mark - Set and Get

-(void)setBuddy:(Buddy *)buddy{
    [_buddy release],_buddy = nil;
    _buddy = [buddy retain];
    
    self.head_view.buddy = _buddy;
    self.name_label.text = _buddy.nickName;
    self.user_name_label.text = [NSString stringWithFormat:@"用户名:%@",_buddy.wowtalkID];
    self.nick_name_label.text = [NSString stringWithFormat:@"昵称:%@",_buddy.nickName];
}


@end
