//
//  AVRecorderVC.h
//  omim
//
//  Created by coca on 12/09/13.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@class AVRecorderVC;
@class MsgComposerVC;

@protocol AVRecorderVCDelegate <NSObject>

-(void) sendRecord:(AVRecorderVC*)requestor;

@end


@interface AVRecorderVC : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    SystemSoundID soundID;
}


@property (nonatomic,retain) MsgComposerVC* parent;

//@property (nonatomic,retain) NSString* directoryPath;
@property (nonatomic,retain) NSString* dirName;


@property (nonatomic,retain) AVAudioPlayer* recordPlayer;

@property (nonatomic,retain) IBOutlet UIView* uv_container;
@property (nonatomic,retain) IBOutlet UIView* uv_shadow;

@property (nonatomic,retain) IBOutlet UILabel* lbl_timer;
@property (nonatomic,retain) IBOutlet UIImageView* iv_mic;
@property (nonatomic,retain) IBOutlet UIImageView* iv_bg;


@property (nonatomic,retain) IBOutlet UILabel* lbl_play_pause;
@property (nonatomic,retain) IBOutlet UILabel* lbl_cancel;
@property (nonatomic,retain) IBOutlet UILabel* lbl_send;


@property (nonatomic,retain) IBOutlet UIButton* btn_send;
@property (nonatomic,retain) IBOutlet UIButton* btn_play;
@property (nonatomic,retain) IBOutlet UIButton* btn_pause;
@property (nonatomic,retain) IBOutlet UIButton* btn_cancel;

@property (nonatomic,retain) AVAudioRecorder *recorder;
@property (nonatomic,retain) NSMutableDictionary *recordSetting;

@property (nonatomic,retain) NSString *fullFilePath;
@property (nonatomic,retain) NSString* relativeFilePath;

@property (nonatomic,retain)  NSTimer *timer;
@property (nonatomic,assign) id<AVRecorderVCDelegate> delegate;

@property int totalSeconds;

-(void) startRecording;
-(void) stopRecording;
-(void)dismissThisView;



-(IBAction)playSound:(id)sender;
-(IBAction) stopPlaying:(id)sender;
-(IBAction) cancalPlaying:(id)sender;
-(IBAction) sendRecord:(id)sender;




@end
