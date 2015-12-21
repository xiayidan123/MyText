//
//  CameraListVC.h
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class ClassRoom;
@class ClassModel;
@class CameraListVC;

@protocol CameraListVCDelegate <NSObject>

- (void)cameraListVC:(CameraListVC *)cameraListVC didSetCameraWithCameraListArray:(NSMutableArray *)cameraListArray;

@end

@interface CameraListVC : OMViewController

@property (assign, nonatomic)id<CameraListVCDelegate>delegate;

@property (retain, nonatomic)ClassRoom *classRoom;


@end
