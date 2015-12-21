//
//  CoverImage.m
//  yuanqutong
//
//  Created by elvis on 2013/05/20.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "CoverImage.h"
#import "Database.h"
@implementation CoverImage

- (void)dealloc
{
    self.uid = nil;
    self.ext = nil;
    self.file_id = nil;
    self.timestamp = nil;
    
    [super dealloc];
}

- (id)initWithDict:(NSMutableDictionary *)dict
{
    if (dict==nil) {
        return nil;
    }
    
    if (self = [super init])
    {
        self.uid = [dict objectForKey:@"uid"];
        self.ext = [dict objectForKey:@"ext"];
        self.file_id = [dict objectForKey:@"file_id"];
        self.timestamp = [dict objectForKey:@"update_timestamp"];
        
        if ([self.timestamp integerValue] < 0) {
            self.needDownload = FALSE;
            self.coverNotSet = TRUE;
        }
        else{
            CoverImage* ci = [Database getCoverImageByUid:self.uid];
            if ([ci.timestamp integerValue] < [self.timestamp integerValue]) {
                self.needDownload = TRUE;
            }
            else{
                self.needDownload = FALSE;
            }
            
            self.coverNotSet = FALSE;
        }
        
    }
    return self;
}

- (id)initWithFileID:(NSString*)strFileID  withExt:(NSString*)strExt withTimestamp:(NSString*)timestamp   withUid:(NSString*)uid{
    if (self = [super init]){
      
        self.file_id=strFileID;
        self.ext=strExt;
        self.timestamp=timestamp;
        self.uid=uid;
        
        if ([timestamp integerValue] < 0) {
            self.needDownload = FALSE;
            self.coverNotSet = TRUE;

        }
        else{
        CoverImage* ci = [Database getCoverImageByUid:self.uid];
            if ([ci.timestamp integerValue] < [timestamp integerValue]) {
                self.needDownload = TRUE;
            }
            else{
                self.needDownload = FALSE;
            }
            self.coverNotSet = FALSE;
        }
    }
    
    
    return self;
    
    
}

@end
