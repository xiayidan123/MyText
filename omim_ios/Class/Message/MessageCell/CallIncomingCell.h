//
//  CallIncomingCell.h
//  omim
//
//  Created by coca on 2013/02/23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MsgComposerVC;
@class ChatMessage;

@interface CallIncomingCell : UITableViewCell<UIAlertViewDelegate>

@property (nonatomic,retain) MsgComposerVC* parent;
@property (nonatomic,retain) ChatMessage* msg;

@property (retain,nonatomic) IBOutlet UIImageView *iv_bg;
@property (retain,nonatomic) IBOutlet UIImageView *iv_call;
@property (retain,nonatomic) IBOutlet UILabel* lbl_msg ;
@property (retain,nonatomic) IBOutlet UILabel* lbl_senttime;
@property (retain,nonatomic) IBOutlet UIButton* btn_call;
@property (retain,nonatomic) IBOutlet UIImageView* iv_profile;

@property (nonatomic,retain) UIButton* btn_viewbuddy;


-(IBAction)readyTocall:(id)sender;

@end
