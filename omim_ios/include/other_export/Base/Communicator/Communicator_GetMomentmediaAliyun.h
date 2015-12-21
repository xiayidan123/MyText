//
//  Communicator_GetMomentmediaAliyun.h
//  dev01
//
//  Created by coca on 11/11/14.
//  Copyright (c) 2014 wowtech. All rights reserved.
//

//
#import <Foundation/Foundation.h>
#import "WowtalkXMLParser.h"
#import "WowtalkUIDelegates.h"
#import <AliyunOpenServiceSDK/OSS.h>
#import "WTFile.h"
@interface Communicator_GetMomentmediaAliyun : NSObject <OSSClientDelegate>
{
    OSSClient * _client;
}

@property (assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign) id downloadProgressDelegate;

@property (assign) NSInteger tag;
@property (assign) NSObject *userData;
@property (nonatomic,retain) WTFile* file;
@property BOOL isThumb;

- (void)fInit;

- (id)fGetFileWithPath:(NSString *)path FromBucket:(NSString *)bucket;

@end

