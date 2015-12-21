//
//  LessonStatusCell.m
//  dev01
//
//  Created by 杨彬 on 14-12-30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "LessonStatusCell.h"

@interface LessonStatusCell ()

@property (retain, nonatomic) IBOutlet UILabel *lab_title;
@property (retain, nonatomic) IBOutlet UILabel *lab_subTitle;

@end



@implementation LessonStatusCell

-(void)dealloc{
    [_lessonPerformanceModel release];
    [_lab_title release];
    [_lab_subTitle release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"LessonStatusCellID";
    LessonStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LessonStatusCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSchoolMember:(SchoolMember *)schoolMember{
    _schoolMember = [schoolMember retain];
    _lab_title.text = schoolMember.alias;
    _lab_subTitle.text = nil;
    
    RadioButtonView *radioButtonView = (RadioButtonView *)[self.contentView viewWithTag:200];
    if (!radioButtonView){
        radioButtonView = [[RadioButtonView alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width/2, 0, 140, 44)];
        radioButtonView.tag = 200;
        radioButtonView.delegate = self;
        radioButtonView.numberOfSelectPart = 3;
        radioButtonView.selectIndex = 2;
        [self.contentView addSubview:radioButtonView];
        [radioButtonView release];
    }
    radioButtonView.selectIndex = 2;
    radioButtonView.enabledSelect = _enabledSelect;
}

-(void)setLessonPerformanceModel:(LessonPerformanceModel *)lessonPerformanceModel{
    _lessonPerformanceModel = [lessonPerformanceModel retain];
    _lab_title.text = _lessonPerformanceModel.property_name;
    _lab_subTitle.text = nil;
    
    RadioButtonView *radioButtonView = (RadioButtonView *)[self.contentView viewWithTag:200];
    if (!radioButtonView){
        radioButtonView = [[RadioButtonView alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width/2, 0, 140, 44)];
        radioButtonView.tag = 200;
        radioButtonView.delegate = self;
        radioButtonView.numberOfSelectPart = 3;
        [self.contentView addSubview:radioButtonView];
        [radioButtonView release];
    }
    radioButtonView.selectIndex = [_lessonPerformanceModel.property_value integerValue] - 1;
//    if (radioButtonView.selectIndex == 1) {
//        radioButtonView.enabledSelect = NO;
//    }
//    else{
        radioButtonView.enabledSelect = _enabledSelect;
//    }
    

}


#pragma mark - RadioButtonViewDelegate

-(void)didSeletedWithIndex:(NSInteger)selectIndex{
    if ([_delegate respondsToSelector:@selector(didSelectedStatusWithPropertyID:withIndex:)]){
        [_delegate didSelectedStatusWithPropertyID:_lessonPerformanceModel.property_id withIndex:selectIndex];
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelect_sign_in_status_withStudent_id:withIndex:)]){
        [self.delegate didSelect_sign_in_status_withStudent_id:self.lessonPerformanceModel.student_id withIndex:selectIndex];
    }
    
}


@end
