//
//  GalleryView.h
//  dev01
//
//  Created by 杨彬 on 14-10-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryView : UIView

@property (nonatomic,copy)void(^addImageCB)(NSInteger);

- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array andEveryRowNumber:(NSInteger)index;

- (instancetype)initNotAddWithFrame:(CGRect)frame andArray:(NSArray *)array andEveryRowNumber:(NSInteger)index;

-(void)loadPhotoWithArray;

@end
