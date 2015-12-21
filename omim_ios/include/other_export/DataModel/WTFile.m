//
//  WTFile.m
//  omim
//
//  Created by coca on 14-4-17.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "WTFile.h"


/**
 * Describe a multimedia file.
 */
@implementation WTFile

@synthesize fileid;
@synthesize localPath;
@synthesize dbid;
@synthesize duration = _duration;
@synthesize thumbnailid = _thumbnailid;
@synthesize momentid = _momentid;


-(void)dealloc
{
    self.fileid = nil;
    self.ext = nil;
    self.localPath = nil;
    self.dbid = nil;
    self.thumbnailid = nil;
    self.momentid = nil;
    
    [super dealloc];
}

- (id)initWithDict:(NSMutableDictionary *)dict
{
    if (dict==nil) {
        return nil;
    }
    
    if (self = [super init])
    {
        self.dbid = [dict objectForKey:@"multimedia_content_id"];
        self.ext = [dict objectForKey:@"multimedia_content_type"];
        self.fileid = [dict objectForKey:@"multimedia_content_path"];
        self.duration = [dict objectForKey:@"duration"] ?[[dict objectForKey:@"duration"] doubleValue]:0;
        self.thumbnailid = [dict objectForKey:@"multimedia_thumbnail_path"];

    }
    return self;
}

- (id)initWithFileID:(NSString*)strFileID withThumbnailID:(NSString*)strthumbID  withExt:(NSString*)strExt withLocalPath:(NSString*)strLocalPath withDBid:(NSString*)strDBid withDuration:(double)duration{
    if (self = [super init]){
        self.fileid=strFileID;
        self.thumbnailid = strthumbID;
        self.ext=strExt;
        self.localPath=strLocalPath;
        self.dbid=strDBid;
        self.duration = duration;
    }
    
    
    return self;
    
    
}

-(void)setExt:(NSString *)ext{
    [_ext release];_ext = nil;
    _ext = [ext.lowercaseString copy];
}

@end

