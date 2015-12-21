/* VideoViewController.m

 *
 *  Created by eki-chin on 11/12/13
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */  

#import "VideoCallVC.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "WowTalkVoipIF.h"
#import "CallUIHeader.h"

#import "WTHeader.h"

@implementation VideoCallVC
@synthesize mPortrait;
@synthesize mDisplay;
@synthesize mPreview;
@synthesize mMute;
@synthesize mHangUp;
@synthesize mCamSwitch;
@synthesize uv_Preview,uv_operationbar;
@synthesize btn_showPreview;
@synthesize pLblCallDuration;



-(IBAction)fEndCall{
    [[AppDelegate sharedAppDelegate].myCallProcessVC fEndCall];
}

-(IBAction)fEndVideo{
    [[AppDelegate sharedAppDelegate].myCallProcessVC fEndVideo];
}

-(void)togglePreview
{
    if (_isPreviewShown) 
    {
        if(self.interfaceOrientation == UIInterfaceOrientationPortrait)
        {
            CGRect btnframe = self.btn_showPreview.frame;
       //     CGRect ivframe = self.mPreview.frame;
            self.mPreview.hidden = YES;
            CGRect uv_frame = self.uv_Preview.frame; 
            [self.uv_Preview setFrame:CGRectMake(uv_frame.origin.x, uv_frame.origin.y+ 124, uv_frame.size.width, 
            btnframe.size.height)];
  
            [self.btn_showPreview setFrame:CGRectMake(0, 0,  btnframe.size.width,  btnframe.size.height)];
   //         [self.btn_showPreview setBackgroundImage:[[Theme sharedInstance] pngImageWithName:SHOWVIDEO] forState:UIControlStateNormal];
            [self.pLblCallDuration setFrame:CGRectMake(6, 0, 60, 29)];
            
            _isPreviewShown = NO;
        }
    }
    
    else
    {
        
        if(self.interfaceOrientation == UIInterfaceOrientationPortrait)
        {
            CGRect btnframe = self.btn_showPreview.frame;
         //   CGRect ivframe = self.mPreview.frame;
            self.mPreview.hidden = NO;
            
            
   //         [self.uv_Preview setFrame:CGRectMake(14, [ABUtil screenHeight] - 230, 88, 154)];
            
            [self.mPreview setFrame:CGRectMake(4, 4, 80, 119)];
            [self.btn_showPreview setFrame:CGRectMake(0, 124,  btnframe.size.width,  btnframe.size.height)];
   //         [self.btn_showPreview setBackgroundImage:[[Theme sharedInstance] pngImageWithName:HIDEVIDEO] forState:UIControlStateNormal];
            [self.pLblCallDuration setFrame:CGRectMake(6, 124, 60, 29)];
            
            _isPreviewShown = YES;
        } 
        
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.mPortrait = nil;
    self.uv_Preview =nil;
    
    self.uv_operationbar= nil;
    
    self.mDisplay=nil;
    self.mPreview=nil;
    
    self.btn_showPreview=nil;

    self.mHangUp=nil;
    self.mMute=nil;
    self.mCamSwitch=nil;
    
    self.pLblCallDuration=nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
 //   if (!self.isViewLoaded&& !self.view.window)
    {
     /*
        self.mPortrait = nil;
        self.uv_Preview =nil;
        
        self.uv_operationbar= nil;
        
        self.mDisplay=nil;
        self.mPreview=nil;
        
        self.btn_showPreview=nil;
        self.btn_shutCamera=nil;
        self.btn_bigPreview=nil;
        self.mHangUp=nil;
        self.mMute=nil;
        self.mCamSwitch=nil;
        
        self.pLblCallDuration=nil;
        
        
        // landscape right
        self.mLandscapeRight=nil;
        self.uv_PreviewLandRight=nil;
        self.uv_operationbarLandRight=nil;
        
        self.mDisplayLandRight=nil;
        self.mPreviewLandRight=nil;
        
        self.btn_showPreviewLandRight=nil;
        self.btn_shutCameraLandRight=nil;
        self.btn_bigPreviewLandRight=nil;
        self.mMuteLandRight=nil;
        self.mHangUpLandRight=nil;
        self.mCamSwitchLandRight=nil;
        
        self.lrLblCallDuration=nil;
        
        //landscape left
        
        self.mLandscapeLeft=nil;
        self.uv_PreviewLandLeft=nil;
        self.uv_operationbarLandLeft =nil;
        
        self.mDisplayLandLeft=nil;
        self. mPreviewLandLeft = nil;
        
        
        self.btn_showPreviewLandLeft = nil;
        self.btn_shutCameraLandLeft =nil;
        self.btn_bigPreviewLandLeft =nil;
        self.mMuteLandLeft = nil;
        self.mHangUpLandLeft = nil;
        self.mCamSwitchLandLeft=nil;
        
        self.llLblCallDuration =nil;
   */
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    [self.mMute initWithOnImage:[UIImage imageNamed:@"videocall_mute_a.png"] offImage:[UIImage imageNamed:@"videocall_mute.png"]];
    

    
 //   [self.mPreview setImage:[[Theme sharedInstance] pngImageWithName:VIDEOPREVIEW]];
    
   // self.mHangUp.backgroundColor = [Theme sharedInstance].currentThemeColor;
   
   // self.mCamSwitch.backgroundColor = [Theme sharedInstance].currentThemeColor;
    
    [self.mHangUp setImage:[UIImage imageNamed:@"videocall_endcall.png"] forState:UIControlStateNormal];
    
    [self.mCamSwitch setImage:[UIImage imageNamed:@"videocall_change_camera.png"] forState:UIControlStateNormal];
    
    _isPreviewShown = TRUE;
    
  //   [self.view setFrame:CGRectMake(0, 0, 320, [ABUtil heightNotIncludingStatusBar])];
      [self.mPortrait setFrame:CGRectMake(0, 0, 320, [UISize screenHeight])];
     [self.uv_Preview setFrame:CGRectMake(14, [UISize screenHeight] - 230, 88, 134)];
      [self.uv_operationbar setFrame:CGRectMake(0, [UISize screenHeight] -49, 320, 49)];
    [self.mDisplay setFrame:CGRectMake(0, 0, 320, [UISize screenHeight])];

    self.uv_operationbar.backgroundColor = [UIColor clearColor];
    isFirst=TRUE;
    /*
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
  */
    
}


-(void) configureOrientation:(UIInterfaceOrientation) oritentation  {

	if (oritentation == UIInterfaceOrientationPortrait ) {
		[self.view addSubview:self.mPortrait];
        [WowTalkVoipIF fVideoCall_SetVideoWindow:self.mDisplay];
        [WowTalkVoipIF fVideoCall_SetCapturePreviewVideoWindow:self.mPreview];
	}
    
	[WowTalkVoipIF fVideoCall_AutoAdjustVideoRotation:oritentation];
}

-(void) configureOrientation {
    [self configureOrientation:self.interfaceOrientation]; 
}


-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil]; // set the audio session to ambient .

}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    //redirect audio to speaker
	UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;  
	AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute
							 , sizeof (audioRouteOverride)
							 , &audioRouteOverride);
    
    
    [self performSelectorOnMainThread:@selector(configureOrientation)
             						   withObject:nil 
             						waitUntilDone:YES];
    [self.mMute reset];


}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.pLblCallDuration start];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return  interfaceOrientation == UIInterfaceOrientationPortrait;
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self configureOrientation:self.interfaceOrientation];
	[self.mMute reset];

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

	[self.mPortrait removeFromSuperview];
}


@end
