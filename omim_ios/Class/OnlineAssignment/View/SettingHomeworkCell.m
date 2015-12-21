//
//  SettingHomeworkCell.m
//  dev01
//
//  Created by Huan on 15/5/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SettingHomeworkCell.h"

@interface SettingHomeworkCell()


@end

@implementation SettingHomeworkCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)setStudents:(NSMutableArray *)students{
    if (students.count == 0) {
        self.state_lbl.text = @"未布置";
    }
}
- (void)dealloc {
    self.students = nil;
    [_settingHomework_lbl release];
    [_state_lbl release];
    [super dealloc];
}
@end
