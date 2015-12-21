//
//  YBAttrbutedLabel.h
//  YBAttributedLabelTest
//
//  Created by 杨彬 on 15/4/29.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YBAttrbutedModel : NSObject


@property (assign, nonatomic) NSRange range;

@property (copy, nonatomic) NSString * text;

@property (strong, nonatomic) id data;


@end



@class YBAttrbutedLabel;

@protocol YBAttrbutedLabelDelegate <NSObject>

- (void)YBAttrbutedLabel:(YBAttrbutedLabel *)label click:(YBAttrbutedModel *)model;

@end


@interface YBAttrbutedLabel : UILabel

@property (weak, nonatomic) id  <YBAttrbutedLabelDelegate>delegate;

@property (strong, nonatomic) NSMutableArray * link_array;

@end
