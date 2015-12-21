//
//  NewAccountSettingVC.h
//  dev01
//
//  Created by Huan on 15/3/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"

@interface NewAccountSettingVC : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UILabel *blidingTips;
@property (retain, nonatomic) IBOutlet UITextField *blidingEmailTX;
@property (retain, nonatomic) IBOutlet UILabel *EmailTips;
@property (retain, nonatomic) IBOutlet UIButton *BlidingButton;
- (IBAction)BlindingEmail:(id)sender;

@end
