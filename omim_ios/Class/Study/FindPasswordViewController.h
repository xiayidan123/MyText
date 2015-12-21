//
//  FindPasswordViewController.h
//  dev01
//
//  Created by macbook air on 14-9-25.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *lblLogo;

@property (retain, nonatomic) IBOutlet UIView *upView;

@property (retain, nonatomic) IBOutlet UIView *inputView;

@property (retain, nonatomic) IBOutlet UITextField *tfEmail;

@property (retain, nonatomic) IBOutlet UIButton *btnEnter;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)enterClick:(id)sender;
- (IBAction)backClick:(id)sender;

@end
