//
//  OMContactListCell.m
//  dev01
//
//  Created by Starmoon on 15/7/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMContactListCell.h"

#import "OMHeadImgeView.h"

#import "Buddy.h"
#import "UserGroup.h"



@interface OMContactListCell ()

@property (retain, nonatomic) IBOutlet OMHeadImgeView *head_view;

@property (retain, nonatomic) IBOutlet UILabel *name_label;

@property (retain, nonatomic) IBOutlet UILabel *intro_lebel;

@end

@implementation OMContactListCell

- (void)dealloc {
    self.buddy = nil;
    self.group = nil;
    [_head_view release];
    [_name_label release];
    [_intro_lebel release];
    [super dealloc];
}




#pragma mark - Set and Get

-(void)setBuddy:(Buddy *)buddy{
    [_buddy release],_buddy = nil;
    [_group release],_group = nil;
    _buddy = [buddy retain];
    
    self.head_view.buddy = buddy;
    
    self.name_label.text = buddy.nickName;
    self.intro_lebel.text = buddy.status;
}

-(void)setGroup:(UserGroup *)group{
    [_group release],_group = nil;
    [_buddy release],_buddy = nil;
    _group = [group retain];
    
    self.head_view.group = _group;
    self.name_label.text = _group.groupNameOriginal;
    self.intro_lebel.text = _group.introduction;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"OMContactListCellID";
    OMContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OMContactListCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
