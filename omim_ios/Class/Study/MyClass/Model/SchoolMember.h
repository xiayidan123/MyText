//
//  SchoolMember.h
//  dev01
//
//  Created by 杨彬 on 15/3/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Buddy.h"

typedef NS_ENUM(NSInteger, SchoolMemberHomeworkState) {
    SchoolMemberHomeworkState_NoSubmit = 0,// 未提交
    SchoolMemberHomeworkState_Submit = 1,// 已提交
    SchoolMemberHomeworkState_DidModify = 2,// 已批改
    SchoolMemberHomeworkState_DidRemind // 已提醒
};



@interface SchoolMember : Buddy

@property (copy, nonatomic)NSString *class_id;
/**状态 state // 0：未提交，1：已提交；2：已批改 */
@property (copy, nonatomic)NSString *state;

/**   */
@property (assign, nonatomic) SchoolMemberHomeworkState homework_state;

/**管理后台名称 */
@property (copy, nonatomic)NSString *schoolName;
/**学生提交作业的id */
@property (copy, nonatomic) NSString * homework_result_id;
- (instancetype)initWithDict:(NSDictionary *)dic;


+ (instancetype)SchoolMemberWithDic:(NSDictionary *)dic;

@end
