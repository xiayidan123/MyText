//
//  SignInOrLeaveCell.m
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SignInOrLeaveCell.h"

@implementation SignInOrLeaveCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"signorleave";
    SignInOrLeaveCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SignInOrLeaveCell" owner:self options:nil] lastObject];
    }
    return cell;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [_title_label release];
    [_content_label release];
    [super dealloc];
}
@end
