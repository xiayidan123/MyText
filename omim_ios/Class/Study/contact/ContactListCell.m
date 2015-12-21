//
//  ContactListCell.m
//  dev01
//
//  Created by 杨彬 on 14-12-16.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ContactListCell.h"
#import "WowTalkWebServerIF.h"
#import "Database.h"
#import "NSFileManager+extension.h"
#import "Buddy.h"

@implementation ContactListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setPerson:(PersonModel *)person{
    _person = [person retain];
    _lab_name.text = _person.alias;
    Buddy *buddy = [[Buddy alloc]initWithUID:nil andPhoneNumber:nil andNickname:nil andStatus:nil andDeviceNumber:nil andAppVer:nil andUserType:_person.user_type andBuddyFlag:nil andIsBlocked:nil andSex:nil andPhotoUploadTimeStamp:nil andWowTalkID:nil andLastLongitude:nil andLastLatitude:nil andLastLoginTimestamp:nil withAddFriendRule:nil andAlias:nil];
    _imageView_head.buddy = buddy;
    [buddy release];
    
    NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@",person.uid] WithSubFolder:@"avatarthumb"]];
    BOOL isDirectory;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    BOOL alreadyExist = NO;
    if (exist && !isDirectory){
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
        _imageView_head.headImage = image;
        [image release];
        alreadyExist = YES;
    }else{
        UIImage *image = [UIImage imageNamed:@"avatar_84.png"];
        _imageView_head.headImage = image;
    }
    if ([Database hasUpdataHeadWithSchoolMemberID:person] && !alreadyExist){//并且本地的没有
            [WowTalkWebServerIF getSchoolMemberThumbnailWithUID:person.uid withCallback:@selector(didGetSchoolMemberThumbnail:) withObserver:nil];
    }
}




- (void)dealloc {
    [_person release];
    [_lab_name release];
    [_lab_signature release];
    [_imageView_head release];
    [super dealloc];
}
@end
