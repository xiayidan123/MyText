//
//  OMNavigationController.m
//  dev01
//
//  Created by 杨彬 on 15/3/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMNavigationController.h"

#import "OMInputManager.h"
#import "PublicFunctions.h"

@interface OMNavigationController ()<UIGestureRecognizerDelegate>

@property (retain, nonatomic) UIPanGestureRecognizer * pan;




@end

@implementation OMNavigationController

-(void)dealloc{
    self.pan = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pan.delegate = self;
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
    self.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1){
        return NO;
    }
    return YES;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count >= 1){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    [OMInputManager hideKeyBoard];
    
    return [super popViewControllerAnimated:YES];
}

#pragma mark - Set and Get

-(UIPanGestureRecognizer *)pan{
    if (_pan == nil){
        id target = self.interactivePopGestureRecognizer.delegate;
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
        _pan.delegate = self;
        
        [self.view addGestureRecognizer:_pan];
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return _pan;
}

- (void)setTurnoff_slide_back:(BOOL)turnoff_slide_back{
    _turnoff_slide_back = turnoff_slide_back;
    self.pan.enabled = ! _turnoff_slide_back;
}


@end
