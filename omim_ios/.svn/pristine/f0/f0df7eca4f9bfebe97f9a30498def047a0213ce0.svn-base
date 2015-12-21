//
//  NewMomentViewController.h
//  omim
//
//  Created by Li  Beck on 14-3-13.
//  Implemented by Elvis Shu
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "QBImagePickerController.h"
#import "LocationHelper.h"

@class UIPlaceHolderTextView;

@interface NewMomentViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate, QBImagePickerControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UINavigationControllerDelegate,LocationHelperDelegate,AVAudioPlayerDelegate>


// location
@property (nonatomic,retain) IBOutlet UIView* location_container;
@property (nonatomic,retain) IBOutlet UILabel* lbl_location;


//record
@property (nonatomic,retain) IBOutlet UIView* uv_record;
@property (nonatomic,retain) IBOutlet UIButton* btn_record;
@property (nonatomic,retain) IBOutlet UIButton* btn_play;
@property (nonatomic,retain) IBOutlet UIButton* btn_delete;
@property (nonatomic,retain) IBOutlet UILabel* lbl_des;
@property (nonatomic,retain) IBOutlet UILabel* lbl_timer;
@property (nonatomic,retain) IBOutlet UIImageView* iv_mic;

//images
@property (nonatomic,retain) IBOutlet UIView* uv_photo;
@property (nonatomic,retain) IBOutlet UIButton* btn_camera;
@property (nonatomic,retain) IBOutlet UIButton* btn_album;
@property (nonatomic,retain) IBOutlet UIScrollView* sv_images;
@property (nonatomic,retain) IBOutlet UIImageView* iv_image;
@property (nonatomic,retain) IBOutlet UILabel* lbl_count;

//operation bar
@property(nonatomic,retain) IBOutlet UIButton *btn_addPhoto;
@property(nonatomic,retain) IBOutlet UIButton *btn_addLocation;
@property(nonatomic,retain) IBOutlet UIButton *btn_addVoice;
@property(nonatomic,retain) IBOutlet UIView *uv_additems;

@property(nonatomic,retain) IBOutlet UIPlaceHolderTextView *textView;


@property(nonatomic,retain) IBOutlet UIView *uv_bg_below;

// data
@property (nonatomic,retain) NSMutableArray* selectedPhotos;


//recorder
@property (nonatomic,retain) AVAudioPlayer* recordPlayer;
@property (nonatomic,retain) AVAudioRecorder *recorder;
@property (nonatomic,retain) NSMutableDictionary *recordSetting;


@end
