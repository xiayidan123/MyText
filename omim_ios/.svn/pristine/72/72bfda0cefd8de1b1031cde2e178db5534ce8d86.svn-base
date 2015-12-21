//
//  EditClassInfomationCell.m
//  dev01
//
//  Created by 杨彬 on 15/2/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "EditClassInfomationCell.h"
#import "EditClassInformationModel.h"

@interface EditClassInfomationCell ()<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UITextField *content;
@property (retain, nonatomic) UIView *datePickerBgView;
@property (retain, nonatomic) UIDatePicker *datePicker;
@property (assign, nonatomic) BOOL canOpen;

@end


@implementation EditClassInfomationCell

- (void)dealloc {
    [_editClassInfoModel release],_editClassInfoModel = nil;
    [_title release];
    [_content release];
    [_datePicker release];
    [_datePickerBgView release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *EditClassInfomationCellID = @"EditClassInfomationCellID";
    EditClassInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:EditClassInfomationCellID];
    if (cell == nil){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EditClassInfomationCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


-(void)setEditClassInfoModel:(EditClassInformationModel *)editClassInfoModel{
    _editClassInfoModel = [editClassInfoModel retain];
    
    [self.datePicker removeFromSuperview];
    [self.datePicker release],self.datePicker = nil;
    
    [self.datePickerBgView removeFromSuperview];
    [self.datePickerBgView release],self.datePickerBgView = nil;
    
    self.title.text = [NSString stringWithFormat:@"%@:",_editClassInfoModel.title];
    self.content.text = _editClassInfoModel.content;
    
    if (self.editClassInfoModel.type == EditClassInformationModelDefault){
        self.content.enabled = YES;
        self.canOpen = NO;
    }else {
        [self prepareData];
    }
}

- (void)prepareData{
    self.content.enabled = NO;
    self.canOpen = YES;
    
    [self loadDatePicker];
}

- (void)loadDatePicker{
    self.datePickerBgView = [[UIView alloc]init];
    self.datePickerBgView.layer.masksToBounds = YES;
    self.datePickerBgView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.datePickerBgView];
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.datePickerBgView.bounds.size.width, 196)];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    if (self.editClassInfoModel.type == EditClassInformationModelDate){
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    }else{
        [dateFormat setDateFormat:@"HH:mm"];
        self.datePicker.datePickerMode = UIDatePickerModeTime;
    }
    NSDate *date =[dateFormat dateFromString:self.editClassInfoModel.content];
    [self.datePicker setDate:date];
    [dateFormat release];
    [self.datePickerBgView addSubview:self.datePicker];
    
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    enterBtn.frame = CGRectMake(0, 196, self.datePickerBgView.bounds.size.width, 44);
    [enterBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.datePickerBgView addSubview:enterBtn];
}

- (void)awakeFromNib {
    self.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.content.delegate = self;
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)]];
}


- (void)clickAction:(UITapGestureRecognizer *)tap{
    if (self.canOpen){// 拥有时间选择器
        self.editClassInfoModel.isOpen = ! self.editClassInfoModel.isOpen;
        if ([self.delegate respondsToSelector:@selector(editClassInfomationCell:didChangeStatus:)]){
            [self.delegate editClassInfomationCell:self didChangeStatus:self.editClassInfoModel];
        }
        if (self.editClassInfoModel.isOpen){
            [UIView animateWithDuration:0.5 animations:^{
                self.datePickerBgView.layer.frame = CGRectMake(0, 0, self.datePickerBgView.frame.size.width, 240);
                [self.datePickerBgView layoutIfNeeded];
            }];
        }
        
        
    }else{// 没有时间选择器
        if ([self.delegate respondsToSelector:@selector(editClassInfomationCell:endEdit:)]){
            [self.delegate editClassInfomationCell:self endEdit:self.editClassInfoModel];
        }
    }
}


- (void)enterAction:(UIButton *)btn{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _editClassInfoModel.content = self.content.text;
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.editClassInfoModel.type == EditClassInformationModelDefault){
        return YES;
    }else if (self.editClassInfoModel.type == EditClassInformationModelDate){
        
        return NO;
    }else if (self.editClassInfoModel.type == EditClassInformationModelTime){
        return NO;
    }else{
        return NO;
    }
}


@end
