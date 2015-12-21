//
//  EditClassInformationTableVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "EditClassInformationTableVC.h"

#import "PublicFunctions.h"

#import "WowTalkWebServerIF.h"
#import "WTHeader.h"
#import "OMNetWork_MyClass.h"

#import "OMClass.h"
#import "OMBaseCellFrameModel.h"
#import "OMBaseTextFieldCell.h"
#import "OMBaseDatePickerCell.h"

#import "ClassScheduleModel.h"
#import "NSDate+ClassScheduleDate.h"

#import "Lesson.h"



@interface EditClassInformationTableVC ()<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,OMBaseTextFieldCellDelegate,OMBaseDatePickerCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView *inforTableView;
@property (retain, nonatomic) NSMutableArray *infoArray;

@property (assign, nonatomic) BOOL canEdit;

@end

@implementation EditClassInformationTableVC

- (void)dealloc {
    
    [_lessonArray release],_lessonArray = nil;
    
    [_classModel release],_classModel = nil;
    
    [_inforTableView release],_inforTableView.delegate = nil,_inforTableView.dataSource = nil,_inforTableView = nil;
    [_infoArray release],_infoArray = nil;
    [super dealloc];
}


-(void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    
    [self configNavigation];
    
    [self uiConfig];
}


#pragma mark - prepareData


- (NSMutableArray *)infoArray{
    if (_infoArray == nil){
        _infoArray = [[NSMutableArray alloc]init];
        NSArray *introductionArray = [_classModel.intro componentsSeparatedByString:@","];
        NSArray *titleArray = @[NSLocalizedString(@"学期",nil),NSLocalizedString(@"年级",nil),NSLocalizedString(@"学科",nil),NSLocalizedString(@"地点",nil),NSLocalizedString(@"开始日期",nil),NSLocalizedString(@"结束日期",nil),NSLocalizedString(@"上课时间",nil),NSLocalizedString(@"结束时间",nil)];
        NSInteger arrayCount = titleArray.count;
        NSInteger introCount = introductionArray.count;
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        if ([self.classModel.start_time length] > 0){
            self.canEdit = NO;
        }else {
            self.canEdit = YES;
        }
        
        for (int i=0; i< arrayCount; i++){
            NSString *content = nil;
            OMBaseCellModelType type;
            if(i>=0 && i<=3){
                type = OMBaseCellModelTypeTextField;
                if (introCount > i){
                    content = introductionArray[i];
                }
                
                if (content == nil) content = @"";
                
            }else if (i ==4 || i==5){
                type = OMBaseCellModelTypeDatePicker;
            }else if (i == 6){
                type = OMBaseCellModelTypeTimePicker;
            }else {
                type = OMBaseCellModelTypeCountDownTimer;
            }

            switch (i) {
                case 4:{
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    content = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.classModel.start_day doubleValue]]];
                    if ([content isEqualToString:@""] || content == nil || self.classModel.start_day == nil){
                        content = [dateFormat stringFromDate:[NSDate date]];
                    }
                }break;
                case 5:{
                     [dateFormat setDateFormat:@"yyyy-MM-dd"];
                     content = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.classModel.end_day doubleValue]]];
                    if ([content isEqualToString:@""] || content == nil || self.classModel.end_day == nil){
                        content = [dateFormat stringFromDate:[NSDate date]];
                    }
                }break;
                case 6:{
                    [dateFormat setDateFormat:@"HH:mm"];
                    content = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.classModel.start_time doubleValue]]];
                    if ([content isEqualToString:@""] || content == nil){
                        content = [dateFormat stringFromDate:[NSDate date]];
                    }
                }break;
                case 7:{;
                    content = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.classModel.end_time doubleValue]]];
                    if ([content isEqualToString:@""] || content == nil){
                        content = @"00:00";
                    }
                }break;
                default:
                    break;
            }
            
            NSDictionary *dic = @{@"title": titleArray[i] , @"content": content ,@"type" : @(type)};
            OMBaseCellFrameModel *cellFrameModel = [[OMBaseCellFrameModel alloc]init];
            cellFrameModel.isOpen = NO;
            if (self.canEdit || (i >=0 && i<= 5)){
                cellFrameModel.canEdit = YES;
            }else {
                cellFrameModel.canEdit = NO;
            }
            
            cellFrameModel.cellModel = [OMBaseCellModel OMBaseCellModelWithDic:dic];
            [_infoArray addObject:cellFrameModel];
            [cellFrameModel release];
        }
        [dateFormat release];
    }
    return _infoArray;
}


- (void)configNavigation{
    
    self.title = NSLocalizedString(@"班级信息", nil);
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"取消",nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"保存",nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)] autorelease];
}

- (void)cancelButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)saveAction{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"班级上课时间创建后无法再修改，老师可以通过排课时再选择临时更换上课时间", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"返回修改时间",nil) otherButtonTitles:NSLocalizedString(@"确认创建班级", nil), nil];
    alertView.tag = 3008;
    [alertView show];
    [alertView release];
    
}


- (void)didEditClassGroup:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        NSString *introduction = [[[_infoArray firstObject] cellModel] content];
        if (introduction == nil){
            introduction = @"";
        }
        for (int i=1; i<_infoArray.count; i++){
            NSString *content = [[_infoArray[i] cellModel] content];
            if (content == nil){
                content = @"";
            }
            introduction = [NSString stringWithFormat:@"%@,%@",introduction,content];
        }
        if ([_delegate respondsToSelector:@selector(editClassInformationTableVC:didEditedWithClassModel:)]){
            [_delegate editClassInformationTableVC:self didEditedWithClassModel:self.classModel];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if (error.code == 37){
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"你不是班级管理员",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil];
        [alerView show];
        [alerView release];
    }
}


- (void)endEdit{
    [self.view endEditing:YES];
}


- (void)uiConfig{
    _inforTableView.tableFooterView = [[[UIView alloc]init] autorelease];
}

- (void)rollbackInfoArray{
    [_infoArray release],_infoArray = nil;
    [self.inforTableView reloadData];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 3008) {
        if (buttonIndex) {
            [self endEdit];
            
            NSString *introduction = [[[_infoArray firstObject] cellModel] content];
            if (introduction == nil){
                introduction = @"";
            }
            for (int i=1; i<4; i++){
                NSString *content = [[_infoArray[i] cellModel] content];
                if (content == nil){
                    content = @"";
                }
                introduction = [NSString stringWithFormat:@"%@,%@",introduction,content];
            }
            
            NSTimeInterval start_day = [NSDate ZeropointWihtDateString:[[self.infoArray[4] cellModel] content]];
            NSTimeInterval end_day = [NSDate ZeropointWihtDateString:[[self.infoArray[5] cellModel] content]];
            
            NSTimeInterval startclock = [NSDate getTimeIntervalWithString:[[self.infoArray[6] cellModel] content]];
            NSTimeInterval timeLong = [NSDate getTimeIntervalWithString:[[self.infoArray[7] cellModel] content]];
            NSTimeInterval start_time = start_day + startclock;
            NSTimeInterval end_time = start_time + timeLong;
            
            self.classModel.intro = introduction;
            self.classModel.start_day = [NSString stringWithFormat:@"%lf",start_day] ;
            self.classModel.end_day = [NSString stringWithFormat:@"%lf",end_day];
            self.classModel.start_time = [NSString stringWithFormat:@"%lf",start_time];
            self.classModel.end_time = [NSString stringWithFormat:@"%lf",end_time];
            
            
            [OMNetWork_MyClass modifyClassInfoWithClassModel:self.classModel WithCallBack:@selector(didModifyClassInfo:) withObserver:self];
        }
    }else{
        if (alertView.tag == 3000 || alertView.tag == 3001){
            // 修改的时间非法，改回
            [self rollbackInfoArray];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OMBaseCellFrameModel *model = _infoArray[indexPath.row];
    if (model.cellModel.type == OMBaseCellModelTypeTextField ){// 拥有textfield的cell
        OMBaseTextFieldCell *cell = [OMBaseTextFieldCell cellWithTableView:tableView];
        cell.cellFromeModel = model;
        cell.delegate = self;
        return cell;
    }else if (model.cellModel.type == OMBaseCellModelTypeDatePicker
              || model.cellModel.type == OMBaseCellModelTypeTimePicker
              || model.cellModel.type == OMBaseCellModelTypeCountDownTimer){
        // 拥有DatePicker的cell
        OMBaseDatePickerCell *cell = [OMBaseDatePickerCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.cellFrameModel = model;
        return cell;
    }else{// 数据错误时
        static NSString *ID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = @"错误数据";
        return cell;
    }
}




#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OMBaseCellFrameModel *model = self.infoArray[indexPath.row];
    return model.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - NetWork CallBack

- (void)didModifyClassInfo:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if ([self.delegate respondsToSelector:@selector(editClassInformationTableVC:didEditedWithClassModel:)]){
            [self.delegate editClassInformationTableVC:self didEditedWithClassModel:self.classModel];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if (error.code == 37){
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"你不是班级管理员",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil];
        [alerView show];
        [alerView release];
    }
}



#pragma mark - OMBaseTextFieldCellDelegate
-(void)baseTextFieldCell:(OMBaseTextFieldCell *)textFielldCell endEditing:(OMBaseCellFrameModel *)cellFrameModel{
//    [self.view endEditing:YES];
}


#pragma mark - OMBaseDatePickerCellDelegate

- (void)baseDatePickerCell:(OMBaseDatePickerCell *)baseDatePickerCell hiddenWithModel:(OMBaseCellFrameModel *)cellFrameModel{
    [self.inforTableView reloadData];

}

- (void)baseDatePickerCell:(OMBaseDatePickerCell *)baseDatePickerCell changeDateWithModel:(OMBaseCellFrameModel *)cellFrameModel{
    Lesson *firstLesson = [_lessonArray firstObject];
    if (![firstLesson isKindOfClass:[Lesson class]])return;
    
    if (cellFrameModel.cellModel.type == OMBaseCellModelTypeTextField ){

    }else if (cellFrameModel == self.infoArray[4]){
        NSTimeInterval changedDate = [NSDate ZeropointWihtDateString:cellFrameModel.cellModel.content];
        NSTimeInterval startDate = [NSDate ZeropointWihtTimeIntervalString: firstLesson.start_date];
        if (changedDate > startDate){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"The opening date not later than the first class time",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
            alertView.tag = 3000;
            [alertView show];
            [alertView release];
        }
    }else if (cellFrameModel == self.infoArray[5]){
        NSTimeInterval changedDate = [NSDate ZeropointWihtDateString:cellFrameModel.cellModel.content];
        OMBaseCellFrameModel *startFrameModel = self.infoArray[4];
        NSTimeInterval startDate = [NSDate ZeropointWihtDateString:startFrameModel.cellModel.content];
        if (changedDate < startDate){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"班级结束日期不能早于开始日期",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
            alertView.tag = 3001;
            [alertView show];
            [alertView release];
        }
    }else if (cellFrameModel.cellModel.type == OMBaseCellModelTypeTimePicker){
        return;
    }else{
        
    }
}


@end
