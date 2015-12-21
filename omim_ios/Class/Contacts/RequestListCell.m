//
//  RequestListCell.m
//  dev01
//
//  Created by Huan on 15/3/5.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "RequestListCell.h"

@implementation RequestListCell

- (void)awakeFromNib {
    // Initialization code
    _Accept.backgroundColor = [UIColor colorWithRed:0.00f green:0.67f blue:0.99f alpha:1.00f];
    _Reject.backgroundColor = [UIColor colorWithRed:0.00f green:0.67f blue:0.99f alpha:1.00f];
    [_Accept.layer setCornerRadius:5.0];
    [_Reject.layer setCornerRadius:5.0];
    _RequestMsg.numberOfLines = 0;
    
    _nameLab.numberOfLines = 1;
    _RequestMsg.font = [UIFont systemFontOfSize:12];
    _headImg.backgroundColor = [UIColor blackColor];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImg release];
    [_RequestMsg release];
    [_Accept release];
    [_Reject release];
    [_nameLab release];
    [super dealloc];
}
@end
