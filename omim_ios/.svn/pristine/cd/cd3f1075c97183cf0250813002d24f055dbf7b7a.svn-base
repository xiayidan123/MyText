//
//  AskView.m
//  dev01
//
//  Created by 杨彬 on 14-10-16.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "AskView.h"

@implementation AskView
{
    CGFloat _h;
    NSMutableArray *_dataArray;
}


- (void)dealloc {
    [_dataArray release];
    [_upBgView release];
    [_downBgView release];
    [_title_question release];
    [_question_bgView release];
    [_lal_question release];
    [_lal_answerA release];
    [_lal_answerB release];
    [_lal_answerC release];
    [_dividinglineA release];
    [_dividinglineB release];
    [_imgv_question release];
    [_btn_audio release];
    [_title_answers release];
    [_lal_repeatQuestion release];
    [_dividinglineC release];
    [_imgv_answer release];
    [super dealloc];
}


- (void)loadViewWithFrame:(CGRect)frame andData:(id)data{
    
    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:@"1.当你想知道橡皮放在哪儿时，问："];
    [_dataArray addObject:@"A.Where is the eraser?"];
    [_dataArray addObject:@"B.Where is the pen?"];
    [_dataArray addObject:@"C.Where is it from?"];
    [_dataArray addObject:@3];
    [_dataArray addObject:@12];
    [_dataArray addObject:@0];
    
    [self loadUpView];
    
    _downBgView.frame = CGRectMake(_downBgView.frame.origin.x, _upBgView.frame.origin.y + _upBgView.frame.size.height, _downBgView.frame.size.width, _downBgView.frame.size.height);
    
    [self loadDownView];
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _downBgView.frame.origin.y + _downBgView.frame.size.height);
}


#pragma mark-------upView
- (void)loadUpView{
//    _upBgView.layer.masksToBounds = YES;
    
    [self loadQuestionBgView];
    
    [self loadDividinglineA];
    
    [self loadImgvQuestion];
    
    [self loadDividinglineB];
    
    [self loadButtonAudio];
    
    _upBgView.frame = CGRectMake(_upBgView.frame.origin.x, _upBgView.frame.origin.y, _upBgView.frame.size.width, _h + 5);
}

- (void)loadQuestionBgView{
    [self loadLalQuestion];
    [self loadLalAnswerA];
    [self loadLalAnswerB];
    [self loadLalAnswerC];
    _question_bgView.frame = CGRectMake(_question_bgView.frame.origin.x, _question_bgView.frame.origin.y, _question_bgView.frame.size.width, _h);
    _h = (CGFloat)((NSInteger)(_question_bgView.frame.origin.y + _h)) + 1;
}

- (void)loadLalQuestion{
    _lal_question.text = _dataArray[0];
    CGRect rect = [_lal_question.text boundingRectWithSize:CGSizeMake(_lal_question.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
    _lal_question.frame = CGRectMake(_lal_question.frame.origin.x, _lal_question.frame.origin.y, _lal_question.frame.size.width, rect.size.height);
    _h = (CGFloat)((NSInteger)(rect.size.height + _lal_question.frame.origin.y) + 1);
}

- (void)loadLalAnswerA{
    _lal_answerA.text = _dataArray[1];
    CGRect rect = [_lal_answerA.text boundingRectWithSize:CGSizeMake(_lal_answerA.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
    _lal_answerA.frame = CGRectMake(_lal_answerA.frame.origin.x, _h + 10, _lal_answerA.frame.size.width, rect.size.height);
    _h = (CGFloat)((NSInteger)(rect.size.height + _lal_answerA.frame.origin.y) + 1);
}


- (void)loadLalAnswerB{
    _lal_answerB.text = _dataArray[2];
    CGRect rect = [_lal_answerB.text boundingRectWithSize:CGSizeMake(_lal_answerB.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
    _lal_answerB.frame = CGRectMake(_lal_answerB.frame.origin.x, _h + 10, _lal_answerB.frame.size.width, rect.size.height);
    _h = (CGFloat)((NSInteger)(rect.size.height + _lal_answerB.frame.origin.y) + 1);
}

- (void)loadLalAnswerC{
    _lal_answerC.text = _dataArray[3];
    CGRect rect = [_lal_answerC.text boundingRectWithSize:CGSizeMake(_lal_answerC.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
    _lal_answerC.frame = CGRectMake(_lal_answerC.frame.origin.x, _h + 10, _lal_answerC.frame.size.width, rect.size.height);
    _h = (CGFloat)((NSInteger)(rect.size.height + _lal_answerC.frame.origin.y) + 1);
}

- (void)loadDividinglineA{
    _dividinglineA.frame = CGRectMake(_dividinglineA.frame.origin.x, _h + 5, _dividinglineA.frame.size.width, _dividinglineA.frame.size.height);
    _h = _h + 5 + 1;
}

- (void)loadImgvQuestion{
    for (int i=0; i<[_dataArray[4] integerValue]; i++){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 + (i % 4 )*73.5, 10 + (i/ 4)* 73.5, 68.5, 68.5)];
        imageView.backgroundColor = [UIColor colorWithRed:random()%10 /10.0 green:random()%10 /10.0 blue:random()%10 /10.0 alpha:1];
        [_imgv_question addSubview:imageView];
        [imageView release];
    }
    CGFloat h = 0;
    if ([_dataArray[4] integerValue] % 4 == 0){
        h = 20+ ([_dataArray[4] integerValue] / 4)*73.5 ;
    }else{
        h = 20 + ([_dataArray[4] integerValue] / 4 + 1)*73.5;
    }
    _imgv_question.frame = CGRectMake(_imgv_question.frame.origin.x, _h+1, _imgv_question.frame.size.width, h - 5);
    _h = (CGFloat)((NSInteger)(_imgv_question.frame.origin.y + _imgv_question.frame.size.height ) + 1);
}

- (void)loadDividinglineB{
    _dividinglineB.frame = CGRectMake(_dividinglineB.frame.origin.x, _h, _dividinglineB.frame.size.width, _dividinglineB.frame.size.height);
    _h = _h + 1;
}

- (void)loadButtonAudio{
    _btn_audio.layer.borderWidth = 0.5;
    _btn_audio.layer.cornerRadius = 5;
    _btn_audio.layer.borderColor = [UIColor blackColor].CGColor;
    _btn_audio.frame = CGRectMake(_btn_audio.frame.origin.x, _h + 10, _btn_audio.frame.size.width, _btn_audio.frame.size.height);
    _h = (CGFloat)((NSInteger)(_btn_audio.frame.origin.y + _btn_audio.frame.size.height + 1));
}

#pragma mark----downView
- (void)loadDownView{
    [self loadLalrepeatQuestion];
    
    [self loadDividinglineC];
    
    [self loadImgvanswer];
}

- (void)loadLalrepeatQuestion{
    _lal_repeatQuestion.text = _dataArray [[_dataArray[6] integerValue] + 1];
    CGRect rect = [_lal_repeatQuestion.text boundingRectWithSize:CGSizeMake(_lal_repeatQuestion.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
    _lal_repeatQuestion.frame = CGRectMake(_lal_repeatQuestion.frame.origin.x, _lal_repeatQuestion.frame.origin.y, _lal_repeatQuestion.frame.size.width, rect.size.height);
    _h = (CGFloat)((NSInteger)(rect.size.height + _lal_repeatQuestion.frame.origin.y) + 1);
    
}


- (void)loadDividinglineC{
    _dividinglineC.frame = CGRectMake(_dividinglineC.frame.origin.x, _h + 5, _dividinglineC.frame.size.width, _dividinglineC.frame.size.height);
    _h = _h + 1;
}

- (void)loadImgvanswer{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 , 10 , 68.5, 68.5)];
    imageView.backgroundColor = [UIColor colorWithRed:random()%10 /10.0 green:random()%10 /10.0 blue:random()%10 /10.0 alpha:1];
    [_imgv_answer addSubview:imageView];
    [imageView release];
    _imgv_answer.frame = CGRectMake(_imgv_answer.frame.origin.x, _h + 1, _imgv_answer.frame.size.width, 70);
}


@end
