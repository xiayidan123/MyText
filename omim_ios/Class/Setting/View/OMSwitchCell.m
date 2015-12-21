//
//  OMSwitchCell.m
//  dev01
//
//  Created by Starmoon on 15/7/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMSwitchCell.h"

#import "SetCellFrameModel.h"

@interface OMSwitchCell ()<UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *title_label;

@property (retain, nonatomic) IBOutlet UISwitch *on_switch;

@end

@implementation OMSwitchCell

- (void)dealloc {
    [_title_label release];
    [_on_switch release];
    [super dealloc];
}



- (IBAction)changeState:(UISwitch *)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:@"确定修改被要求权限？" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    [alertView show];
    [alertView release];
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){// 取消
        self.on_switch.on = !self.on_switch.on;
    }else{
        if ([self.delegate respondsToSelector:@selector(switchCell:didChangeState:)]){
            [self.delegate switchCell:self didChangeState:self.on_switch.on];
        }
    }
}


-(void)setFrame_model:(SetCellFrameModel *)frame_model{
    [_frame_model release],_frame_model = nil;
    _frame_model = [frame_model retain];
    
    self.title_label.text = _frame_model.title;
    self.on_switch.on = _frame_model.on;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *switchCellID = @"switchCellID";
    OMSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OMSwitchCell" owner:self options:nil] lastObject];
    }
    return cell;
}


@end
