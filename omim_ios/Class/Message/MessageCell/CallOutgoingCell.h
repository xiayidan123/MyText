//
//  CallOutgoingCell.h
//  omim
//
//  Created by coca on 2013/02/22.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MsgComposerVC;

@interface CallOutgoingCell : UITableViewCell<UIAlertViewDelegate>

@property(nonatomic,assign) MsgComposerVC* parent;
//@property (nonatomic,assign) ChatMessage* msg;


@property (retain,nonatomic) IBOutlet UIImageView *iv_bg;
@property (retain,nonatomic) IBOutlet UIImageView* iv_call;
@property (retain,nonatomic) IBOutlet UILabel* lbl_msg;
@property (retain,nonatomic) IBOutlet UILabel* lbl_senttime;
@property (retain,nonatomic) IBOutlet UIButton* btn_call;
@property (retain,nonatomic) IBOutlet UILabel* lbl_status;

-(IBAction)readyToCall:(id)sender;
@end
