//
//  Communicator_GetFileAliyun.h
//  omimLibrary
//
//  Created by Yi Chen on 6/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WowtalkXMLParser.h"
#import "WowtalkUIDelegates.h"
#import <AliyunOpenServiceSDK/OSS.h>

@interface Communicator_GetFileAliyun : NSObject <OSSClientDelegate>
{
    OSSClient * _client;
}

@property (assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign) id downloadProgressDelegate;

@property (assign) NSInteger tag;
@property (assign) NSObject *userData;
@property (assign) BOOL isMomentCoverImageDownLoad;

- (void)fInit;

- (id)fGetFileWithPath:(NSString *)path FromBucket:(NSString *)bucket;

@end

