//
//  GalleryView.m
//  dev01
//
//  Created by 杨彬 on 14-10-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "GalleryView.h"

@implementation GalleryView
{
    CGFloat _w;
    NSInteger addButtonIndex;
    long int _photoBtnNumber;
    UIButton *_addBtn;
}


-(void)dealloc{
    [_addBtn release];
    [_addImageCB release];
    [super dealloc];
}


- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array andEveryRowNumber:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        _w = (frame.size.width - 30 - index * 10)/index;
        addButtonIndex = array.count + 1;
        _photoBtnNumber = 0;
        self.userInteractionEnabled = YES;
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _addBtn.frame = CGRectMake(15 , 15  ,_w, _w);
        [_addBtn setImage:[UIImage imageNamed:@"share_new_add_photo"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.tag = 100;
        [self addSubview:_addBtn];
        
        if ((array.count + 1)%4  == 0){
            self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 20 + (array.count + 1)/4*(_w + 10 ) );
        }else{
            self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 20 + ((array.count + 1)/4 + 1)*(_w + 10));
        }
    }
    return self;
}

- (instancetype)initNotAddWithFrame:(CGRect)frame andArray:(NSArray *)array andEveryRowNumber:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = (frame.size.width - 30 - index * 10)/index;
        for (int i=0; i<array.count; i++){
            UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(15 + (width + 10) * (i%4), 15 + i/4 * (width + 10), width, width)];
            imgv.backgroundColor = [UIColor colorWithRed:arc4random()%10 *0.1 green:arc4random()%10 *0.1 blue:arc4random()%10 *0.1 alpha:1];
            [self addSubview:imgv];
            [imgv release];
            
        }
        if ((array.count)%4  == 0){
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, 20 + (array.count/4 )*(width + 10 ) );
        }else{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 20 + ((array.count)/4 + 1)*(width + 10));
        }
    }
    return self;
}

- (void)addImageAction{
    if (_photoBtnNumber <= 6){
        _addImageCB(addButtonIndex);
    }
    addButtonIndex++;
}

-(void)loadPhotoWithArray{
    UIButton *newPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newPhotoBtn.frame = CGRectMake(15 , 15  ,_w, _w);
    newPhotoBtn.backgroundColor = [UIColor colorWithRed:arc4random()%10 *0.1 green:arc4random()%10 *0.1 blue:arc4random()%10 *0.1 alpha:1];
    [newPhotoBtn setTitle:[NSString stringWithFormat:@"%ld",_photoBtnNumber + 1] forState:UIControlStateNormal];
    newPhotoBtn.tag = ((_photoBtnNumber++) + 100);
    newPhotoBtn.center = _addBtn.center;
    [self addSubview:newPhotoBtn];
    
    CGPoint nextPoint = CGPointMake(15 + _photoBtnNumber % 4 * (_w + 10) + _w/2, 15 + _photoBtnNumber / 4 *(_w + 10) + _w/2);
    _addBtn.center = nextPoint;
    
    if ((_photoBtnNumber + 1)%4  == 0){
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, 20 + (_photoBtnNumber + 1)/4*(_w + 10 ) );
    }else{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 20 + ((_photoBtnNumber + 1)/4 + 1)*(_w + 10));
    }
}




@end