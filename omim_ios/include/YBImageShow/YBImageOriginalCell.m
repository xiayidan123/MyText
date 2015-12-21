//
//  YBImageOriginalCell.m
//  YBImageShow
//
//  Created by 杨彬 on 15/5/11.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "YBImageOriginalCell.h"

#import "YBImageModel.h"

#import "MediaProcessing.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"



@interface YBImageOriginalCell ()




@end

@implementation YBImageOriginalCell


-(void)setImage_model:(YBImageModel *)image_model{
    _image_model = image_model;
    
    
    UIImage *original_image = nil;
    if (_image_model.original_image != nil){
        original_image = _image_model.original_image;
    }else if (_image_model.original_local_path != nil){
        original_image = [UIImage imageWithContentsOfFile:_image_model.original_local_path];
    }
    
    if (original_image != nil){
        self.original_imageView.image = original_image;
    }else if (_image_model.file != nil){
        // 做自己的网络请求。。。 （很多下载图片的方式是不能用SDWebImage 的 ）
        WTFile *file = _image_model.file;
        NSData* data = [MediaProcessing getMediaForFile:file.fileid withExtension:file.ext];
        if (data) {
               [self.original_imageView setImage:[UIImage imageWithData:data]];
        }
        else{
                self.original_imageView.image = _image_model.thumbnail_image;
                [WowTalkWebServerIF getMomentMedia:file isThumb:NO inShowingOrder:5000 forMoment:file.momentid withCallback:@selector(didDownloadImage:) withObserver:self];
        };
    }
}

-(void)didDownloadImage:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *moment_id = [[notif userInfo] valueForKey:@"momentid"];
        WTFile *file = self.image_model.file;
        if ([moment_id isEqualToString:file.momentid]){
            NSData* data = [MediaProcessing getMediaForFile:file.fileid withExtension:file.ext];
            if (data){
                self.original_imageView.image = [UIImage imageWithData:data];
            }
        }
    }
}


- (void)awakeFromNib {
    self.original_imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
