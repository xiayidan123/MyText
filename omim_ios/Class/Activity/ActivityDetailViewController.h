//
//  ActivityDetailViewController.h
//  dev01
//
//  Created by jianxd on 13-7-4.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//


#import <UIKit/UIKit.h>
@class Activity;

@interface ActivityDetailViewController : UIViewController <
UITextFieldDelegate,
UIGestureRecognizerDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource,
UIActionSheetDelegate,
UIAlertViewDelegate>

@property (retain, nonatomic) Activity *activity;

@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;

// title view
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

// detail view
@property (retain, nonatomic) IBOutlet UIView *detailView;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *areaLabel;
@property (retain, nonatomic) IBOutlet UILabel *classicLabel;
@property (retain, nonatomic) IBOutlet UILabel *costLabel;

// voice view
@property (retain, nonatomic) IBOutlet UIView *voiceView;

// description view
@property (retain, nonatomic) IBOutlet UIView *descriptionView;
@property (retain, nonatomic) IBOutlet UILabel *descriptionTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *descriptionContentLabel;

// sign up info view
@property (retain, nonatomic) IBOutlet UIView *signupInfoView;
@property (retain, nonatomic) IBOutlet UIView *signupInputView;
@property (retain, nonatomic) IBOutlet UILabel *phoneTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneContentLabel;

// sign up view
@property (retain, nonatomic) IBOutlet UIView *signupView;
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UILabel *infoTitleLabel;

@property (retain, nonatomic) IBOutlet UIView *timeView;
@property (retain, nonatomic) IBOutlet UILabel *chooseTimeTitle;
@property (retain, nonatomic) IBOutlet UIImageView *chooseTimeImageView;
@property (retain, nonatomic) IBOutlet UILabel *choosedTimeLabel;
@property (retain, nonatomic) IBOutlet UIView *joinedNumberView;
@property (retain, nonatomic) IBOutlet UILabel *joinedNumberTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *joinedNumberLabel;
@property (retain, nonatomic) IBOutlet UIButton *signupButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)applyTheEvent:(UIButton *)sender;
- (IBAction)cancelAppliedEvent:(UIButton *)sender;


@end
