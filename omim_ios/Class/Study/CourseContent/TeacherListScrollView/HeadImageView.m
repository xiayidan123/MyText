//
//  HeadImageView.m
//  dev01
//
//  Created by 杨彬 on 14-12-27.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "HeadImageView.h"
#import "NSFileManager+extension.h"
#import "WowTalkWebServerIF.h"
#import "OMHeadImgeView.h"



@implementation HeadImageView{
    OMHeadImgeView *_headImageView;
    UILabel *_lab_name;
    
}

-(void)dealloc{
    [_teacherModel release],_teacherModel = nil;
    [_headImageView release],_headImageView = nil;
    [_lab_name release],_lab_name = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _headImageView = [[OMHeadImgeView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width - 30, frame.size.width - 30 )];
        _headImageView.headImage = [UIImage imageNamed:@"avatar_140"];
        _headImageView.userInteractionEnabled = YES;
        [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
        [self addSubview:_headImageView];
        
        _lab_name = [[UILabel alloc]initWithFrame:CGRectMake(10, _headImageView.bounds.size.height + _headImageView.frame.origin.y + 5,_headImageView.bounds.size.width , frame.size.height - _headImageView.frame.origin.y - _headImageView.frame.size.height - 5)];
        _lab_name.textAlignment = NSTextAlignmentCenter;
        _lab_name.font = [UIFont systemFontOfSize:12];
        _lab_name.userInteractionEnabled = YES;
        [_lab_name addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
        [self addSubview:_lab_name];
        
    }
    return self;
}



-(void)setTeacherModel:(PersonModel *)teacherModel{
    _teacherModel = [teacherModel retain];
    _lab_name.text = _teacherModel.alias;
    
    Buddy *buddy = [[Buddy alloc]initWithUID:nil andPhoneNumber:nil andNickname:nil andStatus:nil andDeviceNumber:nil andAppVer:nil andUserType:teacherModel.user_type andBuddyFlag:nil andIsBlocked:nil andSex:nil andPhotoUploadTimeStamp:nil andWowTalkID:nil andLastLongitude:nil andLastLatitude:nil andLastLoginTimestamp:nil withAddFriendRule:nil andAlias:nil ];
    _headImageView.buddy = buddy;
    [buddy release];
    
    NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@",_teacherModel.uid] WithSubFolder:@"avatarthumb"]];
    BOOL isDirectory;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (exist && !isDirectory){
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
        _headImageView.headImage = image;
        [image release];
    }else{
        [WowTalkWebServerIF getSchoolMemberThumbnailWithUID:[_teacherModel uid] withCallback:@selector(didGetSchoolMemberThumbnail:) withObserver:nil];
    }
}



-(void)click{
    if ([_delegate respondsToSelector:@selector(clickHeadImageWith:)]){
        [_delegate clickHeadImageWith:_teacherModel];
    }
}



@end
