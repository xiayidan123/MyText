//
//  AddPhotoView.h
//  dev01
//
//  Created by Huan on 15/5/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewhomeWorkModel;

@protocol AddPhotoViewDelegate <NSObject>

- (void)didSelectedAddPhoto;
- (void)cannotAddphoto;
@end


@interface AddPhotoView : UIView
@property (assign, nonatomic) id<AddPhotoViewDelegate> delegate;
@property (retain, nonatomic) NewhomeWorkModel *homeWorkModel;
@property (retain, nonatomic) NSMutableArray *photos;
@property (retain, nonatomic) NSMutableArray *imageArray;
@property (assign, nonatomic) BOOL isSettingHomework;
@end
