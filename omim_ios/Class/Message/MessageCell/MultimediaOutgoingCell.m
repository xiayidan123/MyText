//
//  MultimediaOutgoingCell.m
//  omim
//
//  Created by coca on 12/09/26.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "MultimediaOutgoingCell.h"
#import <MediaPlayer/MediaPlayer.h>

#import "GalleryViewController.h"
#import "WowTalkVoipIF.h"
#import "PDColoredProgressView.h"

#import "WTHeader.h"
#import "Constants.h"
#import "PublicFunctions.h"

#import "MsgComposerVC.h"
#import "PicVoiceMsgView.h"

@implementation MultimediaOutgoingCell

@synthesize lbl_sentlabel,lbl_senttimeLabel;
@synthesize btn_view;
@synthesize iv_bg,iv_content;
@synthesize progressView = _progressView;
@synthesize msg=_msg;
@synthesize btn_resend;
@synthesize parent=_parent;

@synthesize indexPath = _indexPath;
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

-(void)resendPhotoMessage
{
    self.msg.fileTransfering = FALSE;
    
    [self.parent.txtView_Input resignFirstResponder];
    
    if ([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_FILE_UPLOADINIT]])
    {
        NSDictionary* dictonary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"", nil] forKeys:[NSArray arrayWithObjects:PATH_OF_THE_THUMBNAIL_IN_SERVER, PATH_OF_THE_ORIGINAL_FILE_IN_SERVER, nil]];
        
        SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
        
        self.msg.messageContent = [jw stringWithFragment:dictonary];
        
        self.msg.fileTransfering = TRUE;
        self.progressView.hidden = NO;
        self.btn_resend.hidden = YES;
        

        [WowTalkWebServerIF uploadMediaMessageOriginalFile:self.msg withCallback:@selector(didUploadOriginalFile:) withObserver:nil];
        
        WTNetworkTask* filetask= [[WTNetworkTaskManager defaultManager] taskforMessage:self.msg];
        if (filetask.timer != nil || [filetask.timer isValid]) {
            [filetask.timer invalidate];
            filetask.timer= nil;
        }
        filetask.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(getUploadProgress:) userInfo:filetask repeats:YES];
        [filetask.timer fire];

        [WowTalkWebServerIF uploadMediaMessageThumbnail:self.msg withCallback:@selector(didUploadThumbnail:) withObserver:nil];
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
        
    
    UIImage* thumbnail = [[[UIImage alloc] initWithContentsOfFile:[NSFileManager absolutePathForFileInDocumentFolder:self.msg.pathOfThumbNail]] autorelease];
    CGFloat height = thumbnail.size.height * MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR + 2 * CHATCELL_CONTENT_THIN_OFFSET_Y;
    CGFloat width = thumbnail.size.width * MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR +  2 * CHATCELL_CONTENT_THIN_OFFSET_X;
    
    CGFloat screenWidth = [UISize screenWidth];
   
    

    // background
self.iv_bg.frame = CGRectMake( screenWidth- OUTGOINGCELL_BG_DIST_R-width, 0, width + BG_TAIL_WIDTH, height+ BG_TAIL_HEIGHT);
    
    
    
    // content view frame.
   // self.contentView.frame = CGRectMake(0, 0, screenWidth, height+ CHATCELL_CONTENT_THIN_OFFSET_Y*2+ OUTGOINGCELL_OFFSET_Y);
self.contentView.frame = CGRectMake(0, 0, screenWidth, height+  OUTGOINGCELL_OFFSET_Y);
   // [self.contentView setFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.iv_bg.frame.origin.y +self.iv_bg.frame.size.height+ OUTGOINGCELL_OFFSET_Y)];
    
    
    // content image.
    self.iv_content.frame = CGRectMake(self.iv_bg.frame.origin.x + CHATCELL_CONTENT_THIN_OFFSET_X, CHATCELL_CONTENT_THIN_OFFSET_Y, thumbnail.size.width*MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR, thumbnail.size.height*MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR);
    [self.iv_content setImage:thumbnail];
    
    
    // progress view.
    self.progressView.frame = CGRectMake(self.iv_bg.frame.origin.x - OUTGOINGCELL_PROGRESS_W - OUTGOINGCELL_PROGRESS_OFFSET_X , height/2, OUTGOINGCELL_PROGRESS_W, OUTGOINGCELL_PROGRESS_H);
    
    // btn_view
    self.btn_view.frame = self.iv_bg.frame;
    
    // btn_resend
    self.btn_resend.frame =  CGRectMake(self.iv_bg.frame.origin.x - OUTGOINGCELL_FAILMARK_BG_OFFSET_X-OUTGOINGCELL_FAILMARK_W, (height-OUTGOINGCELL_FAILMARK_H)/2.0 , OUTGOINGCELL_FAILMARK_W, OUTGOINGCELL_FAILMARK_H);

    self.progressView.hidden = YES;
    self.lbl_sentlabel.hidden = YES;
    self.lbl_senttimeLabel.hidden = YES;
     self.btn_resend.hidden = YES;

    [self.ua_indicator stopAnimating];
    [self.ua_indicator setHidden:TRUE];

    if ([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_NOTSENT]])
    {
        self.progressView.hidden = YES;
        
        self.btn_resend.hidden = NO;

        self.lbl_sentlabel.text = @"";
        
    }
    
    // upload failed.
    else if([[self.msg sentStatus] isEqualToString:[ChatMessage SENTSTATUS_FILE_UPLOADINIT]])
    {
        
        self.progressView.hidden = YES;
        self.btn_resend.hidden = NO;

    }
    else if ([self.msg.sentStatus isEqualToString:[ChatMessage SENTSTATUS_IN_PROCESS]]){
        [self.ua_indicator setFrame:CGRectMake(self.iv_bg.frame.origin.x - OUTGOINGCELL_INDICATOR_OFFSET_X-OUTGOINGCELL_INDICATOR_W, (self.iv_bg.frame.origin.y + self.iv_bg.frame.size.height - OUTGOINGCELL_INDICATOR_H)/2.0, OUTGOINGCELL_INDICATOR_W, OUTGOINGCELL_INDICATOR_H)];
        [self.ua_indicator setHidden:false];
        [self.ua_indicator startAnimating];
    }
    // send ,reached, read status
    else
    {
        
       self.progressView.hidden = YES;
        self.btn_resend.hidden = YES;
        
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
        
        self.lbl_senttimeLabel.frame = CGRectMake(self.iv_bg.frame.origin.x -OUTGOINGCELL_SENTTIMELABEL_BG_OFFSET_X -SENTTIMELABEL_W, OUTGOINGCELL_SENTTIMELABEL_Y , SENTTIMELABEL_W, SENTTIMELABEL_H);
        self.lbl_sentlabel.frame = CGRectMake(self.iv_bg.frame.origin.x - OUTGOINGCELL_STATUS_BG_OFFSET_X -OUTGOINGCELL_STATUS_W , OUTGOINGCELL_STATUS_Y , OUTGOINGCELL_STATUS_W , OUTGOINGCELL_STATUS_H);
        
    }
    
//    if([self.msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]])
//    {
//        [self.btn_view setImage:nil forState:UIControlStateNormal];
//    }
//    else if([self.msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
//    {
//        [self.btn_view setImage:[PublicFunctions imageNamedWithNoPngExtension:PLAY_VIDEO] forState:UIControlStateNormal];
//    }
//    else if([self.msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]])
//    {
//        [self.btn_view setImage:[PublicFunctions imageNamedWithNoPngExtension:@"messages_preview_icon_left_green"] forState:UIControlStateNormal];
//    }

    
    
    // handle the progress view.
    // in the queue
    if (self.msg.fileTransfering){
        self.progressView.hidden = NO;
        self.btn_resend.hidden = YES;
    }
    
    if (IS_IOS7) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
}


-(void)viewThePhoto
{
    GalleryViewController* gvc = [[GalleryViewController alloc] init];
    gvc.isViewMessages = TRUE;
    gvc.arr_msgs = self.parent.arr_photomsgs;
    gvc.startpos = [self.parent.arr_photomsgs indexOfObject:self.msg];
    [self.parent.navigationController pushViewController:gvc animated:TRUE];
    [gvc release];

}


-(void)watchThePicVoice{
    
    PicVoiceMsgView* pvmv = [[PicVoiceMsgView alloc] init];
    pvmv.msg = self.msg;
    [self.parent.navigationController pushViewController:pvmv animated:NO];
    [pvmv release];

}


-(void)watchTheMovie
{
    
    
    
    @try
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        NSURL* url = [NSURL fileURLWithPath:[NSFileManager absolutePathForFileInDocumentFolder: self.msg.pathOfMultimedia]];
        if(!url)return;
        MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
        [moviePlayerViewController.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        [moviePlayerViewController.moviePlayer setShouldAutoplay:YES];
        [moviePlayerViewController.moviePlayer setFullscreen:NO animated:YES];
        [moviePlayerViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [moviePlayerViewController.moviePlayer setScalingMode:MPMovieScalingModeNone];
        //[moviePlayerViewController.moviePlayer setUseApplicationAudioSession:NO];
        // Register to receive a notification when the movie has finished playing.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinished:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:moviePlayerViewController];
        
        // Register to receive a notification when the movie has finished playing.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinished:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayerViewController];
        
        [self.parent.navigationController presentViewController:moviePlayerViewController animated:YES completion:nil];
        moviePlayerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [moviePlayerViewController release];
        [pool release];
    }
    @catch (NSException *exception) {
        NSLog(@"watchTheMovie failed:%@",exception.description);
    }
    
    
    
}






-(void)movieDidFinished:(CustomMoviePlayerViewController *)requestor
{

        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
      //  [self.parent.uv_barcontainer setHidden:NO];
        
        [self.parent.tb_messages reloadData];

    
}


-(void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.parent = nil;
    self.msg = nil;
    

    self.indexPath = nil;
    
    self.btn_view = nil;
    self.btn_resend = nil;
    self.iv_bg = nil;
    self.iv_content = nil;
    self.lbl_senttimeLabel = nil;
    self.lbl_sentlabel = nil;
    
    self.progressView = nil;
    
    [super dealloc];
}


@end
