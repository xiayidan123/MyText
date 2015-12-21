//
//  omim
//
//  Created by Harry on 14-1-14.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface LoginVC : UIViewController <UIGestureRecognizerDelegate,CLLocationManagerDelegate>
{
    NSTimer *timer;
    NSInteger checkTime;
}

@property (retain, nonatomic) IBOutlet UIImageView *backGroudImage;
@property (retain, nonatomic) IBOutlet UIView *centerView;
@property (retain, nonatomic) IBOutlet UIImageView *imgAccountBG;
@property (retain, nonatomic) IBOutlet UIImageView *imgAccountBGDivider;
@property (retain, nonatomic) IBOutlet UIImageView *imgLogo;
@property (retain, nonatomic) IBOutlet UILabel *lblLogo;

@property (retain, nonatomic) IBOutlet UITextField *txtAccount;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;

@property (retain, nonatomic) IBOutlet UIButton *btnRegister;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
@property (retain, nonatomic) IBOutlet UIButton *btnForgetPassword;


@property (nonatomic,retain)CLLocationManager *myLocationManager;

@property (assign) CGRect oldCenterViewFrame;


- (IBAction)fRegister:(id)sender;
- (IBAction)fForgetPassword:(id)sender;
- (IBAction)fResignFirstResponder:(id)sender;

- (IBAction)loginFromEmail:(id)sender;

@end
