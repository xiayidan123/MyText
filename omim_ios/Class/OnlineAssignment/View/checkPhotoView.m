//
//  checkPhotoView.m
//  dev01
//
//  Created by Huan on 15/7/31.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  查看作业的View

#import "checkPhotoView.h"
#import "YBPhotoModel.h"
#import "WTFile.h"
#import "WTError.h"
#import "WowTalkWebServerIF.h"
#import "MediaProcessing.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface checkPhotoView()
@property (retain, nonatomic) ALAssetsLibrary *asset;
@end



@implementation checkPhotoView

- (void)dealloc{
    self.file = nil;
    self.asset = nil;
//    self.photo = nil;
    [super dealloc];
}

- (instancetype)init{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *click = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)] autorelease];
        [self addGestureRecognizer:click];
    }
    return self;
}
//- (void)setPhoto:(YBPhotoModel *)photo{
//    [_photo release],_photo = nil;
//    _photo = [photo retain];
//    if (_photo == nil)return;
//    
//    if (photo.image_obj){
//        WTFile *file = photo.image_obj;
//        self.file = file;
//    }
//    
//    
//    if (_photo.url != nil){
//        [self.asset assetForURL:photo.url resultBlock:^(ALAsset *asset) {
//            UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
//            
//            self.image = image;
//            
//        }failureBlock:^(NSError *error) {
//            
//        }];
//    }else{
//        
//    }
//}
- (void)setFile:(WTFile *)file{
    if (_file != file) {
        [_file release];
        _file = [file retain];
        if(_file== nil)return;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:file.ext];
            
            if (data){
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:[UIImage imageNamed:@"default_pic.png"]];
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
            self.image = [UIImage imageWithData:data];
        }
    }
}

- (void)clickImageView:(int)currentCount{
    if ([self.delegate respondsToSelector:@selector(checkPhotoView:)]) {
        [self.delegate checkPhotoView:self];
    }
}
@end
