//
//  LHImageCell.m
//  流水布局
//
//  Created by Huan on 15/4/10.
//  Copyright (c) 2015年 LiuHuan. All rights reserved.
//

#import "LHImageCell.h"
#import "YBPhotoModel.h"
#import "MediaProcessing.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "YBImageModel.h"
@interface LHImageCell()
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) ALAssetsLibrary *asset;

@end



@implementation LHImageCell

- (void)awakeFromNib {
//    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.imageView.layer.borderWidth = 3;
//    self.imageView.layer.cornerRadius = 3;
//    self.imageView.clipsToBounds = YES;
}
- (void)setImage:(YBPhotoModel *)image{
    [_image release],_image = nil;
    _image = [image retain];
    
    if (image.image_obj){
        WTFile *file = image.image_obj;
        self.file = file;
    }
    
    
    if (_image.url != nil){
        [self.asset assetForURL:image.url resultBlock:^(ALAsset *asset) {
            UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
            
            self.imageView.image = image;
            
        }failureBlock:^(NSError *error) {
            
        }];
    }else{
//        self.imageView.image = nil;
    }
}


- (void)setFile:(WTFile *)file{
    if (_file != file) {
        [_file release];
        _file = [file retain];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:file.ext];
            
            if (data){
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = image;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageView setImage:[UIImage imageNamed:@"default_pic.png"]];
                    [WowTalkWebServerIF getMomentMedia:file isThumb:true inShowingOrder:5000 forMoment:file.momentid withCallback:@selector(didDownloadImage:) withObserver:self];
                });
            }
        });
    }
}

-(void)didDownloadImage:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *moment_id = [[notif userInfo] valueForKey:@"momentid"];
        if ([moment_id isEqualToString:self.file.momentid]){
            NSData* data = [MediaProcessing getMediaForFile:self.file.thumbnailid withExtension:self.file.ext];
            self.imageView.image = [UIImage imageWithData:data];
        }
    }
}

- (void)setPhotos:(NSMutableArray *)photos{
    if (_photos != photos) {
        [_photos release];
        _photos = [photos retain];
        
    }
}

- (void)setAddImage:(UIImage *)addImage{
    if (_addImage != addImage) {
        [_addImage release];
        _addImage = [addImage retain];
        self.imageView.image = addImage;
    }
}

-(ALAssetsLibrary *)asset{
    
    if (_asset == nil){
        _asset = [[ALAssetsLibrary alloc]init];
    }
    
    return _asset;
    
}



@end
