//
//  ApplyActivityViewController.m
//  yuanqutong
//
//  Created by Harry on 13-1-11.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "ApplyActivityViewController.h"
#import "PublicFunctions.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "WTHeader.h"



@interface ApplyActivityViewController ()

- (void)initTextView;

@end

@implementation ApplyActivityViewController

@synthesize activityId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"活动报名";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = barButton;
    [barButton release];
    
    UIBarButtonItem *barButtonRight = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_CONFIRM_IMAGE] selector:@selector(confirm)];
    self.navigationItem.rightBarButtonItem = barButtonRight;
    [barButtonRight release];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyDone:) name:APPLY_ACTIVITY_NOTIFICATION object:nil];
    
    [self initTextView];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm
{
    [WowTalkWebServerIF joinEvent:self.activityId withCallback:@selector(applyDone:) withObserver:self];
    /*
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:[NSString stringWithFormat:@"%@", self.activityId] taskInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.activityId, WT_EVENT_ID, nil] taskType:JOIN_EVENT notificationName:APPLY_ACTIVITY_NOTIFICATION notificationObserver:self userInfo:nil];
    [task startWithSelector:@selector(applyDone:)];
     */
}

- (void)applyDone:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSError *error = [dic objectForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
//        NSLog(@"success");
    } else {
//        NSLog(@"failure");
    }
}

- (void)initTextView
{   
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 236.0f)];
    _contentTextView.layer.cornerRadius = 5.0f;
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _contentTextView.font = [UIFont systemFontOfSize:14.0f];
    _contentTextView.returnKeyType = UIReturnKeyDone;
    _contentTextView.keyboardType = UIKeyboardTypeDefault;
    _contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_contentTextView setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    [self.view addSubview:_contentTextView];
    [_contentTextView release];
    [_contentTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [activityId release];
    [_contentTextView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPLY_ACTIVITY_NOTIFICATION object:nil];
    [self setContentTextView:nil];
    [super viewDidUnload];
}


@end
