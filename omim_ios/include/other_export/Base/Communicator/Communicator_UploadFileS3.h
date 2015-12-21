//
//  Communicator_UploadFileS3.h
//  omimLibrary
//
//  Created by Yi Chen on 6/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIS3ObjectRequest.h"
#import "WowtalkUIDelegates.h"
@class WTFile;
@class CoverImage;

@interface Communicator_UploadFileS3 : NSObject<NSXMLParserDelegate>
{
    ASIS3ObjectRequest *request;
    NSMutableString* strFileID;
    
}

@property BOOL isMediaThumbnail;
@property (retain, nonatomic) ASIS3ObjectRequest *request;
@property (assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign) id uploadProgressDelegate;

@property (assign) NSInteger tag;
@property (assign) NSObject *userData;

@property (nonatomic, retain) NSMutableString *strFileID;


- (void)fSetS3SecretAccessKey:(NSString *)secretAccessKey andAccessKey:(NSString *)accessKey;
- (id)fUploadFile:(NSString *)localfilePath toDir:(NSString *)dirPath forBucket:(NSString *)bucket;
- (id)fUploadProfilePhoto:(NSString *)localfilePath toDir:(NSString *)dirPath forBucket:(NSString *)bucket;

-(id)uploadMomentMedia:(WTFile*)file toDir:(NSString *)dirPath forBucket:(NSString *)bucket  withExt:(BOOL)withExt;

-(id)uploadCover:(CoverImage*)image toDir:(NSString *)dirPath forBucket:(NSString *)bucket;

@end
