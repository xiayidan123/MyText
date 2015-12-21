//
//  OMBaseLabelCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBaseLabelCell.h"
#import "OMBaseCellFrameModel.h"


@interface OMBaseLabelCell ()

@property (retain, nonatomic) IBOutlet UIImageView *headerImage;
@property (retain, nonatomic) IBOutlet UILabel *label_title;
@property (retain, nonatomic) IBOutlet UILabel *label_content;

@end


@implementation OMBaseLabelCell

- (void)dealloc {
    [_headerImage release];
    [_label_title release];
    [_label_content release];
    [super dealloc];
}

-(void)setCellFrameModel:(OMBaseCellFrameModel *)cellFrameModel{
    _cellFrameModel = [cellFrameModel retain];
    
    _label_title.text = _cellFrameModel.cellModel.title;
    _label_content.text = _cellFrameModel.cellModel.content;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
