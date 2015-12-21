//
//  OMAlbumBrowseCell.m
//  dev01
//
//  Created by 杨彬 on 15/4/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMAlbumBrowseCell.h"
#import "WTFile.h"

#import "MediaProcessing.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"

@interface OMAlbumBrowseCell ()
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end


@implementation OMAlbumBrowseCell


-(void)dealloc{
    self.file = nil;
    self.moment_id = nil;
    self.photo_imageView = nil;
    [_activityView release];
    [super dealloc];
}


-(void)setFile:(WTFile *)file{
    [_file release],_file = nil;
    _file = [file retain];
    if(_file == nil){
        self.photo_imageView.image = nil;
        return;
    }
    
    
    NSData* data = [MediaProcessing getMediaForFile:file.fileid withExtension:_file.ext];
    if (data) {
        [self.activityView stopAnimating];
        self.activityView.hidden = YES;
        [self.photo_imageView setImage:[UIImage imageWithData:data]];
    }
    else{
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
        [WowTalkWebServerIF getMomentMedia:file isThumb:NO inShowingOrder:5000 forMoment:self.moment_id withCallback:@selector(didDownloadImage:) withObserver:self];
    };
    
}


-(void)didDownloadImage:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *moment_id = [[notif userInfo] valueForKey:@"momentid"];
        if ([moment_id isEqualToString:self.moment_id]){
            NSData* data = [MediaProcessing getMediaForFile:self.file.fileid withExtension:_file.ext];
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            self.photo_imageView.image = [UIImage imageWithData:data];
        }
    }
}


- (void)awakeFromNib {
    // Initialization code
}

@end
