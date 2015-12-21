//
//  LocationOutgoingCell.h
//  omim
//
//  Created by coca on 2012/11/11.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MsgComposerVC;
@class ChatMessage;
@class ViewDetailedLocationVC;

@interface LocationOutgoingCell : UITableViewCell


@property(nonatomic,assign) MsgComposerVC* parent;
@property (nonatomic,assign) ChatMessage* msg;
@property (nonatomic,assign) ViewDetailedLocationVC* vdl;

@property (retain,nonatomic) IBOutlet UIImageView * iv_bg;
@property (retain,nonatomic) IBOutlet UIImageView * iv_content;

@property (retain,nonatomic) IBOutlet UILabel* lbl_address;

@property (retain,nonatomic) IBOutlet UILabel* lbl_senttime;
@property (retain,nonatomic) IBOutlet UIButton* btn_resend;
@property (retain,nonatomic) IBOutlet UILabel* lbl_status;

@property (retain,nonatomic) IBOutlet UIButton* btn_view;
@property (retain,nonatomic) IBOutlet UIActivityIndicatorView* ua_indicator;

-(IBAction)viewDetailedMap:(id)sender;

@end
