//
//  OMNewVideoMomentVC
//  wowtalkbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "QBImagePickerController.h"
#import "LocationHelper.h"

#import "NewMomentProtocol.h"

@protocol GalleryViewControllerDelegate;
@protocol MomentPrivacyViewControllerDelegate;

@interface OMNewVideoMomentVC : UIViewController<UITextViewDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate, QBImagePickerControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UINavigationControllerDelegate,LocationHelperDelegate,AVAudioPlayerDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,GalleryViewControllerDelegate,MomentPrivacyViewControllerDelegate>

@property NSInteger type;
@property int contentSizeGap;
// data
@property (nonatomic,retain) NSMutableArray* selectedVideos;
@property (nonatomic,retain) IBOutlet UIScrollView* sv_container;

@property (assign, nonatomic) id <NewMomentProtocolDelegate>delegate;

@end