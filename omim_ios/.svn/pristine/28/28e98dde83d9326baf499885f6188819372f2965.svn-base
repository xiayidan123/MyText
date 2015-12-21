//
//  ActivityApplyMembersListCell.m
//  dev01
//
//  Created by Starmoon on 15/7/13.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ActivityApplyMembersListCell.h"

#import "EventApplyMemberModel.h"


@interface ActivityApplyMembersListCell ()

@property (retain, nonatomic) IBOutlet UILabel *name_label;
@property (retain, nonatomic) IBOutlet UILabel *telephone_label;

@property (retain, nonatomic) IBOutlet UILabel *name_content_label;
@property (retain, nonatomic) IBOutlet UILabel *telephone_content_label;

@end

@implementation ActivityApplyMembersListCell

-(void)dealloc{
    self.member = nil;
    [_name_label release];
    [_telephone_label release];
    [_name_content_label release];
    [_telephone_content_label release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *cellID = @"ActivityApplyMembersListCellID";
    ActivityApplyMembersListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityApplyMembersListCell" owner:self options:nil] lastObject];
    }
    return cell;
}


-(void)setMember:(EventApplyMemberModel *)member{
//    [_member release];_member = nil;
//    _member = [member retain];
    
    if (member != _member) {
        _member = member;
    }
    
    self.name_content_label.text = member.real_name;
    self.telephone_content_label.text = member.telephone_number;
}


@end
