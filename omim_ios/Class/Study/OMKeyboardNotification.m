//
//  OMKeyboardNotification.m
//  dev01
//
//  Created by 杨彬 on 15/3/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMKeyboardNotification.h"

@implementation OMKeyboardNotification

- (instancetype)init
{
    self = [super init];
    if (self) {
        _keyboardHeight = [UIScreen mainScreen].bounds.size.height;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillChangeFrame:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        
        
    }
    return self;
}


- (void) keyboardWillShow:(NSNotification *)note{
    _keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - 64;
    _isShow = YES;
}

-(void) keyboardWillHide:(NSNotification *)note{
    _keyboardHeight = [UIScreen mainScreen].bounds.size.height;
    _isShow = NO;
}

- (void)keyboardWillChangeFrame:(NSNotification *)note{
    _keyboardHeight = [UIScreen mainScreen].bounds.size.height;
    _isShow = YES;
}


+ (instancetype)defaultCenter{
    static OMKeyboardNotification *keyboardNotificaiton = nil;
    if (!keyboardNotificaiton){
        keyboardNotificaiton = [[OMKeyboardNotification alloc] init];
    }
    return keyboardNotificaiton;
}

@end
