//
//  RecorderIncomingCell.m
//  omim
//
//  Created by coca on 12/09/19.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "RecorderIncomingCell.h"


#import "PDColoredProgressView.h"
#import "Database.h"
#import "Buddy.h"

#import "Constants.h"
#import "WTHeader.h"
#import "PublicFunctions.h"

#import "MsgComposerVC.h"
#import "ContactInfoViewController.h"
@interface RecorderIncomingCell()



@end

@implementation RecorderIncomingCell
@synthesize lbl_senttimeLabel,lbl_duration,lbl_name;
@synthesize btn_play;
@synthesize iv_bg,iv_playing;

@synthesize progressView;
@synthesize iv_status;
@synthesize parent,msg;

@synthesize indexPath = _indexPath;


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


-(void)downloadAndPlayVoiceMessage
{
       self.msg.fileTransfering = FALSE;
        // no media in local storage. download first
        if (self.msg.pathOfMultimedia == nil || [self.msg.pathOfMultimedia isEqualToString:@""])
        {
            
            self.msg.fileTransfering = TRUE;
            self.progressView.hidden = NO;
            self.btn_play.enabled = NO;
            self.iv_status.hidden = YES;
            
            SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
            
            NSDictionary* dic = (NSDictionary*)[jp fragmentWithString: self.msg.messageContent];
            [dic setValue:VoiceMessageReaded forKey:STATUS];
            NSString* extension = [dic valueForKey:VOICE_MESSAGE_EXT];
            if(extension == nil || [extension isEqualToString:@""])
            {
                extension = AAC;
            }
            
            [dic setValue:extension forKey:VOICE_MESSAGE_EXT];
            
            SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
            
            self.msg.messageContent = [jw stringWithFragment:dic];

            [WowTalkWebServerIF downloadMediaMessageOriginalFile:self.msg withCallback:@selector(didDownloadOriginalFile:) withObserver:nil];
            WTNetworkTask* task = [[WTNetworkTaskManager defaultManager] taskforMessage:self.msg];
            if (task.timer != nil || [task.timer isValid]) {
                [task.timer invalidate];
                task.timer= nil;
            }
            task.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(getDownloadProgress:) userInfo:task repeats:YES];
            [task.timer fire];
            
        }
        // play the record.
        else
            [self playRecord];
        
}

-(void)getDownloadProgress:(NSTimer*) timer
{
    WTNetworkTask* task = (WTNetworkTask*)[timer userInfo];
    self.progressView.progress = [task currentProgressForDownloadTask];
    
}

-(void)layoutSubviews
{
    if (self.msg.isGroupChatMessage) {
        [self.lbl_name setFrame:CGRectMake(INCOMINGCELL_NAME_X, INCOMINGCELL_NAME_Y, INCOMINGCELL_NAME_W, INCOMINGCELL_NAME_H)];
        self.lbl_name.hidden = FALSE;
        [self.lbl_name setText:[[Database buddyWithUserID:self.msg.groupChatSenderID] nickName]];
    }
    else
        self.lbl_name.hidden = TRUE;
    
    if (!isPlaying)
    {
        if (self.msg.isGroupChatMessage) {
            self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + INCOMINGCELL_NAME_H + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAY_INIT_L_H)/2, IMAGE_PLAY_INIT_L_W, IMAGE_PLAY_INIT_L_H);
        }
        else
            self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAY_INIT_L_H)/2, IMAGE_PLAY_INIT_L_W, IMAGE_PLAY_INIT_L_H);
        
        [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_INIT_L]];
    }
    else
    {
        
        
        if (self.msg.isGroupChatMessage) {
            self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + INCOMINGCELL_NAME_H + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAYING_L_H)/2, IMAGE_PLAYING_L_W, IMAGE_PLAYING_L_H);
        }
        else
            self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAYING_L_H)/2, IMAGE_PLAYING_L_W, IMAGE_PLAYING_L_H);
        
        if (times%3 == 0)
        {
            [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_ONE_L]];
        }
        else if(times%3 == 1)
        {
            [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_TWO_L]];
        }
        
        else if(times%3 == 2)
        {
            [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_THREE_L]];
        }

    }
    
    self.progressView.hidden = YES;
    
    
    self.btn_play.enabled = YES;
    
    if (self.msg.fileTransfering)
    {
        self.progressView.hidden = NO;
        self.btn_play.enabled = NO;
    }
    
    self.iv_status.hidden = TRUE;
    
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    NSString* status = [(NSDictionary*)[jp fragmentWithString: self.msg.messageContent] objectForKey:STATUS];
    
    if ([status isEqualToString:VoiceMessageNotReaded])
    {
        self.iv_status.hidden = FALSE;
    }
    
    // progress view.
    self.progressView.frame = CGRectMake(self.lbl_senttimeLabel.frame.origin.x, self.lbl_senttimeLabel.frame.origin.y - OUTGOINGCELL_PROGRESS_H - 10, OUTGOINGCELL_PROGRESS_W, OUTGOINGCELL_PROGRESS_H);
    
    
     self.btn_viewbuddy.frame = self.headImageView.frame;
    if (IS_IOS7) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
}


- (void)timeHandler:(VoiceMessagePlayer *)requestor
{

    times ++;
    
    if (times%3 == 0)
    {
        [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_ONE_L]];
    }
    else if(times%3 == 1)
    {
        [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_TWO_L]];
    }
    
    else if(times%3 == 2)
    {
        [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_THREE_L]];
    }
    
    if (times > self.totalLength) {
       self.lbl_duration.text = [TimeHelper getTimeFromSeconds:self.totalLength];
    }
    else
        self.lbl_duration.text = [TimeHelper getTimeFromSeconds:times];
}


-(void)playRecord
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
        
        [VoiceMessagePlayer sharedInstance].filepath = [NSFileManager absolutePathForFileInDocumentFolder:self.msg.pathOfMultimedia] ;  // contains the extension
        
        [[VoiceMessagePlayer sharedInstance] playVoiceMessage];
        
    }
    
    
}

-(void)didStopPlayingVoice:(VoiceMessagePlayer *)requestor
{
    
    times = 0;
    
    self.lbl_duration.text = [TimeHelper getTimeFromSeconds:self.totalLength];
    
    isPlaying = FALSE;
    
    [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_INIT_L]];
    
//    self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAY_INIT_L_H)/2, IMAGE_PLAY_INIT_L_W, IMAGE_PLAY_INIT_L_H);
    if (self.msg.isGroupChatMessage) {
        self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + INCOMINGCELL_NAME_H + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAY_INIT_L_H )/2, IMAGE_PLAY_INIT_L_W, IMAGE_PLAY_INIT_L_H);
    }
    else
        self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAY_INIT_L_H)/2, IMAGE_PLAY_INIT_L_W, IMAGE_PLAY_INIT_L_H);


}
-(void)willStartToPlayVoice:(VoiceMessagePlayer *)requestor
{
    times = 0;
    isPlaying = TRUE;
    
    [self.iv_playing setImage:[PublicFunctions imageNamedWithNoPngExtension:IMAGE_PLAY_ONE_L]];
    
 //   self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAYING_L_H)/2, IMAGE_PLAYING_L_W, IMAGE_PLAYING_L_H);
    if (self.msg.isGroupChatMessage) {
        self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + INCOMINGCELL_NAME_H + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAYING_L_H)/2, IMAGE_PLAYING_L_W, IMAGE_PLAYING_L_H);
    }
    else
        self.iv_playing.frame = CGRectMake(INCOMINGCELL_BG_X + IMAGE_PLAY_OFFSET_L_X,  INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + (DEFAULT_VOICECELL_BG_H - BG_TAIL_HEIGHT - IMAGE_PLAYING_L_H)/2, IMAGE_PLAYING_L_W, IMAGE_PLAYING_L_H);


}

-(void)viewBuddy
{
    Buddy* buddy;
    if (self.msg.isGroupChatMessage) {
        buddy = [Database buddyWithUserID:self.msg.groupChatSenderID];
        
        
    }
    else{
        buddy = [Database buddyWithUserID:self.msg.chatUserName];
    }
    
    
        ContactInfoViewController *contactInfoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
        contactInfoViewController.buddy = buddy;
        
        if (buddy.isFriend) {
            contactInfoViewController.contact_type = CONTACT_FRIEND;
        }
        else
            contactInfoViewController.contact_type = CONTACT_STRANGER;
        
        [[(MsgComposerVC*)self.parent navigationController] pushViewController:contactInfoViewController animated:YES];
        [contactInfoViewController release];
        
    
}

-(void)dealloc
{
 [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.parent = nil;
    self.msg = nil;
    
    self.iv_bg = nil;
    self.iv_playing = nil;
    self.iv_status = nil;
    self.btn_play = nil;
    self.lbl_senttimeLabel = nil;
    self.lbl_name = nil;
    self.lbl_duration = nil;
    
   self.progressView = nil;
    
      self.btn_viewbuddy = nil;
    [_headImageView release],_headImageView = nil;
    [super dealloc];
}


@end
