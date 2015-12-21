//
//  WTFile.h
//  omim
//
//  Created by coca on 14-4-17.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Describe a multimedia file.
 */
@interface WTFile : NSObject

/**
 * ID in cloud(remote file server).
 */
@property (nonatomic, copy) NSString* fileid;

/**
 * Extension file name, e.g., "png".
 */
@property (nonatomic, copy) NSString* ext;

/**
 * full path in local filesystem.
 */

@property (nonatomic, copy) NSString* localPath;


@property (nonatomic,copy) NSString* thumbnailid;

/**
 * ID in webserver database.
 */
@property (nonatomic, copy) NSString* dbid;

@property (nonatomic,copy) NSString* momentid;

@property double duration;

- (id)initWithDict:(NSMutableDictionary *)dict;

- (id)initWithFileID:(NSString*)strFileID withThumbnailID:(NSString*)strthumbID withExt:(NSString*)strExt withLocalPath:(NSString*)strLocalPath withDBid:(NSString*)strDBid withDuration:(double)duration;



@end

