//
//  Communicator_GetEventmediaAliyun.h
//  dev01
//
//  Created by 杨彬 on 14-11-25.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator.h"
#import "WowtalkXMLParser.h"
#import "WowtalkUIDelegates.h"
#import <AliyunOpenServiceSDK/OSS.h>
#import "WTFile.h"

@interface Communicator_GetEventmediaAliyun : Communicator <OSSClientDelegate>
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
