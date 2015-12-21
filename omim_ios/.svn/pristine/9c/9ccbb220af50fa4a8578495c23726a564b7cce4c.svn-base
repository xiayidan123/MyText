//
//  CoverImage.h
//  yuanqutong
//
//  Created by elvis on 2013/05/20.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoverImage : NSObject

@property (nonatomic,retain) NSString* file_id;
@property (nonatomic,retain) NSString* ext;
@property (nonatomic,retain) NSString* uid;
@property (nonatomic,retain) NSString* timestamp;
@property (nonatomic,retain) NSString* previousfile_id;
@property (nonatomic,assign) BOOL coverNotSet;
@property (nonatomic,assign) BOOL needDownload;

- (id)initWithDict:(NSMutableDictionary *)dict;
- (id)initWithFileID:(NSString*)strFileID  withExt:(NSString*)strExt withTimestamp:(NSString*)timestamp   withUid:(NSString*)uid;
@end
