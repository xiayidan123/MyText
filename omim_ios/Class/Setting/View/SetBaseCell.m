//
//  SetBaseCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SetBaseCell.h"
#import "SetCellFrameModel.h"


@interface SetBaseCell ()

@property (retain, nonatomic) IBOutlet UILabel *title_label;

@property (retain, nonatomic) IBOutlet UILabel *content_label;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *content_layout;
@end

@implementation SetBaseCell

- (void)dealloc {
    [_title_label release];
    [_content_label release];
    [_frameModel release];
    [_content_layout release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *setBaseCellID = @"SetBaseCellID";
    SetBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:setBaseCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetBaseCell" owner:self options:nil] lastObject];
    }
    return cell;
}


-(void)setFrameModel:(SetCellFrameModel *)frameModel{
    [_frameModel release],_frameModel = nil;
    _frameModel = [frameModel retain];
    
    self.title_label.text = _frameModel.title;
    self.content_label.text = _frameModel.content;
    
    if (_frameModel.canEnter){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.content_layout.constant = 0;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
        self.content_layout.constant = 20;
    }
}



- (void)awakeFromNib {
    
}




@end
