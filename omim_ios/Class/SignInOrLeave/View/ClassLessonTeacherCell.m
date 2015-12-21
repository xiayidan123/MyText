//
//  ClassLessonTeacherCell.m
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassLessonTeacherCell.h"
#import "OMClass.h"
#import "Lesson.h"
#import "SchoolMember.h"
@interface ClassLessonTeacherCell()
@property (retain, nonatomic) IBOutlet UILabel *name_label;
@property (retain, nonatomic) IBOutlet UILabel *date_label;

@end



@implementation ClassLessonTeacherCell
- (void)dealloc {
    self.classModel = nil;
    self.teacherModel = nil;
    self.lesson = nil;
    [_name_label release];
    [_date_label release];
    [super dealloc];
}

- (void)setTeacherModel:(SchoolMember *)teacherModel
{
    if (_teacherModel != teacherModel) {
        [_teacherModel release];
        _teacherModel = [teacherModel retain];
        self.name_label.text = teacherModel.alias;
    }
}

- (void)setLesson:(Lesson *)lesson
{
    if (_lesson != lesson) {
        [_lesson release];
        _lesson = [lesson retain];
        self.name_label.text = [NSString stringWithFormat:@"%@",lesson.title];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *startStr = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_lesson.start_date integerValue]]];
        self.date_label.text = startStr;
    }
}
- (void)setClassModel:(OMClass *)classModel
{
    if (_classModel != classModel) {
        [_classModel release];
        _classModel = [classModel retain];
        self.name_label.text = classModel.groupNameOriginal;
    }    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"list";
    ClassLessonTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassLessonTeacherCell" owner:nil options:nil] firstObject];
    }
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
