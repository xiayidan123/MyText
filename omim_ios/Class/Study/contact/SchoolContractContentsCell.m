//
//  SchoolContractContentsCell.m
//  dev01
//
//  Created by 杨彬 on 14-12-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "SchoolContractContentsCell.h"

@implementation SchoolContractContentsCell



- (void)dealloc {
    [_imageView_mark release];
    [_lab_title release];
    [_btn_beginGroupChat release];
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
    
    
    
}

- (void)setIsHideGroupBtn:(BOOL)IsHideGroupBtn{
    _isHideGroupBtn = IsHideGroupBtn;
    if (_isHideGroupBtn) {
        _btn_beginGroupChat.hidden = YES;
        _btn_beginGroupChat.enabled = NO;
    }else{
        _btn_beginGroupChat.hidden = NO;
        _btn_beginGroupChat.enabled = YES;
    }
}
-(void)setIsClass:(BOOL *)isClass{
    _isClass = isClass;
    if (_isClass){
        _btn_beginGroupChat.hidden = NO;
        _btn_beginGroupChat.enabled = YES;
    }else{
        _delegate = nil;
        _btn_beginGroupChat.hidden = YES;
        _btn_beginGroupChat.enabled = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (_raDataObject.isOpen){
//        _imageView_mark.layer.anchorPoint = CGPointMake(0.5, 0.5);
//        _imageView_mark.layer.position = CGPointMake(_imageView_mark.frame.origin.x + _imageView_mark.frame.size.width/2, _imageView_mark.frame.origin.y + _imageView_mark.frame.size.height/2);
//        _imageView_mark.layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
//        
//    }else{
//        _imageView_mark.layer.anchorPoint = CGPointMake(0.5, 0.5);
//        _imageView_mark.layer.position = CGPointMake(_imageView_mark.frame.origin.x + _imageView_mark.frame.size.width/2, _imageView_mark.frame.origin.y + _imageView_mark.frame.size.height/2);
//        _imageView_mark.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
//    }
}


-(void)setLevel:(NSInteger )Level{
    _lab_title.frame = CGRectMake(_lab_title.frame.origin.x + Level*20, _lab_title.frame.origin.y, _lab_title.frame.size.width, _lab_title.frame.size.height);
}



-(void)setRaDataObject:(RADataObject *)raDataObject{
    _raDataObject = raDataObject;
}


- (void)state{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 10, 10, 10)];
    view.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:view];
    
    if (_raDataObject.isOpen){
        _imageView_mark.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _imageView_mark.layer.position = CGPointMake(_imageView_mark.frame.origin.x + _imageView_mark.frame.size.width/2, _imageView_mark.frame.origin.y + _imageView_mark.frame.size.height/2);
        _imageView_mark.layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
        
    }else{
        _imageView_mark.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _imageView_mark.layer.position = CGPointMake(_imageView_mark.frame.origin.x + _imageView_mark.frame.size.width/2, _imageView_mark.frame.origin.y + _imageView_mark.frame.size.height/2);
        _imageView_mark.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    }
}

- (IBAction)clickBeginGroupChat:(id)sender {
    if ([_delegate respondsToSelector:@selector(beginGroupChatWithRAObject:)]){
        [_delegate beginGroupChatWithRAObject:_raDataObject];
    }
}




@end
