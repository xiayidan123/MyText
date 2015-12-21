//
//  StudyscheduleCell.h
//  dev01
//
//  Created by 杨彬 on 14-10-8.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyscheduleCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UILabel *lbl_title;
@property (retain, nonatomic) IBOutlet UILabel *lal_score;
@property (retain, nonatomic) IBOutlet UIView *scoreBgView;
@property (retain, nonatomic) IBOutlet UIButton *btn_keepstudy;


@property (nonatomic,copy)void(^CB)(void);
- (IBAction)keepstudyClick:(id)sender;
-(void)loadcellWithTitle:(NSString *)title andScore:(NSInteger)score;
@end
