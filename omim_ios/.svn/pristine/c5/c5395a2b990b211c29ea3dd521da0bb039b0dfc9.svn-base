//
//  checkPhotoView.h
//  dev01
//
//  Created by Huan on 15/7/31.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBPhotoModel;
@class checkPhotoView;
@class WTFile;
@protocol checkPhotoViewDelegate <NSObject>

- (void)checkPhotoView:(checkPhotoView *)checkPhotoView;

@end



@interface checkPhotoView : UIImageView
//@property (retain, nonatomic) YBPhotoModel * photo;
@property (assign, nonatomic) id<checkPhotoViewDelegate> delegate;
@property (retain, nonatomic) WTFile * file;
@end
