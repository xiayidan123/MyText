//
//  MomentRecordModel.h
//  dev01
//
//  Created by 杨彬 on 15/4/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WTFile.h"

@interface MomentRecordModel : NSObject

@property (assign, nonatomic)BOOL isPlaying;

@property (retain, nonatomic)WTFile *record_file;

@end
