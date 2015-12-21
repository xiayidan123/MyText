//
//  ClasstimetableCell.m
//  dev01
//
//  Created by 杨彬 on 14-10-11.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ClasstimetableCell.h"
#import "NSDate+ClassScheduleDate.h"
#import "Lesson.h"


@interface ClasstimetableCell ()

@property (retain, nonatomic) IBOutlet UILabel *lal_className;

@property (retain, nonatomic) IBOutlet UILabel *lal_time;

@property (retain, nonatomic) IBOutlet UILabel *lal_status;



@end


@implementation ClasstimetableCell

- (void)dealloc {
    [_lal_className release],_lal_className = nil;
    [_lal_time release],_lal_time = nil;
    [_lal_status release],_lal_status = nil;
    
    [_lesson release];
    
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *classtimetableid = @"classtimetableid";
    ClasstimetableCell *cell = [tableView dequeueReusableCellWithIdentifier:classtimetableid];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClasstimetableCell" owner:self options:nil] lastObject];
    }
    return cell;
}


-(void)setLesson:(Lesson *)lesson{
    if (![lesson isKindOfClass:[Lesson class]]){
        self.textLabel.text = NSLocalizedString(@"Data error",nil);
        return;
    }
    [_lesson release],_lesson = nil;
    _lesson = [lesson retain];
    
    self.lal_className.text = _lesson.title;
    
    NSTimeInterval start_TimeInterval =  [_lesson.start_date floatValue];
    NSTimeInterval end_timeInterval = [_lesson.end_date floatValue];
    NSTimeInterval now_TimeInterval = [[NSDate date] timeIntervalSince1970];
    
    if (now_TimeInterval > end_timeInterval){// 已结束
        self.lal_className.textColor = [UIColor lightGrayColor];
        self.lal_time.textColor = [UIColor lightGrayColor];
        self.lal_status.hidden = YES;
    }else if (now_TimeInterval < start_TimeInterval){// 还未开始
        self.lal_className.textColor = [UIColor blackColor];
        self.lal_time.textColor = [UIColor blackColor];
        self.lal_status.hidden = YES;
    }else {// 正在进行
        self.lal_className.textColor = [UIColor colorWithRed:0.99 green:0.4 blue:0.2 alpha:1];
        self.lal_time.textColor = [UIColor colorWithRed:0.99 green:0.4 blue:0.2 alpha:1];
        if ([_lesson.live boolValue]){
            self.lal_status.hidden = NO;
        }else{
            self.lal_status.hidden = YES;
        }
    }
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startStr = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:start_TimeInterval]];
    _lal_time.text =  startStr;
    [dateFormat release];
}



@end
