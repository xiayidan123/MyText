//
//  NewCameraVC.h
//  dev01
//
//  Created by Huan on 15/3/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumType.h"
@class NewCameraVC;

@protocol NewCameraVCDelegate <NSObject>

- (void)getDataFromCamera:(NewCameraVC *)requestor;

@end


@interface NewCameraVC : UIViewController
@property (nonatomic, assign) id<NewCameraVCDelegate> delegate;
@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *thumbnailPath;
@property (nonatomic,assign) CGSize maxThumbnailSize;
@property (nonatomic, assign) MULTI_MEDIA_TYPE mmtType;
@property (nonatomic, assign) BOOL needCropping;
- (BOOL)startCamera;
@end
