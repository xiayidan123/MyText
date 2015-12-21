//
//  MomentRecordView.m
//  dev01
//
//  Created by 杨彬 on 15/4/10.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentRecordView.h"

#import "MediaProcessing.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"

#import "MomentRecordModel.h"

#import "MomentCellDenfine.h"
#import "VoiceMessagePlayer.h"

@interface MomentRecordView ()<VoiceMessagePlayerDelegate>

@property (retain, nonatomic)UIView *record_bar;

@property (retain, nonatomic)NSLayoutConstraint *record_width;

@property (retain, nonatomic)UILabel *countdown_label;

@property (retain, nonatomic)UIButton *record_button;


@property (retain, nonatomic)WTFile *file;

@property (retain, nonatomic)UIActivityIndicatorView *activityIndicatorView;




@end

@implementation MomentRecordView

-(void)dealloc{
    self.record_bar = nil;
    self.record_width = nil;
    self.countdown_label = nil;
    self.record_button = nil;
    self.activityIndicatorView = nil;
    
    self.file = nil;
    self.moment_id = nil;
    
    [super dealloc];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self uiConfig];
    }
    return self;
}



-(void)setRecord_model:(MomentRecordModel *)record_model{
    [_record_model release],_record_model = nil;
    _record_model = [record_model retain];
    if(_record_model == nil){
        self.file = nil;
        return;
    }
    if (_record_model.isPlaying){
        self.record_button.enabled = YES;
        self.record_button.selected = YES;
    }else{
        self.record_button.selected = NO;
    }
    
    self.file = _record_model.record_file;
}


-(void)setFile:(WTFile *)file{
    [_file release],_file = nil;
    _file = [file retain];
    if (_file == nil)return;
    
    double timelong = _file.duration;
    
    NSString *timelong_string =  [NSString stringWithFormat:@"  %@",[self formatRecordTimeLong:timelong]];
    
    [self.record_button setTitle:timelong_string forState:UIControlStateNormal];
    
    NSData* data = [MediaProcessing getMediaForFile:_file.fileid withExtension:_file.ext];
    
    if (!data) {
        self.record_button.enabled = NO;
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
        [WowTalkWebServerIF getMomentMedia:_file isThumb:NO inShowingOrder:0 forMoment:self.moment_id withCallback:@selector(didDownloadRecord:) withObserver:self];   // TODO: we could add a indicator to tell the clip is being downloaded now.
    }else{
        self.record_button.enabled = YES;
        self.activityIndicatorView.hidden = YES;
        [self.activityIndicatorView stopAnimating];
    }
}


- (NSString *)formatRecordTimeLong:(double )timelong{
    int minute_count = ((int )timelong)/60;
    
    int second_count = ((int) timelong)%60;
    
    NSString *minute_string;
    NSString *second_string;
    if (minute_count > 9){
        minute_string = [NSString stringWithFormat:@"%d",minute_count];
    }else{
        minute_string = [NSString stringWithFormat:@"0%d",minute_count];
    }
    
    if (second_count >9){
        second_string = [NSString stringWithFormat:@"%d",second_count];
    }else{
        second_string = [NSString stringWithFormat:@"0%d",second_count];
    }
    
    NSString *timelong_string = [NSString stringWithFormat:@"%@:%@",minute_string,second_string];
    
    return timelong_string;
}


- (void)didDownloadRecord:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *moment_id = [[notif userInfo] valueForKey:@"momentid"];
        if ([moment_id isEqualToString:self.moment_id]){
//            NSData* data = [MediaProcessing getMediaForFile:self.file.fileid withExtension:self.file.ext];
            self.record_button.enabled = YES;
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.hidden = YES;
        }
    }
}


- (void)uiConfig{
    self.layer.masksToBounds = YES;
    
    [self draw_record_button];
    
    [self draw_activityIndicatorView];
}



- (void)draw_record_button{
    UIButton *record_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    record_button.translatesAutoresizingMaskIntoConstraints = NO;
    
    record_button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [record_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [record_button addTarget:self action:@selector(palyRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    [record_button setImage:[UIImage imageNamed:@"icon_share_list_video_play"] forState:UIControlStateNormal];
    [record_button setImage:[UIImage imageNamed:@"icon_share_list_video_stop"] forState:UIControlStateSelected];
    
    [self addSubview:record_button];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:record_button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self addConstraint:leading];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:record_button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self addConstraint:centerY];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:record_button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:recoredButtonHeight];
    [self addConstraint:height];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:record_button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
    [record_button addConstraint:width];
    
    
    record_button.layer.cornerRadius = recoredButtonHeight/2.0;
    record_button.layer.masksToBounds = YES;

    record_button.backgroundColor = [UIColor colorWithRed:0.65 green:0.91 blue:0.98 alpha:1];
    
    
    
    self.record_button = record_button;
}


- (void)draw_activityIndicatorView{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:activityIndicatorView];
    
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.record_button attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self addConstraint:leading];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self addConstraint:centerY];
    
    self.activityIndicatorView = activityIndicatorView;
    [activityIndicatorView release];
    
    self.activityIndicatorView.hidden = YES;
    
}


- (void)palyRecord:(UIButton *)record_button{
    record_button.selected = ! record_button.selected;
    
    if (record_button.selected){
        
        self.record_model.isPlaying = YES;
        
        if ([[VoiceMessagePlayer sharedInstance] isPlaying]) {
            [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
        }
        
        [VoiceMessagePlayer sharedInstance].filepath =  [NSFileManager absoluteFilePathForMedia:self.record_model.record_file];
        [VoiceMessagePlayer sharedInstance].totalLength = self.record_model.record_file.duration;
        [VoiceMessagePlayer sharedInstance].delegate = self;
        [VoiceMessagePlayer sharedInstance].record_button = record_button;
        [VoiceMessagePlayer sharedInstance].openProximityMonitoring = YES;
        [[VoiceMessagePlayer sharedInstance] playVoiceMessage];
        
    }else{
        self.record_model.isPlaying = NO;
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
        
    }
}


-(void)didStopPlayingVoice:(VoiceMessagePlayer*)requestor{
    self.record_button.selected = NO;
}



@end
