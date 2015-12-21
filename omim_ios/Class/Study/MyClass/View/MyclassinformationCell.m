//
//  MyclassinformationCell.m
//  dev01
//
//  Created by 杨彬 on 14-10-10.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "MyclassinformationCell.h"
#import "Database.h"
#import "OMClass.h"

#import "NSDate+ClassScheduleDate.h"


@interface MyclassinformationCell ()
@property (retain, nonatomic) IBOutlet UILabel *term;
@property (retain, nonatomic) IBOutlet UILabel *grade;
@property (retain, nonatomic) IBOutlet UILabel *subject;
@property (retain, nonatomic) IBOutlet UILabel *date;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (retain, nonatomic) IBOutlet UILabel *address;

@property (retain, nonatomic) IBOutlet UILabel *lab_Date;
@property (retain, nonatomic) IBOutlet UILabel *lab_time;
@property (retain, nonatomic) IBOutlet UILabel *lab_address;
@property (retain, nonatomic) IBOutlet UILabel *lab_subject;
@property (retain, nonatomic) IBOutlet UILabel *lab_grade;
@property (retain, nonatomic) IBOutlet UILabel *lab_term;
@property (retain, nonatomic) IBOutlet UILabel *title_label;

@end

@implementation MyclassinformationCell

- (void)dealloc {
    [_classModel release];
    [_term release];
    [_grade release];
    [_subject release];
    [_date release];
    [_time release];
    [_address release];
    [_lab_Date release];
    [_lab_time release];
    [_lab_address release];
    [_lab_subject release];
    [_lab_grade release];
    [_lab_term release];
    [_title_label release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"MyclassinformationCellID";
    MyclassinformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyclassinformationCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    
    _lab_term.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"学期",nil)];
    _lab_grade.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"年级",nil)];
    _lab_subject.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"学科",nil)];
    _lab_Date.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"开班日期",nil)];
    _lab_time.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"上课时间",nil)];
    _lab_address.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"地点",nil)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}


-(void)setClassModel:(OMClass *)classModel{
    [_classModel release],_classModel = nil;
    

    _classModel = [classModel retain];
    
    NSArray *introductionArray = [classModel.intro componentsSeparatedByString:@","];
    int count = (int)(introductionArray.count);
    for (int i=0; i<count; i++) {
        switch (i) {
            case 0:{
                _term.text = introductionArray[0];
            }break;
            case 1:{
                 _grade.text = introductionArray[1];
            }break;
            case 2:{
                _subject.text = introductionArray[2];

            }break;
            case 3:{
                _address.text = introductionArray[3];
            }break;
            default:
                break;
        }
    }
    
   
    
    
    self.title_label.text = _classModel.groupNameOriginal;
    
    if (_classModel.start_day.length == 0 || _classModel.end_day.length == 0){
        _date.text = @"";
        
    }else{
        NSString *start_day = [NSDate getDateStringWithTimeInterval:[_classModel.start_day doubleValue]];
        
        NSString *end_day = [NSDate getDateStringWithTimeInterval:[_classModel.end_day doubleValue]];
        
        _date.text = [NSString stringWithFormat:@"%@--%@",start_day,end_day];
    }
    
    if (_classModel.start_time.length == 0 || _classModel.end_time.length == 0){
        _time.text = @"";
    }else{
        
        NSString *start_time = [NSDate getTimeStringWithTimeInterval:[_classModel.start_time doubleValue]];
        
        NSString *end_time = [NSDate getTimeStringWithTimeInterval:[_classModel.end_time doubleValue]];
        
        _time.text = [NSString stringWithFormat:@"%@ - %@",start_time, end_time];
    }
    
}





@end
