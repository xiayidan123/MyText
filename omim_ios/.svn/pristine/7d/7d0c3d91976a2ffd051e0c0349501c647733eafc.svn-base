//
//  TextIncomingCell.h
//  omim
//
//  Created by coca on 2012/10/07.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMHeadImgeView.h"

@class ChatMessage;
@class MsgComposerVC;

@interface TextIncomingCell : UITableViewCell

@property (nonatomic,retain) UIViewController* parent;
@property (nonatomic,retain) ChatMessage* msg;

@property (retain,nonatomic) IBOutlet UIImageView *iv_bg;
@property (retain,nonatomic) IBOutlet UILabel* lbl_msg ;
@property (retain,nonatomic) IBOutlet UILabel* lbl_senttime;

@property (retain,nonatomic) IBOutlet UILabel* lbl_name;

@property (nonatomic,retain) UIButton* btn_viewbuddy;
@property (retain, nonatomic) IBOutlet UITextView *lblText;

@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;

+(float)getCellHeight:(NSString*)text forGroupMsg:(BOOL)isGroupMsg;
@end
