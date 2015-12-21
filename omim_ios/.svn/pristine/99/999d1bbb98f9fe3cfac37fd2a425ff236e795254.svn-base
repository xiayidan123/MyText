//
//  ChangeStatusViewController.h
//  omim
//
//  Created by elvis on 2013/05/25.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "OMViewController.h"

@class ChangeStatusViewController;

@protocol ChangeStatusViewControllerDelegate <NSObject>

- (void)changeStatusViewController:(ChangeStatusViewController *)changeStatusVC didChangeStatus:(NSString *)status;

@end


@interface ChangeStatusViewController : OMViewController

@property (assign, nonatomic)id<ChangeStatusViewControllerDelegate>delegate;

@end
