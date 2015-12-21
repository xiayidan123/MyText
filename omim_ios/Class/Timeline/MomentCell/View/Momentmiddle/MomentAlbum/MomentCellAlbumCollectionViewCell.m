//
//  MomentCellAlbumCollectionViewCell.m
//  dev01
//
//  Created by 杨彬 on 15/4/10.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentCellAlbumCollectionViewCell.h"
#import "WTFile.h"

#import "WowTalkWebServerIF.h"
#import "MediaProcessing.h"
#import "WTHeader.h"

@interface MomentCellAlbumCollectionViewCell ()

@property (retain, nonatomic) UIImageView * play_imageView;

@end


@implementation MomentCellAlbumCollectionViewCell

-(void)dealloc{
    self.file = nil;
    self.moment_id = nil;
    self.photo_imageView = nil;
    self.play_imageView = nil;
    [super dealloc];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.photo_imageView.image = nil;
}


-(void)setFile:(WTFile *)file{
    [_file release],_file = nil;
    _file = [file retain];
    if (_file == nil){
        self.photo_imageView.image = nil;
        return;
    }
    
    
    if (self.isVideo){
        
        if (!self.play_imageView){
            UIImageView *play_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40,40)];
            play_imageView.image = [UIImage imageNamed:@"sms_voice_play"];
            play_imageView.center = self.photo_imageView.center;
            [self addSubview:play_imageView];
            self.play_imageView = play_imageView;
            [play_imageView release];
        }
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:_file.ext];
            
            if (data){
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.photo_imageView.image = image;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.photo_imageView setImage:[UIImage imageNamed:@"default_pic.png"]];
                    [WowTalkWebServerIF getMomentMedia:file isThumb:true inShowingOrder:5000 forMoment:self.moment_id withCallback:@selector(didDownloadImage:) withObserver:self];
                });
            }
        });
    }else{
        
        [self.play_imageView removeFromSuperview];
        self.play_imageView = nil;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:_file.ext];
            
            if (data){
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.photo_imageView.image = image;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.photo_imageView setImage:[UIImage imageNamed:@"default_pic.png"]];
                    [WowTalkWebServerIF getMomentMedia:file isThumb:true inShowingOrder:5000 forMoment:self.moment_id withCallback:@selector(didDownloadImage:) withObserver:self];
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
        if ([moment_id isEqualToString:self.moment_id]){
            NSData* data = [MediaProcessing getMediaForFile:self.file.thumbnailid withExtension:_file.ext];
            self.photo_imageView.image = [UIImage imageWithData:data];
        }
    }
}


#pragma mark 测试线程
- (void)getImage:(WTFile *)file{
    NSData* data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:_file.ext];
    if (data) {
        [self.photo_imageView setImage:[UIImage imageWithData:data]];
    }
    else{
        [self.photo_imageView setImage:[UIImage imageNamed:@"default_pic.png"]];
        [self performSelectorOnMainThread:@selector(downloadImage:) withObject:file waitUntilDone:NO];
    };
}


- (void)downloadImage:(WTFile *)file{
    [WowTalkWebServerIF getMomentMedia:file isThumb:true inShowingOrder:5000 forMoment:self.moment_id withCallback:@selector(didDownloadImage:) withObserver:self];
}



- (void)showImage:(WTFile *)file{
    NSData* data = [MediaProcessing getMediaForFile:self.file.thumbnailid withExtension:_file.ext];
    self.photo_imageView.image = [UIImage imageWithData:data];
}



- (void)awakeFromNib {
    // Initialization code
    self.photo_imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photo_imageView.clipsToBounds = YES;
}





@end
