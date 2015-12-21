//
//  GuideViewController.h
//  dev01
//
//  Created by 杨彬 on 15/3/13.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuideViewController;

@protocol GuideViewControllerDelegate <NSObject>

@optional
- (void)releaseGuideViewController:(GuideViewController *)guideViewController;

@end


@interface GuideViewController : UIViewController

@property (assign, nonatomic)id <GuideViewControllerDelegate>delegate;

@end
