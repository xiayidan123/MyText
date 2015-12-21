//
//  OMOfficialListCell.m
//  dev01
//
//  Created by Starmoon on 15/7/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMOfficialListCell.h"
#import "Buddy.h"

#import "OMHeadImgeView.h"

@interface OMOfficialListCell ()

/** 头像View */
@property (retain, nonatomic) IBOutlet OMHeadImgeView *head_view;

/** 名字label */
@property (retain, nonatomic) IBOutlet UILabel *name_label;

/** 简介label */
@property (retain, nonatomic) IBOutlet UILabel *intro_label;

@end

@implementation OMOfficialListCell

- (void)dealloc {
    [_head_view release];
    [_name_label release];
    [_intro_label release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"OMOfficialListCellID";
    OMOfficialListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OMOfficialListCell" owner:self options:nil] lastObject];
    }
    return cell;
}


#pragma Set and Get


-(void)setBuddy:(Buddy *)buddy{
    [_buddy release],_buddy = nil;
    _buddy = [buddy retain];
    
    self.head_view.buddy = _buddy;
    self.name_label.text = _buddy.nickName;
    self.intro_label.text = _buddy.status;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
