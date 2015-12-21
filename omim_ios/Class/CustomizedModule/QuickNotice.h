//
//  QuickNotice.h
//  omimbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickNotice : UIView


@property (nonatomic,retain) NSError* error;

@property (nonatomic,retain) NSString* msg;

-(void)show;

@end
