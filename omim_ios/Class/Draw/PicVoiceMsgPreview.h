//
//  PicVoiceMsgPreview
//  omim
//
//  Created by coca on 2013/02/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTFile.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>



@class PicVoiceMsgPreview;

@protocol PicVoiceMsgPreviewDelegate

- (void)getDataFromPVMP:(PicVoiceMsgPreview*)requestor;

@end

@interface PicVoiceMsgPreview : UIViewController<AVAudioPlayerDelegate>



@property(nonatomic,retain) NSURL* photoMsgURL;
@property(nonatomic, retain) NSString* textMsg;
@property(nonatomic,retain) WTFile* recordMsg;

@property (nonatomic, copy) NSString *dirName;



@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *thumbnailPath;
@property (nonatomic, assign) id<PicVoiceMsgPreviewDelegate> delegate;

@end
