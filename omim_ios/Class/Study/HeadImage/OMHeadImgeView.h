//
//  OMHeadImgeView.h
//  dev01
//
//  Created by 杨彬 on 15/1/26.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Buddy.h"
#import "UserGroup.h"

typedef NS_ENUM(NSInteger, OMHeadImageViewIdentityType) {
    Teacher_OMHeadImageViewIdentity,
    Student_OMHeadImageViewIdentity
};

typedef NS_ENUM(NSInteger, OMHeadImageViewShapeType) {
    Circle_OMHeadImageViewType,
    Square_OMHeadImageViewType
};

@interface OMHeadImgeView : UIView

// 头像照片
@property (nonatomic,retain)UIImage *headImage;

// 用户model
@property (nonatomic,retain)Buddy *buddy;

/** 用户ID */
//@property (copy, nonatomic) NSString * buddy_id;

/** 群组 */
@property (retain, nonatomic) UserGroup * group;

// 用户身份
@property (nonatomic,assign)OMHeadImageViewIdentityType identityType;

// 头像形状
@property (nonatomic,assign)OMHeadImageViewShapeType shapeType;

// 头像圆角 （用于特殊圆角情况）
@property (nonatomic,assign)CGFloat headImageCornerRadius;

+ (instancetype)headImageView;



@end
