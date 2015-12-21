//
//  OMAlertView.m
//  dev01
//
//  Created by 杨彬 on 15/2/11.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMAlertView.h"

@interface OMAlertView()<UIAlertViewDelegate>

@property (nonatomic,assign)id<OMAlertViewDelegate>delegate;

// buttonTitle
@property (nonatomic,retain)NSArray *titleArray;

@property (nonatomic,copy)NSString *cancellButtonTitle;

@property (nonatomic,copy)NSString *enterButtonTitle;

// subViews

@property (nonatomic,retain)UIView *promptView;
@property (nonatomic,retain)UIButton *cancellButton;
@property (nonatomic,retain)UIButton *enterButton;

@property (nonatomic,retain)UIImageView *promptBGImageView;// 弹窗背景视图




@end

@implementation OMAlertView


-(void)dealloc{
    [_titleArray release],_titleArray = nil;
    
// title
    [_cancellButtonTitle release],_cancellButtonTitle = nil;
    [_enterButtonTitle release],_enterButtonTitle = nil;
    
// subViews
//    [_cancellButton release],_cancellButton = nil;
//    [_enterButton release],_enterButton = nil;
    [_promptView release],_promptView = nil;
    [_custiomView release],_custiomView = nil;
    [_bgView release],_bgView = nil;
    [_promptBGImageView release],_promptBGImageView = nil;
    
// 弹窗默认颜色
    [_promptViewColor release],_promptViewColor = nil;
    [super dealloc];
}

- (instancetype)initWithCustomView:(UIView *)customView delegate:(id<OMAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle enterButtonTitle:(NSString *)enterTitle TitleArray:(NSArray *)titleArray
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height);
        
        self.delegate = delegate;
        
        _custiomView = [customView retain];
        
        self.titleArray = titleArray;
        self.cancellButtonTitle = cancelTitle;
        self.enterButtonTitle = enterTitle;
        
        [self loadBGView];
        [self loadPromptView];
        
        [self uiConfig];
        
    }
    return self;
}


-(void)setPromptViewColor:(UIColor *)promptViewColor{
    [_promptViewColor release],_promptViewColor = nil;
    _promptViewColor = [promptViewColor retain];
    _promptBGImageView.backgroundColor = _promptViewColor;
}


- (void)setPromptBGImage:(UIImage *)promptBGImage{
    [_promptBGImage release],_promptBGImage = nil;
    _promptBGImage = [promptBGImage retain];
    _promptBGImageView.image = _promptBGImage;
}

// 加载背景图片
- (void)loadBGView{
    _bgView = [[UIView alloc]initWithFrame:self.bounds];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.4;
    [self addSubview:_bgView];
}


// 加载弹窗视图
- (void)loadPromptView{
    _promptView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height / 6, self.frame.size.width/ 4)];
    _promptView.center = _bgView.center;
    _promptView.layer.cornerRadius = 5;
    _promptView.layer.masksToBounds = YES;
    _promptView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    [self addSubview:_promptView];
    
    _promptBGImageView = [[UIImageView alloc]initWithFrame:_promptView.bounds];
    [_promptView addSubview:_promptBGImageView];
}




- (void)uiConfig{
    [self loadCustionView];
    
    CGFloat y = [self loadOtherButton];
    
    CGFloat h = [self loadBasicButton:y];
    
    _promptView.frame = CGRectMake(0, 0, _promptView.frame.size.width, h);
    _promptView.center = _bgView.center;
    
}

// 加载自定义View
- (void)loadCustionView{
    _custiomView.frame = CGRectMake(0, 0, _custiomView.frame.size.width, _custiomView.frame.size.height);
    _promptView.frame = CGRectMake(_promptView.frame.origin.x, _promptView.frame.origin.y, _custiomView.frame.size.width, _custiomView.frame.size.height);
    [_promptView addSubview:_custiomView];
}

// 加载titleArray中的button
- (CGFloat )loadOtherButton{
    CGFloat h = _custiomView.frame.origin.y + _custiomView.frame.size.height;
    for (int i=0; i<_titleArray.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, h, _promptView.frame.size.width, 30);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 2000 + i + 2;
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_promptView addSubview:button];
        h += 30;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.origin.y, button.frame.size.width , 0.5)];
        line.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
        [_promptView addSubview:line];
        [line release];
    }
    return h;
}



- (CGFloat )loadBasicButton:(CGFloat )y{
    CGFloat h = y;
    if (_enterButtonTitle != nil){
        _enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _enterButton.frame = CGRectMake(0, y, _promptView.frame.size.width/2 , 30);
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _enterButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_enterButton setTitle:_enterButtonTitle forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _enterButton.tag = 2000;
        [_promptView addSubview:_enterButton];
    }
    if (_cancellButtonTitle != nil){
        _cancellButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancellButton.frame = CGRectMake(0, y, _promptView.frame.size.width/2 , 30);
        _cancellButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancellButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancellButton.tag = 2001;
        [_cancellButton setTitle:_cancellButtonTitle forState:UIControlStateNormal];
        [_cancellButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_promptView addSubview:_cancellButton];
    }
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, y, _promptView.frame.size.width , 0.5)];
    line.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    [_promptView addSubview:line];
    [line release];
    
    h = y + 30;
    if (_cancellButtonTitle != nil && _enterButtonTitle != nil){
        _enterButton.frame = CGRectMake(_promptView.frame.size.width/2, y, _promptView.frame.size.width/2, 30);
        _cancellButton.frame = CGRectMake(0, y, _promptView.frame.size.width/2, 30);
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_promptView.frame.size.width/2, y, 0.5 , 30)];
        line2.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
        [_promptView addSubview:line2];
        [line2 release];
    }else if (_cancellButton != nil && _enterButton == nil){
        [_enterButton removeFromSuperview];
        _cancellButton.frame = CGRectMake(0, y, _promptView.frame.size.width, 30);
    }else if (_cancellButton == nil && _enterButton != nil){
        _enterButton.frame = CGRectMake(0, y, _promptView.frame.size.width, 30);
        [_cancellButton removeFromSuperview];
    }else{
        [line removeFromSuperview];
        [_enterButton removeFromSuperview];
        [_cancellButton removeFromSuperview];
        h = y;
    }
    return h;
}

- (void)show{
    _promptView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
        _promptView.alpha = 1;
    }];
}


- (void)buttonAction:(UIButton *)btn{
    NSInteger index = btn.tag - 2000;
    
    if ([_delegate respondsToSelector:@selector(omAlertView:clickedButtonAtIndex:customView:)]){
        [_delegate omAlertView:self clickedButtonAtIndex:index customView:_custiomView];
    }
    [self removeFromSuperview];
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    if (animated){
        [UIView animateWithDuration:0.15 animations:^{
            _promptView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}

@end
