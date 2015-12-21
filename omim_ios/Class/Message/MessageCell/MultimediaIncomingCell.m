//
//  MultimediaIncomingCell.m
//  omim
//
//  Created by coca on 12/09/26.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "MultimediaIncomingCell.h"
#import "GalleryViewController.h"

#import "PDColoredProgressView.h"
#import "WTHeader.h"
#import "Constants.h"

#import "PublicFunctions.h"
#import "MsgComposerVC.h"

#import "ContactInfoViewController.h"
#import "PicVoiceMsgView.h"

@interface MultimediaIncomingCell()



@end


@implementation MultimediaIncomingCell

@synthesize parent;
@synthesize iv_content,iv_bg;
@synthesize btn_view;
@synthesize lbl_name,lbl_senttimeLabel;
@synthesize msg = _msg;
//@synthesize vlpc = _vlpc;
@synthesize indexPath = _indexPath;
@synthesize progressView = _progressView;

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

-(void)viewThePhoto
{
    
    GalleryViewController* gvc = [[GalleryViewController alloc] init];
    gvc.isViewMessages = TRUE;
    gvc.arr_msgs = self.parent.arr_photomsgs;
    gvc.startpos = [self.parent.arr_photomsgs indexOfObject:self.msg];
    [self.parent.navigationController pushViewController:gvc animated:TRUE];
    [gvc release];
    
 //   vlpc.originalFilePath = [NSFileManager absolutePathForFileInDocumentFolder:self.msg.pathOfMultimedia];
 //   vlpc.parent = self.parent;
    
 //   [self.parent.navigationController pushViewController:vlpc animated:TRUE];
   
 //   [vlpc release];
}

-(void)watchTheMovie
{
    /*CustomMoviePlayerViewController* moviePlayer = [[CustomMoviePlayerViewController alloc] initWithPath:[NSFileManager absolutePathForFileInDocumentFolder: self.msg.pathOfMultimedia]] ;
     moviePlayer.delegate = self;
     
     // Show the movie player as modal
     [self.parent.navigationController presentModalViewController:moviePlayer animated:YES];
     
     //  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
     [moviePlayer setWantsFullScreenLayout:YES];
     //  }
     
     //  [moviePlayer setWantsFullScreenLayout:YES];
     
     // Prep and play the movie
     [moviePlayer readyPlayer];
     
     [moviePlayer release];*/
    
    
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

-(void)watchThePicVoice{
    
    PicVoiceMsgView* pvmv = [[PicVoiceMsgView alloc] init];
    pvmv.msg = self.msg;
    [self.parent.navigationController pushViewController:pvmv animated:NO];
    [pvmv release];
    
}


-(void)movieDidFinished:(CustomMoviePlayerViewController *)requestor
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
  
    //[self.parent.uv_barcontainer setHidden:NO];
    
    [self.parent.tb_messages reloadData];
    
}

-(IBAction)downloadMedia:(id)sender
{
    if([self.msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]){
        [self viewThePhoto];
    }
    else if ([self.msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]]){
        self.msg.fileTransfering = FALSE;
        if(![NSFileManager mediafileExistedAtPath:self.msg.pathOfMultimedia]){
            self.msg.fileTransfering = TRUE;
            self.btn_view.enabled = NO;
            self.progressView.hidden = NO;
            
            [WowTalkWebServerIF downloadMediaMessageOriginalFile:self.msg withCallback:@selector(didDownloadOriginalFile:) withObserver:nil];
            WTNetworkTask* task = [[WTNetworkTaskManager defaultManager] taskforMessage:self.msg];
            if (task.timer != nil || [task.timer isValid]) {
                [task.timer invalidate];
                task.timer= nil;
            }
            task.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(getDownloadProgress:) userInfo:task repeats:YES];
            [task.timer fire];
            
        }
        // has the file
        else{
            [self watchTheMovie];
        }
    }
    else  if([self.msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]]){
        [self watchThePicVoice];
    }
/*
    
    
    self.msg.fileTransfering = FALSE;
    
    if (![NSFileManager mediafileExistedAtPath:self.msg.pathOfThumbNail]){
        self.btn_view.enabled = NO;
        [WowTalkWebServerIF downloadMediaMessageThumbnail:self.msg withCallback:@selector(didDownloadThumbnail:) withObserver:nil];
        return;
    }
    
   */
}

-(void)getDownloadProgress:(NSTimer*) timer{
    WTNetworkTask* task = (WTNetworkTask*)[timer userInfo];
    self.progressView.progress = [task currentProgressForDownloadTask];
}

-(void)layoutSubviews{
    if (self.msg.isGroupChatMessage) {
        [self.lbl_name setFrame:CGRectMake(INCOMINGCELL_NAME_X, INCOMINGCELL_NAME_Y, INCOMINGCELL_NAME_W, INCOMINGCELL_NAME_H)];
        self.lbl_name.hidden = FALSE;
        [self.lbl_name setText:[[Database buddyWithUserID:self.msg.groupChatSenderID] nickName]];
    }
    else
        self.lbl_name.hidden = TRUE;
    
   
    // no thumbnail is downloaded due to the network problem.
    if(![NSFileManager mediafileExistedAtPath:self.msg.pathOfThumbNail])
    {
            if (self.msg.isGroupChatMessage) {
                self.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, DEFAULT_PHOTOCELL_BG_W + BG_TAIL_WIDTH, DEFAULT_PHOTOCELL_BG_H + INCOMINGCELL_NAME_H);
                
                self.iv_content.frame = CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X + BG_TAIL_WIDTH, INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y, DEFAULT_PHOTOCELL_BG_W-2*CHATCELL_CONTENT_THIN_OFFSET_X, DEFAULT_PHOTOCELL_BG_H - BG_TAIL_HEIGHT-2*CHATCELL_CONTENT_THIN_OFFSET_Y);
                
            }
            else{
                 self.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, DEFAULT_PHOTOCELL_BG_W + BG_TAIL_WIDTH, DEFAULT_PHOTOCELL_BG_H);
                    self.iv_content.frame = CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X+BG_TAIL_WIDTH, INCOMINGCELL_BG_Y + BG_TAIL_HEIGHT+CHATCELL_CONTENT_THIN_OFFSET_Y, DEFAULT_PHOTOCELL_BG_W-2*CHATCELL_CONTENT_THIN_OFFSET_X, DEFAULT_PHOTOCELL_BG_H - BG_TAIL_HEIGHT-2*CHATCELL_CONTENT_THIN_OFFSET_Y);
                
            }
        
        // download the thumbnail.
        [WowTalkWebServerIF downloadMediaMessageThumbnail:self.msg withCallback:@selector(didDownloadThumbnail:) withObserver:nil];
        
        [self.iv_content setImage:[PublicFunctions imageNamedWithNoPngExtension:INCOMINGCELL_CONTENT_DEFAULT]];
        [self.btn_view setImage:nil forState:UIControlStateNormal];
        
    }
    // has the thumbnail downloaded already
    else
    {
        UIImage* image = [UIImage imageWithContentsOfFile:[NSFileManager absolutePathForFileInDocumentFolder:self.msg.pathOfThumbNail]];
        CGFloat w = image.size.width * MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR;
        CGFloat h = image.size.height * MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR;
        
        if (self.msg.isGroupChatMessage) {
            self.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, w+2*CHATCELL_CONTENT_THIN_OFFSET_X + BG_TAIL_WIDTH, h + CHATCELL_CONTENT_THIN_OFFSET_Y + BG_TAIL_HEIGHT + INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y);
            
            self.iv_content.frame = CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X + BG_TAIL_WIDTH, INCOMINGCELL_BG_Y+BG_TAIL_HEIGHT+ INCOMINGCELL_NAME_H + INCOMINGCELL_NAME_MSG_GAP_Y, w, h);
            
        }
        else{
            self.iv_bg.frame = CGRectMake(INCOMINGCELL_BG_X, INCOMINGCELL_BG_Y, w+2*CHATCELL_CONTENT_THIN_OFFSET_X + BG_TAIL_WIDTH, h + 2*CHATCELL_CONTENT_THIN_OFFSET_Y + BG_TAIL_HEIGHT);
            
            self.iv_content.frame = CGRectMake(INCOMINGCELL_BG_X+CHATCELL_CONTENT_THIN_OFFSET_X + BG_TAIL_WIDTH, INCOMINGCELL_BG_Y+BG_TAIL_HEIGHT+CHATCELL_CONTENT_THIN_OFFSET_Y, w, h);

            
        }
    
        [self.iv_content setImage:image];
        
        if([self.msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]])
        {
            [self.btn_view setImage:nil forState:UIControlStateNormal];
        }
        else if([self.msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
        {
            [self.btn_view setImage:[PublicFunctions imageNamedWithNoPngExtension:PLAY_VIDEO] forState:UIControlStateNormal];
        }
        else if([self.msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]])
        {
            [self.btn_view setImage:[PublicFunctions imageNamedWithNoPngExtension:@"messages_preview_icon_left_green"] forState:UIControlStateNormal];
        }

        
    
        
    }

    [self.contentView setFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.iv_bg.frame.origin.y +self.iv_bg.frame.size.height+INCOMINGCELL_OFFSET_Y)];
    
    self.lbl_senttimeLabel.frame = CGRectMake(INCOMINGCELL_BG_X+self.iv_bg.frame.size.width+INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_X, INCOMINGCELL_BG_Y + self.iv_bg.frame.size.height-INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_Y - SENTTIMELABEL_H, SENTTIMELABEL_W, SENTTIMELABEL_H);
    
    self.progressView.frame = CGRectMake(self.lbl_senttimeLabel.frame.origin.x, self.lbl_senttimeLabel.frame.origin.y - OUTGOINGCELL_PROGRESS_H - 10, OUTGOINGCELL_PROGRESS_W, OUTGOINGCELL_PROGRESS_H);
    
    CGRect frame = self.iv_bg.frame;
    
    self.btn_view.frame =frame;
    
    self.btn_view.enabled = YES;
    
    
    self.progressView.hidden = YES;
    
    if (self.msg.fileTransfering)
    {
        self.progressView.hidden = NO;
        self.btn_view.enabled = NO;
    }
    
     self.btn_viewbuddy.frame = self.headImageView.frame;
    
    
    if (IS_IOS7) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    
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
    self.indexPath = nil;
    self.iv_content = nil;
    self.iv_bg = nil;
    self.btn_view = nil;
    self.lbl_name = nil;
    self.lbl_senttimeLabel = nil;
      self.btn_viewbuddy = nil;
    
    [_headImageView release],_headImageView = nil;
    [super dealloc];
}

@end
