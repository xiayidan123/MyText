//
//  SendToInSchoolCell.m
//  dev01
//
//  Created by Huan on 15/3/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SendToInSchoolCell.h"
#import "Database.h"
#import "WowTalkWebServerIF.h"
#import "Buddy.h"
#import "WTError.h"
#import "ContactListCell.h"
@interface SendToInSchoolCell()<SchoolViewControllerDelegate>
@property (retain, nonatomic) Buddy *buddy;
@property (retain, nonatomic) PersonModel *pensonModel;
@end

@implementation SendToInSchoolCell

- (void)dealloc
{
    self.buddy = nil;
    self.pensonModel = nil;
    [super dealloc];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.schoolVC = [[[SchoolViewController alloc] init] autorelease];
    self.schoolVC.isHideGroupBtn = YES;
    self.schoolVC.view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.schoolVC.view];
    self.schoolVC.delegate = self;
    return self;
}
- (void)addBuddyFromSchoolWithPersonModel:(PersonModel *)person
{
    self.pensonModel = person;
    if ([_sendDelegate respondsToSelector:@selector(getBuddyFromCell:)]) {
        self.buddy = [Database buddyWithUserID:person.uid];
        if (self.buddy) {
            [_sendDelegate getBuddyFromCell:[Database buddyWithUserID:person.uid]];
        }
        else
        {
            [WowTalkWebServerIF getBuddyWithUID:person.uid withCallback:@selector(didGetBuddyWithUID:) withObserver:self];
        }
    }
}

- (void)didGetBuddyWithUID:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.buddy = [Database buddyWithUserID:self.pensonModel.uid];
        [_sendDelegate getBuddyFromCell:self.buddy];
        }
}
- (void)awakeFromNib {
    
}

@end
