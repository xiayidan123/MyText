//
//  PicVoiceMsgPreview
//  omim
//
//  Created by coca on 2013/02/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "PicVoiceMsgView.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "Colors.h"
#import "WTHeader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PicVoiceMsgProgressView.h"
#import "PDColoredProgressView.h"
#import "GHNSData+Base64.h"
#import "Base64.h"


@interface PicVoiceMsgView (){
    int seconds;
    int totalseconds;
}
@property (retain, nonatomic) IBOutlet UIImageView *iv_background;
@property (retain, nonatomic) IBOutlet UIImageView *iv_recordPlay;
@property (retain, nonatomic) IBOutlet UILabel     *lbl_recordDuration;
@property (retain, nonatomic) IBOutlet UIView      *uv_record;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *uv_indicator;

@property (nonatomic,retain) AVAudioPlayer * recordPlayer;
@property (nonatomic,retain) NSTimer       * timer;
@property (nonatomic,retain) PicVoiceMsgProgressView* progressView;

@property (assign) BOOL hasRecord;
@property (assign) BOOL hasPhoto;
@property (assign) BOOL playingRecord;

@property (assign) BOOL downloadingPhoto;
@property (assign) BOOL downloadingRecord;


@property (nonatomic,retain ) NSString * photofilename;
@property (nonatomic,retain ) NSString * audiofilename;
@property (nonatomic,retain ) NSString * audiofilepath;
@property (nonatomic, retain) NSString * textMsg;


@end


@implementation PicVoiceMsgView
@synthesize iv_background;
@synthesize uv_record;
@synthesize lbl_recordDuration;
@synthesize iv_recordPlay;
@synthesize msg;

-(void)configNav{
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Pic-Voice Msg",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];



}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configNav];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    uv_record.hidden = YES;
}


-(void)checkAndDownloadFile{
    if (self.msg==nil) {
        return;
    }
    
    msg.messageContent=[msg.messageContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [Database updateChatMessage:msg];
    
    
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    self.photofilename = [(NSDictionary*)[jp fragmentWithString: self.msg.messageContent] objectForKey:WT_PATH_OF_THE_ORIGINAL_FILE_IN_SERVER];
    self.audiofilename = [(NSDictionary*)[jp fragmentWithString: self.msg.messageContent] objectForKey:@"audio_pathoffileincloud"];
    NSString* strDuration =  [(NSDictionary*)[jp fragmentWithString: self.msg.messageContent] objectForKey:@"duration"];

    if (strDuration) {
        totalseconds = [strDuration intValue];
    }

    
    self.textMsg = [(NSDictionary*)[jp fragmentWithString: self.msg.messageContent] objectForKey:@"text"];
    
    if (self.textMsg){
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, iv_background.frame.origin.y+ iv_background.frame.size.height + 10 , self.view.bounds.size.width, 100)];
        
        NSData *data =[Base64 decodeString:self.textMsg];
        self.textMsg = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        textView.text = self.textMsg ;
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.font = [UIFont systemFontOfSize:20];
        textView.textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1];
        [self.view addSubview:textView];
        [textView release];
    }

    if(![NSString isEmptyString:self.photofilename]){
        self.hasPhoto = YES;
        
        if (self.msg.pathOfMultimedia == nil || ![NSFileManager mediafileExistedAtPath:self.msg.pathOfMultimedia] ){
            if(PRINT_LOG)NSLog(@"photofilename not exist,download now");
            [WowTalkWebServerIF downloadMediaMessageOriginalFile:self.msg withCallback:@selector(didDownloadOriginalPhotoFile:) withObserver:self];
            self.downloadingPhoto = YES;
            [self.uv_indicator startAnimating];
        }

    }
    
    if(![NSString isEmptyString:self.audiofilename]){
        self.hasRecord=YES;
        
        self.audiofilepath = [NSFileManager absolutePathForFileInDocumentFolder:[MessageHelper localRecordFileForMessage:self.msg]];
        if(PRINT_LOG)NSLog(@"audiofilepath=%@",self.audiofilepath);
        if(self.audiofilepath && ![NSFileManager mediafileExistedAtPath:self.audiofilepath]){
            if(PRINT_LOG)NSLog(@"audiofilename not exist,download now");
            [WowTalkWebServerIF downloadPicVoiceFile:self.msg withCallback:@selector(didDownloadPicVoiceFile:) withObserver:self];
            self.downloadingRecord = YES;
            [self.uv_indicator startAnimating];
        }
    }
}

-(void)didDownloadOriginalPhotoFile:(NSNotification*) notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        self.msg = [[notif userInfo] valueForKey:WT_MESSAGE];
        
    }
    
    self.downloadingPhoto = NO;

    [self checkAndRefreshDisplay];

}

-(void)didDownloadPicVoiceFile:(NSNotification*) notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
      //nothing
    }

    self.downloadingRecord = NO;

    [self checkAndRefreshDisplay];


}

-(void)checkAndRefreshDisplay{
    
    NSLog(@"checkAndRefreshDisplay called");
    
    if (!self.downloadingPhoto && !self.downloadingRecord) {
        [self.uv_indicator stopAnimating];
    }
    
    
    if(self.hasPhoto){
        if (self.msg.pathOfMultimedia != nil &&[NSFileManager mediafileExistedAtPath:self.msg.pathOfMultimedia] ){
            NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:self.msg.pathOfMultimedia];
            [iv_background setImage:[UIImage imageWithContentsOfFile:filePath]];
        }
        
    }
    
    if(self.hasRecord && !self.playingRecord){
        if(self.audiofilepath && [NSFileManager mediafileExistedAtPath:self.audiofilepath]){
            
            
             uv_record.hidden = NO;
             self.progressView = [[[PicVoiceMsgProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
             self.progressView.frame = CGRectMake(-10, 0, uv_record.frame.size.width+10,  uv_record.frame.size.height);
             
             [self.uv_record addSubview: self.progressView];
             [self.uv_record bringSubviewToFront:iv_recordPlay];
             [self.uv_record bringSubviewToFront:lbl_recordDuration];
             
             [self.view bringSubviewToFront:uv_record];
            
            
            
            [self startPlayRecord];
        }
    }
    
    
}




- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkAndDownloadFile];
    [self checkAndRefreshDisplay];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.recordPlayer stop];
}


- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [iv_background release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setIv_background:nil];
    [super viewDidUnload];
}


#pragma mark - Methods

-(void)startPlayRecord{
    if (!self.audiofilepath || totalseconds==0) {
        return;
    }
    
    self.playingRecord = YES;
    NSURL* url = [NSURL fileURLWithPath:self.audiofilepath];

//    /Users/macbookair/Library/Developer/CoreSimulator/Devices/9AB65473-7CD8-481C-B314-387780CF1668/data/Containers/Data/Application/C0086F0F-B0FE-44A1-812E-AC7443D63654/Documents/multimedia/e5a9ff23-430c-4cf3-ba67-100b6754aafe/e5a9ff23-430c-4cf3-ba67-100b6754aafe_5c78cdd0-43c3-4617-aa9e-283f3da95403.m4a.aac
//    NSURL* url = [NSURL fileURLWithPath:@"/Users/macbookair/Library/Developer/CoreSimulator/Devices/9AB65473-7CD8-481C-B314-387780CF1668/data/Containers/Data/Application/C0086F0F-B0FE-44A1-812E-AC7443D63654/Documents/multimedia/e5a9ff23-430c-4cf3-ba67-100b6754aafe/e5a9ff23-430c-4cf3-ba67-100b6754aafe_5c78cdd0-43c3-4617-aa9e-283f3da95403.m4a"];
//
    NSError* err;
//    self.recordPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err] autorelease];
    self.recordPlayer = [[[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfURL:url] error:&err] autorelease];
    if (self.recordPlayer == nil) {
        [WTHelper WTLogError:err];
    }
    
    [self.recordPlayer setNumberOfLoops:0];
    self.recordPlayer.delegate = self;
    [self.recordPlayer prepareToPlay];
    [self.recordPlayer play];
  
    
    seconds= 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changePlayTime:) userInfo:nil repeats:YES];
    [self.timer fire];
    
}


-(void)changePlayTime:(NSTimer*)timer
{
    seconds=self.recordPlayer.currentTime;
    if (seconds > totalseconds) {
        seconds=totalseconds;
    }
    [self setPlayTime:seconds];
    
    float prograss = (float) seconds/totalseconds;
    self.progressView.progress = prograss;
    [self.progressView setNeedsLayout];
    
    if(seconds/totalseconds >0.3){
        [iv_recordPlay setImage:[UIImage imageNamed:@"play_right"]];
        [lbl_recordDuration setTextColor:[UIColor whiteColor]];
    }

}




-(void)setPlayTime:(int)secs{
    
    int min = secs /60 ;
    int leftseconds = secs %60;
    
    NSString* minstr = nil;
    if (min<10) {
        minstr = [NSString stringWithFormat:@"%d%d",0,min];
    }
    else{
        minstr = [NSString stringWithFormat:@"%d",min];
    }
    
    NSString* secstr = nil;
    if (leftseconds<10) {
        secstr = [NSString stringWithFormat:@"%d%d",0,leftseconds];
    }
    else
        secstr = [NSString stringWithFormat:@"%d",leftseconds];
    
    lbl_recordDuration.text = [NSString stringWithFormat:@"%@:%@",minstr,secstr];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    self.playingRecord = FALSE;
    [self.recordPlayer stop];
    
    [self setPlayTime:totalseconds];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }

    
}


@end
