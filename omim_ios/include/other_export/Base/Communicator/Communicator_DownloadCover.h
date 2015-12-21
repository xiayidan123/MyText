//
//  Communicator_DownloadCover.h
//  yuanqutong
//
//  Created by elvis on 2013/05/20.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator.h"

@class ASIS3ObjectRequest;
@class CoverImage;

@interface Communicator_DownloadCover : Communicator
{
    ASIS3ObjectRequest *request;
    NSString* bucket;
}
@property (retain, nonatomic) ASIS3ObjectRequest *request;
@property (retain,nonatomic)NSString* bucket;
@property (assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign) id downloadProgressDelegate;

@property (nonatomic,retain) CoverImage* image;


-(void)fInitS3Setting;

- (id)fGetFileWithPath:(NSString *)path ;

@end