//
//  ResetPwdVC.h
//  omim
//
//  Created by wow on 14-3-28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPwdVC : UIViewController <UIGestureRecognizerDelegate>
{
    NSTimer *timer;
    NSInteger checkTime;
}

@property (nonatomic, copy) NSString *wowtalkid;

@property (retain, nonatomic) IBOutlet UIImageView *imgBG;
@property (retain, nonatomic) IBOutlet UIImageView *imgAuthCodeBG;
@property (retain, nonatomic) IBOutlet UIImageView *imgCenterviewBG;

@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtPasswordAgain;
@property (retain, nonatomic) IBOutlet UITextField *txtAuthcode;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (retain, nonatomic) IBOutlet UIButton *btnConfirm;

- (IBAction)fBack:(id)sender;
- (IBAction)fConfirm:(id)sender;

- (IBAction)fResignFirstResponder:(id)sender;

@end
