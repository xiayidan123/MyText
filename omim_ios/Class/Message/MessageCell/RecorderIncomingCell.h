//
//  RecorderIncomingCell.h
//  omim
//
//  Created by coca on 12/09/19.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceMessagePlayer.h"
#import "OMHeadImgeView.h"
@class PDColoredProgressView;
@class MsgComposerVC;
@class ChatMessage;



@interface RecorderIncomingCell : UITableViewCell<VoiceMessagePlayerDelegate>
{
    int times;
    BOOL isPlaying;
    
}

@property (nonatomic,assign) MsgComposerVC* parent;
@property (nonatomic,assign) ChatMessage* msg;
@property (nonatomic,retain) NSIndexPath* indexPath;

@property (nonatomic,assign) int totalLength;

@property (nonatomic,retain) IBOutlet UIImageView* iv_bg;
@property (nonatomic,retain) IBOutlet UIImageView* iv_playing;

@property (nonatomic,retain) IBOutlet UIButton* btn_play;


@property (nonatomic,retain) IBOutlet UILabel* lbl_name;
@property (nonatomic,retain) IBOutlet UILabel* lbl_duration;
@property (nonatomic,retain) IBOutlet UILabel* lbl_senttimeLabel;

@property (nonatomic,retain) IBOutlet UIImageView* iv_status;  // read or not read

@property (nonatomic,retain)  PDColoredProgressView* progressView;

@property (nonatomic,retain) UIButton* btn_viewbuddy;

@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;

-(void)playRecord;

@end
