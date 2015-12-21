//
//  ClassBulletinCell.m
//  dev01
//
//  Created by 杨彬 on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassBulletinCell.h"
#import "OMHeadImgeView.h"
#import "Anonymous_Moment_Frame.h"

#import "AvatarHelper.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"


@interface ClassBulletinCell ()


@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;

@property (retain, nonatomic) IBOutlet UILabel *name_label;

@property (retain, nonatomic) IBOutlet UILabel *time_label;



@end



@implementation ClassBulletinCell

- (void)dealloc {
    self.frame_model = nil;
    [_headImageView release];
    [_name_label release];
    [_time_label release];
    [_text_label release];
    [super dealloc];
}


-(void)setFrame_model:(Anonymous_Moment_Frame *)frame_model{
    [_frame_model release],_frame_model = nil;
    _frame_model = [frame_model retain];
    
    
    self.name_label.text = _frame_model.schoolMember.alias;
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *currentDateStr = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:_frame_model.moment.timestamp]];
    [dateFormat release];
    self.time_label.text = currentDateStr ;
    
    self.text_label.text = _frame_model.moment.text;
    
    NSData *data = [AvatarHelper getThumbnailForUser:_frame_model.schoolMember.userID];
    self.headImageView.buddy = _frame_model.schoolMember;
    if (data){
        self.headImageView.headImage = [UIImage imageWithData:data];
    }
    else
    {
        self.headImageView.headImage = [UIImage imageNamed:@"avatar_84.png"];
        [WowTalkWebServerIF getSchoolMemberThumbnailWithUID:_frame_model.schoolMember.userID withCallback:@selector(didGetSchoolMemberThumbnail:) withObserver:self];
    }
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"ClassBulletinCellID";
    ClassBulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassBulletinCell" owner:self options:nil] lastObject];
    }
    return cell;
}


#pragma mark - NetWork CallBack
- (void)didGetSchoolMemberThumbnail:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        NSString *uid = [[notif userInfo] valueForKey:@"buddy_id"];
//        if ([self.frame_model.schoolMember.userID isEqualToString:uid]){
//            NSData *data = [AvatarHelper getThumbnailForUser:self.frame_model.schoolMember.userID];
//            self.headImageView.headImage = [UIImage imageWithData:data];
//        }
        if ([self.delegate respondsToSelector:@selector(classBulletinCell:withUser_id:)]){
            [self.delegate classBulletinCell:self withUser_id:uid];
        }
    }
}


- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
