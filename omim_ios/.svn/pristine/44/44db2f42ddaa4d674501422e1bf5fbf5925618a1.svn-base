//
//  StudentListCell.m
//  dev01
//
//  Created by 杨彬 on 14-12-30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "StudentListCell.h"
#import "LessonPerformanceModel.h"
#import "WowTalkWebServerIF.h"
#import "Database.h"
#import "Buddy.h"

@interface StudentListCell ()

@property (retain, nonatomic) IBOutlet UILabel *lab_name;
@property (retain, nonatomic) IBOutlet UILabel *lab_state;


@end

@implementation StudentListCell

- (void)dealloc {
    [_lab_name release];
    [_lab_state release];
    
    [_lesson_id release];
    [_studentModel release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"StudentListCellID";
    StudentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudentListCell" owner:nil options:nil] lastObject];
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

-(void)setStudentModel:(PersonModel *)studentModel{
    _studentModel = [studentModel retain];
    if (_lesson_id){
        [self loadCell];
    }
}


-(void)setLesson_id:(NSString *)lesson_id{
    _lesson_id = [lesson_id copy];
    if (_studentModel){
        [self loadCell];
    }
}

- (void)setLesson:(LessonPerformanceModel *)lesson{
    _lesson = [lesson retain];
    if (_lesson) {
        [WowTalkWebServerIF getBuddyWithUID:lesson.student_id withCallback:@selector(didGetBuddy:) withObserver:self];
        
    }
}

- (void)didGetBuddy:(NSNotification *)notif{
    _lab_name.text = [Database fetchStudentInClassWithStudentID:_lesson.student_id withClassID:self.class_id].alias;;
    NSLog(@"%@",_lab_name.text);
    _lab_state.hidden = YES;
}

- (void)loadCell{
    _lab_name.text = _studentModel.alias;
    _lab_state.hidden = YES;
}

@end
