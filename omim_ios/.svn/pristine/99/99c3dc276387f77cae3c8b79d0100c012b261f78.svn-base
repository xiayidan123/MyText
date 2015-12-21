//
//  MediaUploader.m
//  omimbiz
//
//  Created by elvis on 2013/08/12.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "MediaUploader.h"
#import "WTHeader.h"

@implementation MediaUploader

@synthesize moments;

+(MediaUploader*)sharedUploader{
    @synchronized(self){
        static MediaUploader *uploader = nil;
        
        if (uploader == nil){
            uploader = [[MediaUploader alloc] init];
            [uploader initUploader];
        }
        return uploader;
    }
}

-(void)initUploader{
    self.moments = [[[NSMutableArray alloc] init] autorelease];
}


-(void)upload{
    NSMutableArray* arrays = [Database queuedMedias];
    if (arrays) {
        for (QueuedMedia* media in arrays) {
            [self addMomentID:media];
            WTFile* file = [[WTFile alloc] init];
            if (media.isThumbnail) {
                file.thumbnailid = media.fileid;
                file.momentid = media.moment_id;
                file.ext = media.ext;
                //TODO: add ext here
                [WowTalkWebServerIF uploadMomentMediaThumbnail:file withCallback:@selector(didUpload:) withObserver:nil];
            }
            else{
                file.fileid = media.fileid;
                file.momentid = media.moment_id;
                file.ext = media.ext;
                [WowTalkWebServerIF uploadMomentMedia:file withCallback:@selector(didUpload:) withObserver:nil withExt:NO];
            }
            [file release];
        }
    }
}

-(void)addMomentID:(QueuedMedia*)media
{
    for (NSString* momentid in self.moments) {
        if ([media.moment_id isEqualToString:momentid]) {
            return;
        }
    }
    [self.moments addObject:media.moment_id];
}

-(void)removeMomentID:(NSString*)momentid
{
    for (int i = 0; i< [self.moments count]; i ++) {
        if ([momentid isEqualToString:[self.moments objectAtIndex:i]]) {
            [self.moments removeObjectAtIndex:i];
            return;
        }
    }    
}

-(void)didUpload:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        WTFile* file = [[notif userInfo] valueForKey:@"file"];
        if (file.thumbnailid){
           [Database deleteQueuedMediaFile:file.thumbnailid forMoment:file.momentid];
        }
        else{
           [Database deleteQueuedMediaFile:file.fileid forMoment:file.momentid];
        }
        if (![Database isInTheQueue:file.momentid]) {
            [self removeMomentID:file.momentid];
            [self updateMomentMediaInServer:file.momentid];
        }
    }
}

-(void)updateMomentMediaInServer:(NSString*)momentid
{
    Moment* moment = [Database getMomentWithID:momentid];
    for (WTFile* file in moment.multimedias) {
        //TODO: possible risk: if the info is not updated. 
        [WowTalkWebServerIF uploadMomentMultimedia:file ForMoment:momentid withCallback:nil withObserver:nil];
    }
}


-(void)dealloc
{
    self.moments = nil;
    [super dealloc];
}


@end
