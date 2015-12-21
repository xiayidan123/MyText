//
//  LessonCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LessonCell.h"
#import "Lesson.h"
#import "NSDate+ClassScheduleDate.h"
#import "ClasstimetableCell.h"

@interface LessonCell ()

@property (retain, nonatomic) IBOutlet UILabel *title_label;

@property (retain, nonatomic) IBOutlet UILabel *date_label;

@property (retain, nonatomic) IBOutlet UILabel *status_label;

@end


@implementation LessonCell

- (void)dealloc {
    [_lesson release];
    [_title_label release];
    [_date_label release];
    [_status_label release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *cellID = @"LessonCellid";
    LessonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LessonCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


-(void)setLesson:(Lesson *)lesson{
    [_lesson release],_lesson = nil;
    _lesson = [lesson retain];
    
    self.title_label.text = _lesson.title;
    
    
    NSTimeInterval currentTimeInterval = [NSDate ZeropointWihtDate:[NSDate date]];
    
    NSTimeInterval startTimeInterval = [NSDate ZeropointWihtTimeIntervalString:_lesson.start_date];
    
    if (currentTimeInterval > startTimeInterval){
        self.title_label.textColor = [UIColor colorWithRed:0.4 green:0.59 blue:0.98 alpha:1];
    }else if (currentTimeInterval == startTimeInterval){
        self.title_label.textColor = [UIColor redColor];
    }else{
        self.title_label.textColor = [UIColor blackColor];
    }
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startStr = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_lesson.start_date integerValue]]];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *endStr = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_lesson.end_date integerValue]]];
    self.date_label.text =  [NSString stringWithFormat:@"%@ ~ %@",startStr,endStr];
    [dateFormat release];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
