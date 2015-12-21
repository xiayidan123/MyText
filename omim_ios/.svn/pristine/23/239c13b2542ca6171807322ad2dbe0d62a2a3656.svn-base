//
//  LocationIncomingCell.h
//  omim
//
//  Created by coca on 2012/11/11.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMHeadImgeView.h"

@class MsgComposerVC;
@class ChatMessage;
@class ViewDetailedLocationVC;

@interface LocationIncomingCell : UITableViewCell

@property (nonatomic,assign) MsgComposerVC* parent;
@property (nonatomic,assign) ChatMessage* msg;

@property (retain,nonatomic) IBOutlet UIImageView *iv_bg;
@property (retain,nonatomic) IBOutlet UILabel* lbl_senttime;

@property (retain,nonatomic) IBOutlet UILabel* lbl_name;
@property (retain,nonatomic) IBOutlet UILabel* lbl_address;

@property (nonatomic,retain) IBOutlet UIImageView* iv_content;

@property (nonatomic,retain) IBOutlet UIButton* btn_view;

@property (nonatomic,retain) UIButton* btn_viewbuddy;

@property (nonatomic,retain) ViewDetailedLocationVC* vdl;
@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;

-(IBAction)viewTheDetailMap:(id)sender;


@end
