//
//  CameraForStudentListCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/9.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "CameraForStudentListCell.h"
#import "ClassRoomCamera.h"


@interface CameraForStudentListCell ()
@property (retain, nonatomic) IBOutlet UILabel *title_label;
@property (retain, nonatomic) IBOutlet UIImageView *remind_imageView;

@property (retain, nonatomic) IBOutlet UILabel *switch_label;


@end

@implementation CameraForStudentListCell

- (void)dealloc {
    
    [_classRoomCamera release];
    [_title_label release];
    [_remind_imageView release];
    [_switch_label release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"CameraForStudentListCellid";
    CameraForStudentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CameraForStudentListCell" owner:nil options:nil] lastObject];
        
    }
    return cell;
}

- (void)awakeFromNib {

}


-(void)setClassRoomCamera:(ClassRoomCamera *)classRoomCamera{
    if (![classRoomCamera isKindOfClass:[ClassRoomCamera class]]){
        self.textLabel.text = NSLocalizedString(@"Data error",nil);
        return;
    }
    
    [_classRoomCamera release],_classRoomCamera = nil;
    _classRoomCamera = [classRoomCamera retain];
    
    self.title_label.text = _classRoomCamera.camera_name;
    
    if (_classRoomCamera.status){
        self.switch_label.text = NSLocalizedString(@"ON",nil);
    }else{
        self.switch_label.text = NSLocalizedString(@"OFF",nil);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
