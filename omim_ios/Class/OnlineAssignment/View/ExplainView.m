//
//  ExplainView.m
//  dev01
//
//  Created by Huan on 15/5/19.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ExplainView.h"


@interface ExplainView()<UITextViewDelegate>

/** 作业补充说明*/
@property (retain, nonatomic) NSString * explain;

@property (retain, nonatomic) UILabel * placehoderLabel;

@property (retain, nonatomic) UITextView *explainView;

@end


@implementation ExplainView

- (void)dealloc{
    self.placehoderLabel = nil;
    self.explain = nil;
    self.old_text = nil;
    self.explainView = nil;
    [super dealloc];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadTextView];
    }
    return self;
}
- (void)loadTextView{
    self.explainView = [[[UITextView alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width - 10, self.frame.size.height)] autorelease];
    self.explainView.delegate = self;
    [self addSubview:self.explainView];
    
    
    self.placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 1, 100, 30)];
    self.placehoderLabel.font = [UIFont systemFontOfSize:14];
    self.placehoderLabel.text = @"补充说明";
    self.placehoderLabel.enabled = NO;
    self.placehoderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.placehoderLabel];
}



-(void)setOld_text:(NSString *)old_text{
    [_old_text release],_old_text = nil;
    _old_text = [old_text copy];
    
    self.explainView.text = _old_text;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.explain = textView.text;
    if (textView.text.length == 0) {
        self.placehoderLabel.text = @"补充说明";
    }else{
        self.placehoderLabel.text = @"";
        
    }
    if ([_delegate respondsToSelector:@selector(getExplainText:)]) {
        [_delegate getExplainText:textView];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
        self.placehoderLabel.text = @"";
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text.length == 0){
        self.placehoderLabel.text = @"补充说明";
    }else{
        self.placehoderLabel.text = @"";
    }
    return YES;
}


- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.text.length == 0){
        self.placehoderLabel.text = @"补充说明";
    }else{
        self.placehoderLabel.text = @"";
    }
    
}

@end
