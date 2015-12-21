//
//  Communicator_UploadGroupAvatar.h
//  omim
//
//  Created by coca on 2013/04/26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIS3ObjectRequest.h"
#import "WowtalkUIDelegates.h"

@interface Communicator_UploadGroupAvatar : NSObject<NSXMLParserDelegate>
{
    ASIS3ObjectRequest *request;
    NSMutableString* strFileID;
}

@property (retain, nonatomic) ASIS3ObjectRequest *request;
@property (assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign) id uploadProgressDelegate;

@property (assign) NSInteger tag;
@property (assign) NSObject *userData;

@property (nonatomic, retain) NSMutableString *strFileID;


- (void)fSetS3SecretAccessKey:(NSString *)secretAccessKey andAccessKey:(NSString *)accessKey;

- (id) uploadGroupAvatar:(NSString*)filepath forGroup:(NSString*)groupid toDir:(NSString*)dirPath forBucket:(NSString *)bucket;
- (id) uploadGroupAvatarThumbnail:(NSString *)filepath forGroup:(NSString*)groupid toDir:(NSString *)dirPath forBucket:(NSString *)bucket;

//- (id)fUploadFile:(NSString *)localfilePath toDir:(NSString *)dirPath forBucket:(NSString *)bucket;
//- (id)fUploadProfilePhoto:(NSString *)localfilePath toDir:(NSString *)dirPath forBucket:(NSString *)bucket;

@end
