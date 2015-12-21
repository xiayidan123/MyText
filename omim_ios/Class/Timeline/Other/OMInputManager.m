//
//  OMInputManager.m
//  dev01
//
//  Created by 杨彬 on 15/4/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMInputManager.h"

#import "OMInputBar.h"

#import "OMViewState.h"

#define inputBarHeight 44

@interface OMInputManager ()<OMInputBarDelegate>

@property (retain, nonatomic)OMViewState *state;

@property (assign, nonatomic)CGRect rect;

@property (assign, nonatomic)CGFloat click_Y;


@property (assign, nonatomic)CGFloat keyboardHeight;

@property (assign, nonatomic)NSNumber *duration;

@property (retain, nonatomic)UIView *clean_view;


@property (assign, nonatomic)CGFloat distance;


@property (assign, nonatomic)BOOL showNotificationAlreadyCall;


@property (assign, nonatomic)BOOL hideNotificationAlreadyCall;


@end

@implementation OMInputManager


-(void)dealloc{
    self.placeholder = nil;
    self.click_view = nil;
    self.state = nil;
    self.input_bar = nil;
    self.duration = nil;
    self.clean_view = nil;
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

static OMInputManager *_m = nil;
+ (id)sharedManager{
    
    if (!_m){
        _m = [[OMInputManager alloc]init];
    }
    return _m;
}


-(void)setClick_view:(UIView *)click_view{
    [_click_view release],_click_view = nil;
    _click_view = [click_view retain];
    
    self.showNotificationAlreadyCall = NO;
    self.hideNotificationAlreadyCall = NO;
    
    if (_click_view == nil){
        self.state = nil;
        self.duration = nil;
        self.input_bar = nil;
        self.keyboardHeight = 0;
        self.clean_view = nil;
        self.distance = 0;
        
        return;
    }
    
    OMViewState *state = [[OMViewState alloc]init];
    [state setStateWithView:_click_view];
    self.state = state;
    [state release];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    OMInputBar *input_bar = [[OMInputBar alloc]initWithFrame:CGRectMake(0, window.frame.size.height - inputBarHeight, window.frame.size.width, inputBarHeight)];
    [window addSubview:input_bar];
    input_bar.alpha = 0;
    input_bar.delegate = self;
    self.input_bar = input_bar;
    
    [self.clean_view removeFromSuperview];
    self.clean_view = nil;
    
    [input_bar activateWithView:nil];
    [input_bar release];
}



+ (void)hideKeyBoard{
    OMInputManager *m = [OMInputManager sharedManager];
    
    [m.input_bar endEdit];
    
}

- (void)releaseManager{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_m release];
    _m = nil;
}



#pragma mark ----- Keyboard Response
- (void) keyboardWillShow:(NSNotification *)note{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGFloat keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    self.duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat distance = 0;
    if (self.showNotificationAlreadyCall){
        distance = self.keyboardHeight - keyboardHeight;
    }else{
        distance = [window convertRect:self.state.frame fromView:self.state.superview].origin.y - (keyboardHeight - self.input_bar.bounds.size.height);
    }
    
    self.showNotificationAlreadyCall = YES;
    self.distance = distance;
    self.keyboardHeight = keyboardHeight;
    
    if ([self.delegate respondsToSelector:@selector(beginShowKeyboardWithDistance:)]){
        [self.delegate beginShowKeyboardWithDistance:distance];
    }

    
    if (self.clean_view == nil){
        UIView *clean_view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, window.bounds.size.width, self.input_bar.frame.origin.y - 64)];
        clean_view.backgroundColor = [UIColor clearColor];
        clean_view.userInteractionEnabled = YES;
        [clean_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        [window insertSubview:clean_view belowSubview:self.input_bar];
        self.clean_view = clean_view;
    }
    
    [UIView animateWithDuration:[self.duration doubleValue] animations:^{
        self.input_bar.alpha = 1;
        self.input_bar.center = CGPointMake(self.input_bar.center.x, self.keyboardHeight - self.input_bar.frame.size.height/2);
    }completion:^(BOOL finished) {
        self.clean_view.frame = CGRectMake(self.clean_view.frame.origin.x, self.clean_view.frame.origin.y, self.clean_view.frame.size.width, self.input_bar.frame.origin.y - 64);
    }];
    
}

-(void) keyboardWillHide:(NSNotification *)note{
    if (self.hideNotificationAlreadyCall)return;
    self.hideNotificationAlreadyCall = YES;
    
    self.duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[self.duration doubleValue] animations:^{
        self.input_bar.alpha = 0;
        self.input_bar.center = CGPointMake(self.input_bar.center.x, [UIScreen mainScreen].bounds.size.height - inputBarHeight/2 );
    }completion:^(BOOL finished) {
        [self.clean_view removeFromSuperview];
        self.clean_view = nil;
        [self.input_bar removeFromSuperview];
        self.input_bar = nil;
        self.hideNotificationAlreadyCall = NO;
        self.showNotificationAlreadyCall = NO;
        self.distance = 0;
        self.keyboardHeight = 0;
        [self releaseManager];
    }];
}



- (void)tapAction{
    [self.input_bar endEdit];
}


#pragma mark - OMInputBarDelegate

- (void)OMInputBar:(OMInputBar *)inputBar didChangeHeight:(CGFloat )distance_height{
    if ([self.delegate respondsToSelector:@selector(beginShowKeyboardWithDistance:)]){
        [self.delegate beginShowKeyboardWithDistance:distance_height];
    }
}
- (void)OMInputBar:(OMInputBar *)inputBar didReturn:(NSString *)text_string{
    if ([self.delegate respondsToSelector:@selector(didClickReturnWithText:)]){
        [self.delegate didClickReturnWithText:text_string];
    }
}

- (void)OMInputBar:(OMInputBar *)inputBar didEndEdit:(NSString *)text_string{
    if ([self.delegate respondsToSelector:@selector(didEndHideKeyBoard)]){
        [self.delegate didEndHideKeyBoard];
    }
}


-(void)setPlaceholder:(NSString *)placeholder{
    [_placeholder release],_placeholder = nil;
    _placeholder = [placeholder copy];
    
    self.input_bar.placeholder = placeholder;
}

@end
