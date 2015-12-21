//
//  RecorderOutGoingCell.h
//  omim
//
//  Created by coca on 12/09/15.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceMessagePlayer.h"

@class PDColoredProgressView;
@class MsgComposerVC;
@class ChatMessage;

@interface RecorderOutGoingCell : UITableViewCell<VoiceMessagePlayerDelegate>
{
    int times;
    BOOL isPlaying;

}
@property (nonatomic,retain) MsgComposerVC* parent;
@property (nonatomic,retain) ChatMessage* msg;
@property (nonatomic,retain) NSIndexPath* indexPath;

@property int totalLength;

@property (nonatomic,retain) IBOutlet UIImageView* iv_bg;

@property (nonatomic,retain) IBOutlet UIImageView* iv_playing;

@property (nonatomic,retain) IBOutlet UIButton* btn_play;
@property (nonatomic,retain) IBOutlet UIButton* btn_resend;

@property (nonatomic,retain) IBOutlet UILabel* lbl_duration;
@property (nonatomic,retain) IBOutlet UILabel* lbl_sentlabel;
@property (nonatomic,retain) IBOutlet UILabel* lbl_senttimeLabel;

@property (nonatomic,retain)  PDColoredProgressView* progressView;
@property (retain,nonatomic) IBOutlet UIActivityIndicatorView* ua_indicator;

-(IBAction)playRecord:(id)sender;

@end
