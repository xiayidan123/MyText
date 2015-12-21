//
//  GroupMember.m
//  omim
//
//  Created by coca on 2013/04/23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "GroupMember.h"

@implementation GroupMember

@synthesize isCreator = _isCreator;
@synthesize isManager = _isManager;

+(NSMutableArray*)normalGroupMembersFromBuddys:(NSArray*)buddys
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    for (Buddy* buddy in buddys) {
        GroupMember* member = [[GroupMember alloc] initWithUID:buddy.userID andPhoneNumber:buddy.phoneNumber andNickname:buddy.nickName andStatus:buddy.status andDeviceNumber:buddy.deviceNumber andAppVer:buddy.appVer andUserType:[NSString stringWithFormat:@"%zi",buddy.userType] andBuddyFlag:buddy.buddy_flag andIsBlocked:buddy.isBlocked andSex:[NSString stringWithFormat:@"%zi",buddy.sexFlag] andPhotoUploadTimeStamp:[NSString stringWithFormat:@"%zi", buddy.photoUploadedTimeStamp] andWowTalkID:buddy.wowtalkID andLastLongitude:[NSString stringWithFormat:@"%f", buddy.lastLongitude] andLastLatitude: [NSString stringWithFormat:@"%f", buddy.lastLatitude] andLastLoginTimestamp:[NSString stringWithFormat:@"%zi",buddy.lastLoginTimestamp] withAddFriendRule:buddy.addFriendRule andAlias:@""];
        member.isCreator = FALSE;
        member.isManager = FALSE;
        [arr addObject:member];
        [member release];
    }
    
    return [arr autorelease];
}

-(void)dealloc
{
    [super dealloc];
}
@end
