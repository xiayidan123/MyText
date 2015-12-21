//
//  AskQuestionView.m
//  dev01
//
//  Created by 杨彬 on 14-10-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "AskQuestionView.h"
#import "GalleryView.h"

@implementation AskQuestionView
{
    GalleryView *_ImgView;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_lal_Prompt release];
    [_TV_Question release];
    [_dividinglineA release];
    [_dividinglineB release];
    [_btn_audio release];
    [super dealloc];
}


- (void)loadAskQuestionView{
    self.backgroundColor = [UIColor whiteColor];
    _ImgView = [[GalleryView alloc]initWithFrame:CGRectMake(0, _dividinglineA.frame.origin.y + _dividinglineA.frame.size.height, self.frame.size.width, 50) andArray:nil andEveryRowNumber:4];
    [_ImgView setAddImageCB:^(NSInteger index) {
        [self endEditing:YES];
        [_ImgView loadPhotoWithArray];
        [self adjustPosition];
    }];
    [self addSubview:_ImgView];
    
    self.userInteractionEnabled = YES;
    _TV_Question.delegate = self;
    _btn_audio.layer.borderWidth = 0.5;
    _btn_audio.layer.cornerRadius = 5;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
}

- (void)adjustPosition{
    [UIView animateWithDuration:0.5 animations:^{
        _dividinglineA.frame = CGRectMake(_dividinglineA.frame.origin.x, _TV_Question.frame.origin.y + _TV_Question.frame.size.height , _dividinglineA.frame.size.width, _dividinglineA.frame.size.height);
        
        _ImgView.frame =CGRectMake(_ImgView.frame.origin.x, _dividinglineA.frame.origin.y + _dividinglineA.frame.size.height, _ImgView.frame.size.width , _ImgView.frame.size.height);
        
        _dividinglineB.frame = CGRectMake(_dividinglineB.frame.origin.x, _ImgView.frame.origin.y + _ImgView.frame.size.height, _dividinglineB.frame.size.width, _dividinglineB.frame.size.height);
        
        _btn_audio.frame = CGRectMake(_btn_audio.frame.origin.x, _dividinglineB.frame.origin.y + _dividinglineB.frame.size.height + 10, _btn_audio.frame.size.width, _btn_audio.frame.size.height);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _btn_audio.frame.origin.y + _btn_audio.frame.size.height + 10);
    }];
}

- (void)textChanged:(NSNotificationCenter *)not{
    CGRect newRect = [_TV_Question.text boundingRectWithSize:CGSizeMake(_TV_Question.frame.size.width, 1000) options:NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName,nil] context:nil];
    if((newRect.size.height + 20) > _TV_Question.frame.size.height){
        _TV_Question.frame = CGRectMake(_TV_Question.frame.origin.x, _TV_Question.frame.origin.y, _TV_Question.frame.size.width, newRect.size.height + 20);
        [self adjustPosition];
    }
}

#pragma mark-----------textView
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _lal_Prompt.alpha = 0;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]){
        _lal_Prompt.alpha = 1;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return YES;
}



@end
