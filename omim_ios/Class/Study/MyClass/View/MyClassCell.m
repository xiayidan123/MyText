//
//  MyClassCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MyClassCell.h"
#import "OMClass.h"



@interface MyClassCell ()

@property (retain, nonatomic) IBOutlet UIImageView *iamgeView_title;

@property (retain, nonatomic) IBOutlet UILabel *className_label;

@end

@implementation MyClassCell

- (void)dealloc {
    [_classModel release];
    [_iamgeView_title release];
    [_className_label release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"MyClassCellID";
    MyClassCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyClassCell" owner:self options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}


-(void)setClassModel:(OMClass *)classModel{
    [_classModel release],_classModel = nil;
    _classModel = [classModel retain];
    
    if ([_classModel.thumbnail length] != 0){
        self.iamgeView_title.image = [UIImage imageNamed:_classModel.thumbnail];
    }
    
    self.className_label.text = _classModel.groupNameOriginal;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected){
        self.iamgeView_title.image = [UIImage imageNamed:@"icon_myclass_leftpage_u"];
        self.className_label.textColor = [UIColor colorWithRed:0.15 green:0.72 blue:0.94 alpha:1];
    }else{
        self.iamgeView_title.image = [UIImage imageNamed:@"icon_myclass_leftpage_r"];
        self.className_label.textColor = [UIColor blackColor];
    }
    
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



@end
