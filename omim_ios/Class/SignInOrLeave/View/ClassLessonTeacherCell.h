//
//  ClassLessonTeacherCell.h
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMClass;
@class Lesson;
@class SchoolMember;
@interface ClassLessonTeacherCell : UITableViewCell

@property (retain, nonatomic) OMClass *classModel;
@property (retain, nonatomic) Lesson *lesson;
@property (retain, nonatomic) SchoolMember *teacherModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
