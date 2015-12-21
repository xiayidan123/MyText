//
//  OMViewState.h
//  dev01
//
//  Created by 杨彬 on 15/4/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTFile;

@interface OMViewState : NSObject

@property (retain, nonatomic)UIView *superview;

@property (retain, nonatomic)UIView *original_view;

@property (retain, nonatomic)WTFile *file;

@property (assign, nonatomic)CGRect frame;

@property (assign, nonatomic)BOOL userInteratctionEnabled;

@property (assign, nonatomic)CGAffineTransform transform;

@property (copy, nonatomic)NSString *moment_id;





//+ (instancetype)viewStateForView:(UIView *)view;


- (void)setStateWithView:(UIView *)view;

- (instancetype)initWithView:(UIView *)view;





@end
