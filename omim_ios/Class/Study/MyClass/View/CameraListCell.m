//
//  CameraListCell.m
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "CameraListCell.h"
#import "ClassRoomCamera.h"

@interface CameraListCell ()

@property (retain, nonatomic) IBOutlet UILabel *position;
@property (retain, nonatomic) IBOutlet UISwitch *isOn;

@end


@implementation CameraListCell

- (void)dealloc {
    [_classRoomCamera release];
    
    [_position release];
    [_isOn release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"CameraListCellid";
    CameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CameraListCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


-(void)setClassRoomCamera:(ClassRoomCamera *)classRoomCamera{
    if (![classRoomCamera isKindOfClass:[ClassRoomCamera class]]){
        self.textLabel.text = NSLocalizedString(@"Data error",nil);
        
        return;
    }
    
    [_classRoomCamera release],_classRoomCamera = nil;
    _classRoomCamera = [classRoomCamera retain];
    
    self.position.text = _classRoomCamera.camera_name;
    self.isOn.on = _classRoomCamera.status ;
}

- (void)awakeFromNib {
    [_isOn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchAction:(UISwitch *)isOn_switch{
    self.classRoomCamera.status = isOn_switch.on;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
