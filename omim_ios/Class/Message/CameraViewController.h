//
//  CameraViewController.h
//  omim
//
//  Created by Harry on 12-9-26.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumType.h"
#import "MediaProcessing.h"

@class MsgComposerVC;
@class CameraViewController;

@protocol CameraViewControllerDelegate

- (void)getDataFromCamera:(CameraViewController *)requestor;

@end

@interface CameraViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,MediaProcessingDelegate>
{
    
}
@property (nonatomic, assign) id<CameraViewControllerDelegate> delegate;
@property (nonatomic, assign) UIViewController *parent;

@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *thumbnailPath;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *dirName;

@property (nonatomic,assign) CGSize maxThumbnailSize;

@property (nonatomic, assign) MULTI_MEDIA_TYPE mmtType;

@property (nonatomic,assign) BOOL needCropping; // crop the center part;

- (BOOL)startCamera;
- (IBAction)cameraClicked:(id)sender;

@end
