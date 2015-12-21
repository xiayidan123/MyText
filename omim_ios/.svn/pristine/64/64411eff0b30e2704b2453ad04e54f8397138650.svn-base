//
//  ClassListViewController.h
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class OMClass;
@protocol ClassListViewControllerDelegate <NSObject>

- (void)getClassName:(OMClass *)classModel;

@end

@interface ClassListViewController : OMViewController
@property (assign, nonatomic) id<ClassListViewControllerDelegate> delegate;
@end
