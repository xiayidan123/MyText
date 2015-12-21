//
//  AlbumPickerViewController.h
//  omim
//
//  Created by coca on 12/09/23.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumType.h"
#import "MediaProcessing.h"

@class MsgComposerVC;
@class AlbumPickerViewController;
//@class ProfileVC;

@protocol AlbumPickerViewControllerDelegate <NSObject>

- (void)getDataFromAlbum:(AlbumPickerViewController *)requestor;

@end


@interface AlbumPickerViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MediaProcessingDelegate>


@property(nonatomic,assign) id<AlbumPickerViewControllerDelegate>delegate;
@property (nonatomic,retain) UIImagePickerController* imagePicker;
@property (nonatomic, assign) UIViewController* parent;
@property (nonatomic,retain) NSString* dirName;

@property (nonatomic,retain) NSString* imagePath;
@property (nonatomic,retain) NSString* videoPath;
@property (nonatomic,retain) NSString* thumbnailPath;

@property (nonatomic,assign) CGSize maxThumbnailSize;
@property (nonatomic,assign) BOOL needCropping; // crop the center part;

@property (nonatomic, assign) MULTI_MEDIA_TYPE mmtType;

-(BOOL) openAlbum;

@end
