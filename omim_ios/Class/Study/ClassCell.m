//
//  ClassCell.m
//  dev01
//
//  Created by 杨彬 on 14-10-8.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ClassCell.h"
#import "OMClass.h"
@implementation ClassCell



- (void)dealloc {
    self.omClass = nil;
    [_bgImgv release];
    [_lbl_className release];
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
    [self loadcellBackGround];
    _bgImgv.image = [UIImage imageNamed:@"class_bg_3"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"cellid";
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setOmClass:(OMClass *)omClass
{
    if (_omClass != omClass) {
        [_omClass release];
        _omClass = [omClass retain];
        _lbl_className.text = _omClass.groupNameOriginal;
        NSInteger index = [_omClass.groupID characterAtIndex:2] % 3 + 1;
        _bgImgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"class_bg_%zi",index]];
    }
}

-(void)loadcellBackGround
{
    self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



@end
