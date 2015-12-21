//
//  AddClasstimetableCell.m
//  dev01
//
//  Created by 杨彬 on 14-12-29.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "AddClasstimetableCell.h"

@interface AddClasstimetableCell ()

@property (retain, nonatomic) IBOutlet UILabel *lab_add;

@end


@implementation AddClasstimetableCell

- (void)dealloc {
    [_lab_add release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"AddClasstimetableCellID";
    AddClasstimetableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddClasstimetableCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


-(void)setText_context:(NSString *)text_context{
    [_text_context release],_text_context = nil;
    _text_context = [text_context retain];
    
    self.lab_add.text = _text_context;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
