//
//  AVRecorderVC.m
//  omim
//
//  Created by coca on 12/09/14.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "AVRecorderVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "MsgComposerVC.h"
#import "PublicFunctions.h"
#import "WTHeader.h"


@implementation AVRecorderVC

@synthesize timer,recorder;
@synthesize uv_container;
@synthesize btn_play,btn_send,btn_pause,btn_cancel;
@synthesize lbl_timer;
@synthesize iv_mic;
@synthesize recordSetting,fullFilePath,relativeFilePath;
@synthesize totalSeconds;
@synthesize lbl_send,lbl_cancel,lbl_play_pause;
@synthesize recordPlayer;
//@synthesize directoryPath;
@synthesize dirName;
@synthesize uv_shadow;

@synthesize iv_bg;

@synthesize delegate;
@synthesize parent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
  //  if (!self.isViewLoaded && !self.view.window) {
 /*       self.recordSetting = nil;
        self.timer = nil;
        self.recorder = nil;
        self.parent = nil;
        self.recordPlayer = nil;
        self.dirName = nil;
   */
  //  }
}

#pragma  mark - record method
-(NSString*) getTimeFromSeconds
{
    int minute = self.totalSeconds/60;
    int second = self.totalSeconds - minute *60;
    
    return [NSString stringWithFormat:@"%02d : %02d", minute, second];
}

- (void) handleTimer
{
	self.totalSeconds ++;
    if (self.totalSeconds <= 49){
       self.lbl_timer.text = [self getTimeFromSeconds];
    }else if (self.totalSeconds > 50 && self.totalSeconds <= 59){
        self.lbl_timer.text = [NSString stringWithFormat:@"倒计时 %d秒",60 - self.totalSeconds];
    }else if (self.totalSeconds > 60){
        [self stopRecording];
    }
}

-(IBAction)sendRecord:(id)sender
{
    if (self.recordPlayer != nil && self.recordPlayer.isPlaying) 
    {
        [self.recordPlayer stop];
    }

    [self.delegate sendRecord:self];
    
    self.relativeFilePath = [NSFileManager randomRelativeFilePathInDir:self.dirName ForFileExtension:AAC];
    self.fullFilePath = [NSFileManager absolutePathForFileInDocumentFolder:self.relativeFilePath];
    
    self.view.hidden = YES;  // show the parent view;
}

-(IBAction)playSound:(id)sender
{
    self.btn_play.hidden = YES;
    self.btn_pause.hidden = NO;
    self.lbl_play_pause.text = NSLocalizedString(@"Stop", nil);
    
    self.recordPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.fullFilePath] error:NULL] autorelease];
    self.recordPlayer.delegate = self;
    [self.recordPlayer setNumberOfLoops:0];
 
    [self.recordPlayer prepareToPlay];
    [self.recordPlayer play];
}

-(IBAction)stopPlaying:(id)sender
{
    self.btn_play.hidden = NO;
    self.btn_pause.hidden = YES;
    self.lbl_play_pause.text = NSLocalizedString(@"Replay", nil);
    
    [self.recordPlayer stop];
}

-(IBAction)cancalPlaying:(id)sender
{
    if (self.recordPlayer != nil && self.recordPlayer.isPlaying)
    {
        [self.recordPlayer stop];
    }
    
     // remove not needed record file;
    [NSFileManager removeFileAtAbsoulutePath:self.fullFilePath];
    
    self.view.hidden = YES;
}

-(void)dismissThisView
{
    if (self.recordPlayer != nil && self.recordPlayer.isPlaying) 
    {
        [self.recordPlayer stop];
    }
    
    // remove not needed record file;
    [NSFileManager removeFileAtAbsoulutePath:self.fullFilePath];
    
    [self.view removeFromSuperview];
}

-(void)fHideErrorInfo
{
    self.view.hidden = YES;
    [self.parent.btn_record setEnabled:YES];
}

-(void)startRecording
{

    
    self.parent.lbl_recorddesc.text = NSLocalizedString(@"Release to stop", nil);
    self.parent.lbl_recorddesc.alpha = 0.8;
    self.parent.btn_record.alpha = 0.8;
    
    [self.iv_mic setFrame:CGRectMake(30, 24, 23, 42)];
    [self.iv_mic setImage:[PublicFunctions imageNamedWithNoPngExtension:RECORDING]];
    
    self.uv_container.hidden = NO;

    self.iv_mic.hidden = NO;
    self.lbl_timer.hidden = NO;
    
    self.btn_play.hidden = YES;
    self.btn_pause.hidden = YES;
    self.btn_send.hidden = YES;
    self.btn_cancel.hidden = YES;
    self.lbl_send.hidden = YES;
    self.lbl_play_pause.hidden = YES;
    self.lbl_cancel.hidden = YES;
    
    self.totalSeconds = 0;
    
    self.lbl_timer.textColor = [Colors whiteColor];
    self.lbl_timer.text= @"00 : 00";
    
    if (self.recordPlayer != nil && self.recordPlayer.isPlaying) 
    {
        [self.recordPlayer stop];
    }
    
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	if(err){
        return;
	}
	[audioSession setActive:YES error:&err];
	err = nil;
	if(err){
        return;
	}
	
	self.recordSetting = [[[NSMutableDictionary alloc] init] autorelease];
	
	// We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
	[self.recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    
	// We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
	[self.recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
	
	// We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
	[self.recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	
	// These settings are used if we are using kAudioFormatLinearPCM format
	//[recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	//[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	//[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	
	NSURL *url = [NSURL fileURLWithPath:self.fullFilePath];
	
	err = nil;
	
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
	if(audioData)
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[url path] error:&err];
	}
	
	err = nil;
	self.recorder = [[[ AVAudioRecorder alloc] initWithURL:url settings:self.recordSetting error:&err] autorelease];
	if(!self.recorder){
    //    NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
	}
	
	//prepare to record
	[self.recorder setDelegate:self];
	[self.recorder prepareToRecord];

	self.recorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.inputAvailable;
	if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
        return;
	}
	
	// start recording
	[self.recorder recordForDuration:(NSTimeInterval) 120];
	

	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    
}


-(void)stopRecording
{
    
    if (self.totalSeconds < 2) 
    {
        [self.parent.btn_record setEnabled:NO];
        
        [self.iv_mic setFrame:CGRectMake(18, 23, 42, 43)];
        [self.iv_mic setImage:[PublicFunctions imageNamedWithNoPngExtension:NOTICE]];
      
        self.iv_mic.hidden = FALSE;
        self.lbl_timer.text = NSLocalizedString(@"Message is too short, please record it again", nil);

      
        self.parent.lbl_recorddesc.text = NSLocalizedString(@"Press and talk", nil);
        self.parent.lbl_recorddesc.alpha = 1.0;
        self.parent.btn_record.alpha = 1.0;
    
        
        [self.recorder stop];
        
        [self.timer invalidate];
        
        [self performSelector:@selector(fHideErrorInfo) withObject:self afterDelay:0.7];
        
        return;
    }
    
    self.parent.lbl_recorddesc.text = NSLocalizedString(@"Press and talk", nil);
    self.parent.lbl_recorddesc.alpha = 1.0;
    self.parent.btn_record.alpha = 1.0;
    
    [self.recorder stop];
	
	[self.timer invalidate];
    
    self.iv_mic.hidden = YES;
    self.lbl_timer.hidden = YES;
    self.btn_play.hidden = NO;
    self.btn_send.hidden = NO;
    self.btn_cancel.hidden = NO;
    self.lbl_play_pause.text = NSLocalizedString(@"Replay", nil);
    
    self.lbl_send.hidden = NO;
    self.lbl_play_pause.hidden = NO;
    self.lbl_cancel.hidden = NO;
    
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
//	NSLog (@"audioRecorderDidFinishRecording:successfully:");
    

    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    self.btn_play.hidden = NO;
    self.btn_pause.hidden = YES;
    self.lbl_play_pause.text = NSLocalizedString(@"Replay", nil);
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = TRUE;
    
    // initial the containers
    self.uv_container.backgroundColor = [UIColor clearColor];
   
    
    self.uv_container.alpha = 1.0;
    [self.iv_bg setFrame:CGRectMake(0, 0, 208, 108)];
    [self.iv_bg setImage:[PublicFunctions imageNamedWithNoPngExtension:BG_RECORD_POPUP]];
    
    
    self.lbl_play_pause.text = NSLocalizedString(@"Replay", nil);
    self.lbl_play_pause.textColor = [Colors whiteColor];
    
    self.lbl_send.text = NSLocalizedString(@"Send", nil);
     self.lbl_send.textColor = [Colors whiteColor];
    
    self.lbl_cancel.text = NSLocalizedString(@"Cancel", nil);
    self.lbl_cancel.textColor = [Colors whiteColor];
    
    
    [self.btn_cancel setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:CLOSERECORD] forState:UIControlStateNormal];
    [self.btn_pause setBackgroundImage:[UIImage imageNamed:@"sms_voice_stop.png"] forState:UIControlStateNormal];
    [self.btn_play setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:PLAYRECORD] forState:UIControlStateNormal];
    [self.btn_send setBackgroundImage:[PublicFunctions imageNamedWithNoPngExtension:SENDRECORD] forState:UIControlStateNormal];
    
     [self.lbl_timer setFrame:CGRectMake(65, 24, 100, 42)];
}



-(void)dealloc
{
    
    self.uv_container = nil;
    self.uv_shadow = nil;
    self.lbl_send = nil;
    self.lbl_timer = nil;
    
    self.iv_mic = nil;
    self.lbl_play_pause = nil;
    self.lbl_cancel = nil;
    
    self.btn_play = nil;
    self.btn_pause = nil;
    self.btn_send = nil;
    self.btn_cancel = nil;
    
    self.parent = nil;
    self.dirName = nil;
    
    self.recorder = nil;
    self.recordPlayer = nil;
    self.recordSetting = nil;

    self.fullFilePath = nil;
    self.relativeFilePath = nil;
    self.timer = nil;
    
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
