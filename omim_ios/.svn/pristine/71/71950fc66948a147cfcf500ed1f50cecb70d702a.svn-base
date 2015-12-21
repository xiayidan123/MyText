//
//  Communicator_GetGroupAvater.h
//  omim
//
//  Created by coca on 2013/04/26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator.h"
@class ASIS3ObjectRequest;

@interface Communicator_GetGroupAvater : Communicator
{
    ASIS3ObjectRequest *request;
}
@property (retain, nonatomic) ASIS3ObjectRequest *request;
@property (assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign) id downloadProgressDelegate;

@property (assign) NSInteger tag;
@property (assign) NSObject *userData;

- (void)fSetS3SecretAccessKey:(NSString *)secretAccessKey andAccessKey:(NSString *)accessKey;

- (id)fGetFileWithPath:(NSString *)path FromBucket:(NSString *)bucket;


@end
