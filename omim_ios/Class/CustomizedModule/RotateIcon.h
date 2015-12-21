//
//  rotateIcon.h
//  wowcity
//
//  Created by elvis on 2013/06/06.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotateIcon : UIImageView


+(RotateIcon*)sharedRotateIcon;

@property (nonatomic,retain) UIViewController* parent;
-(void)show;
-(void)rotateClockwise;
-(void)rotateCounterClockwise;
-(void)hide;

@end
