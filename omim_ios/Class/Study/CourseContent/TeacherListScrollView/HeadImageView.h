//
//  HeadImageView.h
//  dev01
//
//  Created by 杨彬 on 14-12-27.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"

@protocol HeadImageViewDelegate <NSObject>

- (void)clickHeadImageWith:(PersonModel *)teacherModel;

@end


@interface HeadImageView : UIView

@property (nonatomic,retain)PersonModel *teacherModel;
@property (nonatomic,assign)id<HeadImageViewDelegate>delegate;

@end
