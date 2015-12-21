//
//  OMInputBar.m
//  dev01
//
//  Created by 杨彬 on 15/4/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//


#import "OMInputBar.h"

#import "PublicFunctions.h"

#import "HPGrowingTextView.h"


@interface OMInputBar ()<HPGrowingTextViewDelegate>

@property (retain, nonatomic)HPGrowingTextView *text_view;

@property (retain, nonatomic)UIImageView *text_bg_view;

@property (retain, nonatomic)UIView *bottomline;

@end


@implementation OMInputBar

-(void)dealloc{
    self.placeholder = nil;
    self.bottomline = nil;
    self.text_bg_view = nil;
    self.text_view = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig{
    
    self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    topline.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:topline];
    [topline release];
    
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height- 0.5, self.frame.size.width, 0.5)];
    bottomline.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomline];
    self.bottomline = bottomline;
    [bottomline release];
    
    
    HPGrowingTextView *text_view = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width - 75, 33)];
    text_view.delegate = self;
    text_view.center = CGPointMake(text_view.center.x, self.frame.size.height/2);
    text_view.placeholder = @"评论";
    text_view.internalTextView.returnKeyType = UIReturnKeySend;
    text_view.enterIsIllicit = YES;
    
    
    UIImageView *text_bg_view = [[UIImageView alloc]initWithFrame:text_view.frame];
    text_bg_view.image = [PublicFunctions strecthableImage:@"sms_text_field.png"];
    [self addSubview:text_bg_view];
    self.text_bg_view = text_bg_view;
    [text_bg_view release];
    
    [self addSubview:text_view];
    self.text_view = text_view;
    [text_view release];
    
}



- (void)activateWithView:(UIView *)click_view{
    
    [self.text_view becomeFirstResponder];
    
}


- (void)endEdit{
    if ([self.delegate respondsToSelector:@selector(OMInputBar:didEndEdit:)]){
        [self.delegate OMInputBar:self didEndEdit:self.text_view.text];
    }
    [self.text_view endEditing];
}



#pragma mark - HPGrowingTextViewDelegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (height - self.text_view.frame.size.height );
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - diff, self.frame.size.width,self.frame.size.height + diff);
    self.bottomline.frame = CGRectMake(self.bottomline.frame.origin.x, self.frame.size.height- 0.5, self.bottomline.frame.size.width, self.bottomline.frame.size.height);
    self.text_bg_view.frame = CGRectMake(self.text_bg_view.frame.origin.x, self.text_bg_view.frame.origin.y, self.text_bg_view.frame.size.width, self.text_bg_view.frame.size.height + diff);
    
    if ([self.delegate respondsToSelector:@selector(OMInputBar:didChangeHeight:)]){
        [self.delegate OMInputBar:self didChangeHeight:diff];
    }
    
}


- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    NSString *text_view_string = growingTextView.text;
    
    if (text_view_string.length == 0){
        return NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(OMInputBar:didReturn:)]){
        [self.delegate OMInputBar:self didReturn:text_view_string];
    }
    
    
    return YES;
    
}



-(void)setPlaceholder:(NSString *)placeholder{
    [_placeholder release],_placeholder = nil;
    _placeholder = [placeholder copy];
    self.text_view.placeholder = placeholder;
}

@end
