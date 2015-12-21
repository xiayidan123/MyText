//
//  YBImageThumbnailCell.m
//  YBImageShow
//
//  Created by 杨彬 on 15/5/11.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "YBImageThumbnailCell.h"

#import "YBImageModel.h"


#import "WowTalkWebServerIF.h"
#import "WTHeader.h"
#import "MediaProcessing.h"



@interface YBImageThumbnailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail_imageView;

@end

@implementation YBImageThumbnailCell

-(void)setImage_model:(YBImageModel *)image_model{
    _image_model = image_model;
    
    UIImage *thumbnail_image = nil;
    if (_image_model.thumbnail_image != nil){
        thumbnail_image = _image_model.thumbnail_image;
    }else if (_image_model.thumbmail_local_path != nil){
        thumbnail_image = [UIImage imageWithContentsOfFile:_image_model.thumbmail_local_path];
    }else if (_image_model.thumbmail_url != nil){
//        [self.thumbnail_imageView setImageWithURL:[NSURL URLWithString:_image_model.thumbmail_url] placeholderImage:nil];
//        thumbnail_image = self.thumbnail_imageView.image;
    }
    
    if (thumbnail_image != nil){
        self.thumbnail_imageView.image = thumbnail_image;
        _image_model.thumbnail_image = thumbnail_image;
    }else if (_image_model.file != nil){
        // 做自己的网络请求。。。 （很多下载图片的方式是不能用SDWebImage 的 ）
        WTFile *file = _image_model.file;
            NSData *data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:file.ext];
            
        if (data){
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                _image_model.thumbnail_image = thumbnail_image;
                self.thumbnail_imageView.image = image;
            });
        }else{
                [self.thumbnail_imageView setImage:[UIImage imageNamed:@"default_pic.png"]];
                [WowTalkWebServerIF getMomentMedia:file isThumb:true inShowingOrder:5000 forMoment:file.momentid withCallback:@selector(didDownloadImage:) withObserver:self];
        }
        
    }
    
    _image_model.current_view = self.thumbnail_imageView;
    

}


-(void)didDownloadImage:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *moment_id = [[notif userInfo] valueForKey:@"momentid"];
        WTFile *file = self.image_model.file;
        if ([moment_id isEqualToString:file.momentid]){
            NSData* data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:file.ext];
            self.image_model.thumbnail_image = [UIImage imageWithData:data];
            self.thumbnail_imageView.image = self.image_model.thumbnail_image;
        }
    }
}



- (void)awakeFromNib {
    
}

@end
