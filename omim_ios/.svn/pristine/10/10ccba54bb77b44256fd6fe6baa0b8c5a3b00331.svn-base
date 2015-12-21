//
//  Communicator_GetEventMedia.h
//  dev01
//
//  Created by jianxd on 14-11-29.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator.h"
@class ASIS3ObjectRequest;
@class WTFile;

@interface Communicator_GetEventMedia : Communicator
@property (retain, nonatomic) ASIS3ObjectRequest *request;
@property (assign, nonatomic) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign, nonatomic) id downloadProgressDelegate;

@property (nonatomic) BOOL isThumbnail;
@property (copy, nonatomic) NSString *fileId;
@property (copy, nonatomic) NSString *fileExt;
@property (retain, nonatomic) WTFile *file;

- (void)setS3SecretAccessKey:(NSString *)secretkey andAccessKey:(NSString *)accessKey;
- (id)getFileWithPath:(NSString *)path fromBucket:(NSString *)bucket;
@end
