//
//  TextOutgoingCell.h
//  omim
//
//  Created by coca on 2012/10/08.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ChatMessage;
@class MsgComposerVC;

@interface TextOutgoingCell : UITableViewCell

@property(nonatomic,assign) UIViewController* parent;
@property (nonatomic,assign) ChatMessage* msg;


@property (retain,nonatomic) IBOutlet UIImageView *iv_bg;
@property (retain,nonatomic) IBOutlet UILabel* lbl_msg ;
@property (retain,nonatomic) IBOutlet UILabel* lbl_senttime;
@property (retain,nonatomic) IBOutlet UIButton* btn_resend;
@property (retain,nonatomic) IBOutlet UILabel* lbl_status;
@property (retain,nonatomic) IBOutlet UIActivityIndicatorView* ua_indicator;
@property (retain, nonatomic) IBOutlet UITextView *lblText;

+(float)getCellHeight:(NSString*)text;
@end
