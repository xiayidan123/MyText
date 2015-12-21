//
//  FindPasswordVC.h
//  omim
//
//  Created by wow on 14-3-28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordVC : UIViewController <UIGestureRecognizerDelegate>


@property (retain, nonatomic) IBOutlet UIImageView *imgBG;
@property (retain, nonatomic) IBOutlet UIImageView *imgUIDBG;
@property (retain, nonatomic) IBOutlet UIImageView *imgMailBG;

@property (retain, nonatomic) IBOutlet UITextField *txtUID;
@property (retain, nonatomic) IBOutlet UITextField *txtMailOrPhone;
@property (retain, nonatomic) IBOutlet UIButton* btnBack;
@property (retain, nonatomic) IBOutlet UIButton* btnFindPassword;


- (IBAction)fBack:(id)sender;
- (IBAction)fFindPassword:(id)sender;

@end
