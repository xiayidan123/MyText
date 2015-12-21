//
//  OMSideslipViewController.m
//  dev01
//
//  Created by 杨彬 on 15/3/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMSideslipViewController.h"
#import "AMBlurView.h"

#define TitalDistance 215;
@interface OMSideslipViewController ()

@property (retain, nonatomic)UIView *pan_bgView;// 拖动背景view

@property (retain, nonatomic)UIView *mark_view;// 黑色半透明遮盖view

@property (retain, nonatomic)AMBlurView *blur_view;// 侧滑tableview的半透明磨砂背景


@property (assign, nonatomic)CGFloat startPoint;

@property (assign, nonatomic)BOOL isAnimating;



@end

@implementation OMSideslipViewController

-(void)dealloc{
    [_slider_tableView release];
    
    [_slider_bgView release];
    [_pan_bgView release];
    [_mark_view release];
    [_blur_view release];
    
    [super dealloc];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self hiddenSlideSlip];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self configNavigation];
    
    [self sideUiConfig];
    
    self.startPoint = (self.view.bounds.size.width + 245)/2 - 245;
    
    self.slider_bgView.hidden = YES;
    
}

- (void)configNavigation{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 15);
    [button setImage:[UIImage imageNamed:@"icon_myclass_addclass"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"tabbar_home_set_press"] forState:UIControlStateSelected];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showSideSlip) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    [menuButton release];
}


- (void)sideUiConfig{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.masksToBounds = YES;
    
    [self loadSlider_bgView];
    
    [self loadPan_bgView];
    
    [self loadMark_view];
}

- (void)loadSlider_bgView{
    
    UIView *slider_bgView = [[UIView alloc]init];
    slider_bgView.translatesAutoresizingMaskIntoConstraints = NO;
    slider_bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:slider_bgView];

    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:slider_bgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:245];
    [self.view addConstraint:width];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:slider_bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:64];
    [self.view addConstraint:top];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:slider_bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:49];
    [self.view addConstraint:bottom];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:slider_bgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraint:trailing];
    
    
    self.slider_bgView = slider_bgView;
    [slider_bgView release];
    
}

- (void)loadPan_bgView{
    UIView *pan_bgView = [[UIView alloc]init];
    pan_bgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    pan_bgView.backgroundColor = [UIColor clearColor];
    [self.slider_bgView addSubview:pan_bgView];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:pan_bgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:275];
    [pan_bgView addConstraint:width];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:pan_bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.slider_bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.slider_bgView addConstraint:top];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:pan_bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.slider_bgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.slider_bgView addConstraint:bottom];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:pan_bgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.slider_bgView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self.slider_bgView addConstraint:leading];
    
    
    self.pan_bgView = pan_bgView;
    [pan_bgView release];
    
    self.pan_bgView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];
    
    [self loadBlur_view];
    
    [self loadSlider_tableView];
}


-(void)loadBlur_view{
    AMBlurView *blur_view = [[AMBlurView alloc]initWithFrame:CGRectMake(0, 0, 245, self.view.bounds.size.height - 64 -48)];
    blur_view.blurTintColor = nil;
    blur_view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.pan_bgView addSubview:blur_view];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:blur_view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pan_bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.pan_bgView addConstraint:top];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:blur_view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pan_bgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.pan_bgView addConstraint:bottom];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:blur_view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.pan_bgView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self.pan_bgView addConstraint:leading];
    
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:blur_view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.pan_bgView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30];
    [self.pan_bgView addConstraint:trailing];
    
    self.blur_view = blur_view;
    [blur_view release];
    
}


- (void)loadSlider_tableView{
    UITableView *slider_tableView = [[UITableView alloc]init];
    slider_tableView.backgroundColor = [UIColor clearColor];
    slider_tableView.translatesAutoresizingMaskIntoConstraints = NO;
    slider_tableView.showsHorizontalScrollIndicator = NO;
    slider_tableView.showsVerticalScrollIndicator = NO;
    [self.blur_view addSubview:slider_tableView];
    
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:slider_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.blur_view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.blur_view addConstraint:top];
    
//    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:slider_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.blur_view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//    [self.blur_view addConstraint:bottom];
    
//    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:slider_tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.blur_view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
//    [self.blur_view addConstraint:leading];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:slider_tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:215];
    [slider_tableView addConstraint:width];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:slider_tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.bounds.size.height - 64- 48];
    [slider_tableView addConstraint:height];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:slider_tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.blur_view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.blur_view addConstraint:trailing];
    
    self.slider_tableView = slider_tableView;
    [slider_tableView release];
}

- (void)loadMark_view{
    UIView *mark_view = [[UIView alloc]init];
    mark_view.translatesAutoresizingMaskIntoConstraints = NO;
    mark_view.backgroundColor = [UIColor blackColor];
    mark_view.alpha = 0;
    mark_view.userInteractionEnabled = YES;
    [mark_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    [self.slider_bgView addSubview:mark_view];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:mark_view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.slider_bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.slider_bgView addConstraint:top];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:mark_view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.slider_bgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.slider_bgView addConstraint:bottom];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:mark_view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.pan_bgView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30];
    [self.slider_bgView addConstraint:leading];
    
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:mark_view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.slider_bgView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.slider_bgView addConstraint:trailing];
    
    
    self.mark_view = mark_view;
    [self.slider_bgView bringSubviewToFront:self.pan_bgView];
    
    [mark_view release];
}


#pragma mark - panAction

- (void)panAction:(UIPanGestureRecognizer *)recognizer{
    UIView *view = recognizer.view;
    CGFloat total_disctance = 215;
    CGFloat current_disctance = self.slider_bgView.center.x - self.startPoint;
    CGFloat disctance_scale = current_disctance / total_disctance;
    
    if (disctance_scale > 1){
        [self.slider_bgView setCenter:(CGPoint){self.startPoint + total_disctance, self.slider_bgView.center.y}];
        self.slider_bgView.hidden = NO;
    }
    else if (disctance_scale < 0){
        self.slider_bgView.hidden = YES;
        [self.slider_bgView setCenter:(CGPoint){self.startPoint, self.slider_bgView.center.y}];
    }else{
        CGPoint translation = [recognizer translationInView:view.superview];
        
        if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
            if (disctance_scale == 1 && translation.x > 0)return;
            if (disctance_scale ==0 && translation.x < 0)return;
            self.slider_bgView.hidden = NO;
            [self.slider_bgView setCenter:(CGPoint){self.slider_bgView.center.x + translation.x, self.slider_bgView.center.y}];
            self.mark_view.alpha = disctance_scale * 0.3;
            [recognizer setTranslation:CGPointZero inView:view.superview];
        }else if (recognizer.state == UIGestureRecognizerStateEnded){
            if (disctance_scale > 0.4){// show
                self.slider_bgView.hidden = NO;
                [UIView animateWithDuration:(total_disctance - current_disctance) / (total_disctance / 0.2)  animations:^{
                    self.isAnimating = YES;
                    [self.slider_bgView setCenter:(CGPoint){self.startPoint + total_disctance, self.slider_bgView.center.y}];
                    self.mark_view.alpha = 0.3;
                }completion:^(BOOL finished) {
                    self.isAnimating = NO;
                }];
            }else{// hidden
                [UIView animateWithDuration:0.2 animations:^{
                    self.isAnimating = YES;
                    [self.slider_bgView setCenter:(CGPoint){self.startPoint, self.slider_bgView.center.y}];
                    self.mark_view.alpha = 0;
                    }completion:^(BOOL finished) {
                    self.isAnimating = NO;
                        self.slider_bgView.hidden = YES;
                }];
            }
        }
    }
}

- (void)tapAction{
    [self showSideSlip];
}

- (void)displaySlideSlip{
    if (self.isAnimating) return;
    
    self.mark_view.alpha = 0.3;
    [self.slider_bgView setCenter:(CGPoint){self.startPoint + 215, self.slider_bgView.center.y}];
}


- (void)showSideSlip{
    if (self.isAnimating)return;
    
    if(self.slider_bgView.center.x < self.startPoint + 10 ){
        self.slider_bgView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.isAnimating = YES;
            self.mark_view.alpha = 0.3;
            [self.slider_bgView setCenter:(CGPoint){self.startPoint + 215, self.slider_bgView.center.y}];
        }completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.isAnimating = YES;
            self.mark_view.alpha = 0;
            [self.slider_bgView setCenter:(CGPoint){self.startPoint, self.slider_bgView.center.y}];
        }completion:^(BOOL finished) {
            self.isAnimating = NO;
            self.slider_bgView.hidden = YES;
        }];
    }
}



- (void)hiddenSlideSlip{
    self.isAnimating = YES;
    self.mark_view.alpha = 0;
    [self.slider_bgView setCenter:(CGPoint){self.startPoint, self.slider_bgView.center.y}];
    self.isAnimating = NO;
    self.slider_bgView.hidden = YES;
}


@end
