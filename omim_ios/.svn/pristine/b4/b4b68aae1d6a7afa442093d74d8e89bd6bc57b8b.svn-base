//
//  Communicator_GetMomentMedia.h
//  yuanqutong
//
//  Created by elvis on 2013/05/15.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator.h"

@class ASIS3ObjectRequest;
@class WTFile;
@interface Communicator_GetMomentMedia : Communicator
{
    ASIS3ObjectRequest *request;
    NSString* bucket;
}
@property (retain, nonatomic) NSString* bucket;

@property (retain, nonatomic) ASIS3ObjectRequest *request;
@property (assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign) id downloadProgressDelegate;

@property (nonatomic,retain) WTFile* file;
@property BOOL isThumb;

-(void)fInitS3Setting;

- (id)fGetFileWithPath:(NSString *)path;

@end
