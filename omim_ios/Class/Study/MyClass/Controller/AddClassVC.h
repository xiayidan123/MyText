//
//  AddClassVC.h
//  dev01
//
//  Created by 杨彬 on 15/3/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddClassVC;
@protocol AddClassVCDelegate <NSObject>


- (void)didAddClass:(AddClassVC *)addClassVC;


@end

@interface AddClassVC : UIViewController


@property (assign, nonatomic)id<AddClassVCDelegate>delegate;

@end
