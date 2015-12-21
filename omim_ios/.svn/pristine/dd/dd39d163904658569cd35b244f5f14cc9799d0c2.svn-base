//
//  ActivityViewController.h
//  yuanqutong
//
//  Created by Harry on 13-1-11.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@class ApplyActivityViewController;

@interface ActivityViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    NSInteger _offsetYBefore;
    NSTimer *timer;
    NSInteger voiceTime;
    Activity *activity;
    ApplyActivityViewController *applyActivityViewController;
}

@property (retain, nonatomic) Activity *activity;
@property (retain, nonatomic) ApplyActivityViewController *applyActivityViewController;
@property (retain, nonatomic) NSMutableArray *imageViews;
@property (assign, nonatomic) NSInteger voiceTime;

@property (retain, nonatomic) IBOutlet UIScrollView *activityScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *pictureScrollView;

@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UIView *detailView;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *localeLabel;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UILabel *feeLabel;

@property (retain, nonatomic) IBOutlet UIView *voiceView;
@property (retain, nonatomic) IBOutlet UIButton *voiceButton;
@property (retain, nonatomic) IBOutlet UILabel *voiceLabel;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;

@property (retain, nonatomic) IBOutlet UIView *applyView;
@property (retain, nonatomic) IBOutlet UIView *inputView;
@property (retain, nonatomic) IBOutlet UIImageView *inputBg;
@property (retain, nonatomic) IBOutlet UIImageView *inputDivider;
@property (retain, nonatomic) IBOutlet UITextField *inputName;
@property (retain, nonatomic) IBOutlet UITextField *inputPhonenumber;
@property (retain, nonatomic) IBOutlet UIView *moreInfoView;
@property (retain, nonatomic) IBOutlet UILabel *moreInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *sendIndicatorLabel;
@property (retain, nonatomic) IBOutlet UILabel *emailLabel;

@property (retain, nonatomic) IBOutlet UIView *buttonView;
@property (retain, nonatomic) IBOutlet UIButton *applyButton;
@property (retain, nonatomic) IBOutlet UIButton *discussionButton;

- (IBAction)voiceButtonClick:(id)sender;
- (IBAction)discussionButtonClick:(id)sender;
- (IBAction)applyButtonClick:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forMessage:(Activity *)messageInfo;

@end
