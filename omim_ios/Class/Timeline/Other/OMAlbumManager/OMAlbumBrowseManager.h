//
//  OMAlbumBrowseManager.h
//  dev01
//
//  Created by 杨彬 on 15/4/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMAlbumBrowseManager : NSObject

+ (id)sharedManager;


+ (void)endShow;


- (void)showWithState:(NSArray *)state_array withIndex:(NSIndexPath *)indexPath;


@end
