//
//  Communicator_GetFileS3.h
//  omimLibrary
//
//  Created by Yi Chen on 6/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ASIS3ObjectRequest.h"
#import "WowtalkXMLParser.h"
#import "WowtalkUIDelegates.h"

@interface Communicator_GetFileS3 : NSObject
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

