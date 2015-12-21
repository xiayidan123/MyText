//
//  OMBindingEmailViewController.h
//  dev01
//
//  Created by Starmoon on 15/7/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"

@class OMBindingEmailViewController;

@protocol OMBindingEmailViewControllerDelegate <NSObject>

@optional
/** 已经绑定邮箱 */
- (void)didBindingEamil;

@end



@interface OMBindingEmailViewController : OMViewController

@property (assign, nonatomic) id<OMBindingEmailViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL isRebind;

@end
