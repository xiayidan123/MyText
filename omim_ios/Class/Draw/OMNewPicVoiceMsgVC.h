//
//  OMNewPicVoiceMsgVC
//
//  Copyright (c) 2013年 onemeter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "QBImagePickerController.h"
#import "LocationHelper.h"
#import "PicVoiceMsgPreview.h"

@protocol GalleryViewControllerDelegate;
@protocol MomentPrivacyViewControllerDelegate;

@interface OMNewPicVoiceMsgVC : UIViewController<UITextViewDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate, QBImagePickerControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,UIGestureRecognizerDelegate>

@property int type;
@property int contentSizeGap;
// data
@property (nonatomic,retain) NSMutableArray* selectedPhotos;
@property (nonatomic,retain) IBOutlet UIScrollView* sv_container;

@property (nonatomic, copy) NSString *dirName;
@property (nonatomic, assign) id<PicVoiceMsgPreviewDelegate> delegate;

@end
