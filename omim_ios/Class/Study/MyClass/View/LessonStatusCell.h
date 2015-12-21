//
//  LessonStatusCell.h
//  dev01
//
//  Created by 杨彬 on 14-12-30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonPerformanceModel.h"
#import "RadioButtonView.h"
#import "SchoolMember.h"

@protocol LessonStatusCellDelegate <NSObject>

@optional

- (void)didSelectedStatusWithPropertyID:(NSInteger)property_id withIndex:(NSInteger )index;

- (void)didSelect_sign_in_status_withStudent_id:(NSString *)student_id withIndex:(NSInteger)index;


@end

@interface LessonStatusCell : UITableViewCell<RadioButtonViewDelegate>

@property (retain, nonatomic)id <LessonStatusCellDelegate>delegate;

@property (retain, nonatomic)LessonPerformanceModel *lessonPerformanceModel;

@property (retain, nonatomic)SchoolMember *schoolMember;
@property (assign, nonatomic) BOOL enabledSelect;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
