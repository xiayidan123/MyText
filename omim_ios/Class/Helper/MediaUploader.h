//
//  MediaUploader.h
//  omimbiz
//
//  Created by elvis on 2013/08/12.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaUploader : NSObject

@property (nonatomic,retain) NSMutableArray* moments;

+(MediaUploader*)sharedUploader;

-(void)upload;

//-(BOOL)checkUpload;

//-(void)stop;

@end
