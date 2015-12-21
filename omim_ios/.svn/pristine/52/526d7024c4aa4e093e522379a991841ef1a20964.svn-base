//
//  UploadParentsOpinionView.m
//  dev01
//
//  Created by 杨彬 on 15-1-1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "UploadParentsOpinionView.h"
#import "Colors.h"

@implementation UploadParentsOpinionView


- (void)dealloc {
    [_textView_text release];
    [_btn_audio release];
    [super dealloc];
}



- (IBAction)addAudioAction:(id)sender {
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadTextView];
        
    }
    return self;
}


- (void)loadTextView{
    _textView_text = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(16, 5, 288, 90)];
    _textView_text.tag = 104;
    _textView_text.delegate = self;
    [self buildInputTextView];
    
    
}
-(void)buildInputTextView{
    _textView_text.font = [UIFont systemFontOfSize:17];
    [self addSubview:_textView_text];
    
}


- (void)setText_placeholder:(NSString *)text_placeholder{
    if (_text_placeholder != text_placeholder) {
        [_text_placeholder release];
        _text_placeholder = [text_placeholder retain];
        _textView_text.placeholder = NSLocalizedString(self.text_placeholder, nil);
    }
}






@end
