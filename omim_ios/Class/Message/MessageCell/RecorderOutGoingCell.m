//
//  RecorderOutGoingCell.m
//  omim
//
//  Created by coca on 12/09/15.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "RecorderOutGoingCell.h"

#import "WowTalkVoipIF.h"
#import "PDColoredProgressView.h"

#import "WTHeader.h"
#import "Constants.h"
#import "MsgComposerVC.h"
#import "PublicFunctions.h"

@implementation RecorderOutGoingCell

@synthesize lbl_duration,lbl_sentlabel,lbl_senttimeLabel;
@synthesize btn_play,iv_bg,iv_playing;
@synthesize parent=_parent, msg = _msg;
@synthesize indexPath = _indexPath;
@synthesize progressView = _progressView;
@synthesize btn_resend;
@synthesize ua_indicator = _ua_indicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)getUploadProgress:(NSTimer*)timer
{
    WTNetworkTask* task = (WTNetworkTask*)[timer userInfo];
    self.progressView.progress = [task currentProgressForUploadTask];
    
}

-(void)resendVoiceMessage
{
    [self.parent.txtView_Input resignFirstResponder];
    
    if ([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_FILE_UPLOADINIT]])
    {
        self.msg.fileTransfering = TRUE;
        self.btn_resend.hidden = YES;
        self.progressView.hidden = NO;

        [WowTalkWebServerIF uploadMediaMessageOriginalFile:self.msg withCallback:@selector(didUploadOriginalFile:) withObserver:nil];
        WTNetworkTask* task = [[WTNetworkTaskManager defaultManager] taskforMessage:self.msg];
        if (task.timer != nil || [task.timer isValid]) {
            [task.timer invalidate];
            task.timer= nil;
        }
        task.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(getUploadProgress:) userInfo:task repeats:YES];
        [task.timer fire];
    }
    
    else
    {
        if (self.parent.isGroupMode) {
            self.msg.isGroupChatMessage = TRUE;
            self.msg.groupChatSenderID = [WTUserDefaults getUid];
            [WowTalkWebServerIF groupChat_SendMessage:self.msg toGroup:self.parent._userName  withCallback:@selector(didSendChatByWebIF:) withObserver:nil];
        }
        else{
             [WowTalkWebServerIF sendBuddyMessage:self.msg];
        }
        [self setNeedsLayout];
    }
    
}


-(void)layoutSubviews
{
       
    CGFloat screenwidth = [UISize screenWidth];
    
    self.iv_bg.frame = CGRectMake(screenwidth - OUTGOINGCELL_BG_DIST_R - DEFAULT_VOICECELL_BG_W, 0, DEFAULT_VOICECELL_BG_W+BG_TAIL_WIDTH, DEFAULT_VOICECELL_BG_H);

    
    if (!isPlaying)
    {
        self.iv_playing.frame = CGRectMake(self.iv_bg.frame.origin.x+IMAGE_PLAY_OFFSET_R_X,  (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAY_INIT_R_H)/2, IMAGE_PLAY_INIT_R_W, IMAGE_PLAY_INIT_R_H);

        [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_INIT_R]];
    }
    else
    {

        self.iv_playing.frame = CGRectMake(self.iv_bg.frame.origin.x+IMAGE_PLAY_OFFSET_R_X, (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAYING_R_H)/2, IMAGE_PLAYING_R_W, IMAGE_PLAYING_R_H);


        if (times%3 == 0)
        {
            [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_ONE_R]];
        }
        else if(times%3 == 1)
        {
            [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_TWO_R]];
        }
        
        else if(times%3 == 2)
        {
            [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_THREE_R]];
        }
        
    }
    
    self.btn_play.frame = self.iv_bg.frame;
    
    self.lbl_duration.frame = CGRectMake(self.iv_bg.frame.origin.x + DURATION_LABEL_L_OFFSET_X,  (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - DURATION_LABEL_H)/2 , DURATION_LABEL_W, DURATION_LABEL_H);
    
    self.progressView.frame = CGRectMake(self.iv_bg.frame.origin.x - OUTGOINGCELL_PROGRESS_OFFSET_X - OUTGOINGCELL_PROGRESS_W, (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - OUTGOINGCELL_PROGRESS_H)/2, OUTGOINGCELL_PROGRESS_W, OUTGOINGCELL_PROGRESS_H);
    
    
    self.btn_resend.hidden = YES;
    self.lbl_sentlabel.hidden = YES;
    self.lbl_senttimeLabel.hidden = YES;
    self.lbl_sentlabel.text = @"";
    self.progressView.hidden = YES;

    self.btn_resend.frame =  CGRectMake(self.iv_bg.frame.origin.x-OUTGOINGCELL_FAILMARK_BG_OFFSET_X -OUTGOINGCELL_FAILMARK_W, (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - OUTGOINGCELL_FAILMARK_H)/2 , OUTGOINGCELL_FAILMARK_W, OUTGOINGCELL_FAILMARK_H);
  
    [self.ua_indicator stopAnimating];
    [self.ua_indicator setHidden:TRUE];
    
    // failed to send
    if ([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_NOTSENT]])
    {
        self.progressView.hidden = YES;
        self.btn_resend.hidden = NO;
    }
    
    // upload failed.
    else if([[self.msg sentStatus] isEqualToString:[ChatMessage SENTSTATUS_FILE_UPLOADINIT]])
    {
            self.progressView.hidden = YES;
            self.btn_resend.hidden = NO;
    }
    else if ([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_IN_PROCESS]]){
        self.btn_resend.hidden = YES;
        self.lbl_senttimeLabel.hidden = YES;
        self.lbl_sentlabel.hidden = YES;
        
        self.lbl_sentlabel.text = @"";
        self.lbl_senttimeLabel.text = @"";
        
        [self.ua_indicator setFrame:CGRectMake(self.iv_bg.frame.origin.x - OUTGOINGCELL_INDICATOR_OFFSET_X-OUTGOINGCELL_INDICATOR_W, (self.iv_bg.frame.origin.y + self.iv_bg.frame.size.height - OUTGOINGCELL_INDICATOR_H)/2.0, OUTGOINGCELL_INDICATOR_W, OUTGOINGCELL_INDICATOR_H)];
        [self.ua_indicator setHidden:false];
        [self.ua_indicator startAnimating];
    }
    
    // send ,reached, read status
    else
    {
        //
        self.progressView.hidden = YES;
        self.lbl_sentlabel.hidden = NO;
        self.lbl_senttimeLabel.hidden = NO;
        self.lbl_sentlabel.text = @"";
        
        if([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_SENT]])
        {
            self.lbl_sentlabel.text = NSLocalizedString(@"Sent", nil);
        }
        else if([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_REACHED_CONTACT]])
        {
            self.lbl_sentlabel.text = NSLocalizedString(@"Reached", nil);
        }
        else if([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_READED_BY_CONTACT]])
        {
            self.lbl_sentlabel.text = NSLocalizedString(@"Read", nil);
            
        }
    
        self.lbl_senttimeLabel.frame = CGRectMake(self.iv_bg.frame.origin.x - SENTTIMELABEL_W -OUTGOINGCELL_SENTTIMELABEL_BG_OFFSET_X , OUTGOINGCELL_SENTTIMELABEL_Y , SENTTIMELABEL_W, SENTTIMELABEL_H);
        self.lbl_sentlabel.frame = CGRectMake(self.iv_bg.frame.origin.x-OUTGOINGCELL_STATUS_BG_OFFSET_X-OUTGOINGCELL_STATUS_W , OUTGOINGCELL_STATUS_Y , OUTGOINGCELL_STATUS_W, OUTGOINGCELL_STATUS_H);
        
    }
    

    if(self.msg.fileTransfering)
    {
        self.progressView.hidden = NO;
        self.btn_resend.hidden = YES;
    }
    
    if (IS_IOS7) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
   

}


- (void) timeHandler:(VoiceMessagePlayer *)requestor
{
    
    
	times ++;
    
    if (times%3 == 0)
    {
        [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_ONE_R]];
    }
    else if(times%3 == 1)
    {
        [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_TWO_R]];
    }
    
    else if(times%3 == 2)
    {
        [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_THREE_R]];
    }
    
    if (times > self.totalLength) {
        self.lbl_duration.text = [TimeHelper getTimeFromSeconds:self.totalLength];
    }
    else
        self.lbl_duration.text = [TimeHelper getTimeFromSeconds:times];
    
}


-(IBAction)playRecord:(id)sender
{
    
    if (isPlaying)
    {
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
        return;
    }
    else
    {
        if ([[VoiceMessagePlayer sharedInstance] isPlaying]) {
            [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
        }
        
        self.lbl_duration.text = [TimeHelper getTimeFromSeconds:0];
        [VoiceMessagePlayer sharedInstance].delegate = self;
            
        [VoiceMessagePlayer sharedInstance].filepath =  [NSFileManager absolutePathForFileInDocumentFolder:self.msg.pathOfMultimedia];
            
        [[VoiceMessagePlayer sharedInstance] playVoiceMessage];
        
    }
    
  
}

-(void)didStopPlayingVoice:(VoiceMessagePlayer *)requestor
{
    
    isPlaying = FALSE;
    times = 0;
    self.lbl_duration.text = [TimeHelper getTimeFromSeconds:self.totalLength];
    
    [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_INIT_R]];
    
    self.iv_playing.frame = CGRectMake(self.iv_bg.frame.origin.x+IMAGE_PLAY_OFFSET_R_X,  (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAY_INIT_R_H)/2, IMAGE_PLAY_INIT_R_W, IMAGE_PLAY_INIT_R_H);

}

-(void)willStartToPlayVoice:(VoiceMessagePlayer *)requestor
{
    times = 0;
    isPlaying = TRUE;
    
    [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_ONE_R]];
    self.iv_playing.frame = CGRectMake(self.iv_bg.frame.origin.x+IMAGE_PLAY_OFFSET_R_X, (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAYING_R_H)/2, IMAGE_PLAYING_R_W, IMAGE_PLAYING_R_H);
}

-(void)dealloc
{

     [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.parent = nil;
    self.msg = nil;
    
    self.iv_playing = nil;
    self.iv_bg = nil;
    
    self.btn_play = nil;
    self.btn_resend = nil;
    
    self.lbl_duration = nil;
    self.lbl_sentlabel = nil;
    self.lbl_senttimeLabel = nil;
    self.progressView = nil;
    self.indexPath = nil;
    [super dealloc];
}

@end
