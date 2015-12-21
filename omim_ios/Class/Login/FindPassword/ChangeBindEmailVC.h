//
//  ChangeBindEmailVC.h
//  dev01
//
//  Created by Huan on 15/3/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"

@interface ChangeBindEmailVC : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *sureBtn;
@property (retain, nonatomic) IBOutlet UITextField *VerifyCodeTX;
@property (retain, nonatomic) IBOutlet UILabel *Tips;
@property (retain, nonatomic) IBOutlet UIButton *getCodeBtn;
//- (IBAction)getCode:(id)sender;
- (IBAction)codeIsCorrect:(id)sender;

@end
