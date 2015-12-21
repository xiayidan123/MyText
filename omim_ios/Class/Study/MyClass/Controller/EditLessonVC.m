//
//  EditLessonVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/26.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "EditLessonVC.h"

#import "Lesson.h"
#import "OMClass.h"
#import "OMBaseCellFrameModel.h"

#import "NSDate+ClassScheduleDate.h"
#import "WTHeader.h"
#import "OMNetWork_MyClass.h"

#import "OMBaseTextFieldCell.h"
#import "OMBaseDatePickerCell.h"

#import "PublicFunctions.h"


@interface EditLessonVC ()<UITableViewDataSource,UITableViewDelegate,OMBaseTextFieldCellDelegate,OMBaseDatePickerCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView *edit_tableView;

@property (retain, nonatomic) NSMutableArray *itemArray;

@property (retain, nonatomic) Lesson *editLesson;

@property (assign, nonatomic) BOOL canEdit;


@property (assign, nonatomic) NSInteger refresh_cell_index;





@end

@implementation EditLessonVC

- (void)dealloc {
    [_editLesson release];
    [_lessonArray release];
    [_classModel release];
    [_lessonModel release];
    [_edit_tableView release];
    [super dealloc];
}


- (void)setLessonModel:(Lesson *)lessonModel{
    [_lessonModel release],_lessonModel = nil;
    _lessonModel = [lessonModel retain];
    
    NSTimeInterval nowTimeInterval = [NSDate ZeropointWihtDate:[NSDate date]];
    NSTimeInterval startTimeInterval = [NSDate ZeropointWihtTimeIntervalString:_lessonModel.start_date];
    if (nowTimeInterval > startTimeInterval){
        self.canEdit = NO;
    }else{
        self.canEdit = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareData];
    
    [self uiConfig];
    
//    self.itemArray;
    
}


-(NSMutableArray *)itemArray{
    if (_itemArray == nil){
        NSMutableArray *itemArray = [[NSMutableArray alloc]init];
        NSArray *titleArray = @[@"课程名",@"上课日期",@"上课时间",@"结束时间"];
        NSMutableArray *contentArray = [[NSMutableArray alloc]init];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        if (self.lessonModel == nil){// addlesson
            NSString *title = @"";
            
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSString *start_day;
            
            if (self.lessonArray.count == 0){
                start_day = self.classModel.start_day;
            }else {
                Lesson *lesson = [self.lessonArray lastObject];
                start_day = lesson.start_date;
            }
            NSTimeInterval start_timeInterval = [start_day doubleValue];
            
            start_day = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:(start_timeInterval + 60*60*24)]];
            if ([start_day isEqualToString:@""] || start_day == nil){
                start_day = [dateFormat stringFromDate:[NSDate date]];
            }
            
            [dateFormat setDateFormat:@"HH:mm"];
            NSString *start_time = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.classModel.start_time doubleValue]]];
            if (start_time.length == 0){
                start_time = [dateFormat stringFromDate:[NSDate date]];
            }
            
            [dateFormat setDateFormat:@"HH:mm"];
            NSString *end_time = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.classModel.end_time doubleValue]]];
            if (end_time.length == 0){
                end_time = [dateFormat stringFromDate:[NSDate date]];
            }
            
            [contentArray addObjectsFromArray:@[title,start_day,start_time,end_time]];
            
        }
        else {//modifylesson
            
            NSString *title = self.lessonModel.title;
            
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSString *start_day = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.lessonModel.start_date doubleValue]]];
            if ([start_day isEqualToString:@""] || start_day == nil){
                start_day = [dateFormat stringFromDate:[NSDate date]];
            }
            
            [dateFormat setDateFormat:@"HH:mm"];
            NSString *start_time = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.lessonModel.start_date doubleValue]]];
            if ([start_time isEqualToString:@""] || start_time == nil){
                start_time = [dateFormat stringFromDate:[NSDate date]];
            }
            
            [dateFormat setDateFormat:@"HH:mm"];
            NSString *end_time = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.lessonModel.end_date doubleValue]]];
            if ([end_time isEqualToString:@""] || start_time == nil){
                end_time = [dateFormat stringFromDate:[NSDate date]];
            }
            
            [contentArray addObjectsFromArray:@[title,start_day,start_time,end_time]];
        }
        [dateFormat release];
        
        
        
        for (int i=0; i<titleArray.count; i++){
            OMBaseCellModelType type;
            if(i==0 ){
                type = OMBaseCellModelTypeTextField;
                
            }else if (i ==1){
                type = OMBaseCellModelTypeDatePicker;
            }else if (i == 2){
                type = OMBaseCellModelTypeTimePicker;
            }else {
                type = OMBaseCellModelTypeTimePicker;
            }
            
            NSDictionary *dic = @{@"title": titleArray[i] , @"content": contentArray[i] ,@"type" : @(type)};
            OMBaseCellFrameModel *cellFrameModel = [[OMBaseCellFrameModel alloc]init];
            cellFrameModel.isOpen = NO;
            if (self.canEdit || self.lessonModel == nil){
                cellFrameModel.canEdit = YES;
            }else {
                cellFrameModel.canEdit = NO;
            }
            cellFrameModel.cellModel = [OMBaseCellModel OMBaseCellModelWithDic:dic];
            [itemArray addObject:cellFrameModel];
            [cellFrameModel release];
        }
        [contentArray release];
        self.itemArray = itemArray;
        [itemArray release];
    }
    return _itemArray;
}

- (void)prepareData{
    
}


- (void)uiConfig{
    [self configNavigation];
    
    self.edit_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
}

- (void)configNavigation{
    NSString *title = self.lessonModel == nil ? NSLocalizedString(@"添加课程", nil) : NSLocalizedString(@"修改课程", nil);
    self.title = title;
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"取消",nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)] autorelease];
    
    if (self.canEdit || self.lessonModel == nil){
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"保存",nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)] autorelease];
    }
}


- (void)cancelButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)saveAction{
    [self endEdit];
    
    if (self.lessonModel == nil){//  添加课程
        [self addLesson];
    }else{// 修改课程
        [self modifyLesson];
    }
}



- (void)addLesson{
    Lesson *lessomModel = [[Lesson alloc]init];
    lessomModel.class_id = self.classModel.groupID;
    
    NSString *lesson_title = [[self.itemArray[0] cellModel] content];
    
    if (lesson_title.length == 0){
        UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:@"课程名不能为空" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil] autorelease];
        [alertView show];
        return;
    }
    
    lessomModel.title = lesson_title;
    
    NSString *start_date = [[self.itemArray[1] cellModel]content];
    NSString *start_time = [[self.itemArray[2] cellModel]content];
    NSString *end_time = [[self.itemArray[3] cellModel]content];
    
    NSTimeInterval start_date_timeInterval = [NSDate ZeropointWihtDateString:start_date];
    NSTimeInterval start_time_timeInterval = [NSDate getTimeIntervalWithString:start_time];
    NSTimeInterval end_time_timeInterval = [NSDate getTimeIntervalWithString:end_time];
    
    //判断选择的日期是否属于课堂日期时间段
    if (start_date_timeInterval<[self.classModel.start_day integerValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"课表开始日期不能早于该班级开班日期",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
        alertView.tag = 3000;
        [alertView show];
        [alertView release];
        return;
    }
    if (start_date_timeInterval>[self.classModel.end_day integerValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"课表开始日期不能晚于该班级结束日期",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
        alertView.tag = 3000;
        [alertView show];
        [alertView release];
        return;
    }
    //判断开始时间是否符合
    if (start_time_timeInterval<[self.classModel.start_time intValue]-[self.classModel.start_day integerValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"课表开始时间不能早于该班级开班时间",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
        alertView.tag = 3000;
        [alertView show];
        [alertView release];
        return;
    }
    if (start_date_timeInterval>[self.classModel.end_time intValue]-[self.classModel.end_day integerValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"课表开始时间不能晚于该班级结束时间",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
        alertView.tag = 3000;
        [alertView show];
        [alertView release];
        return;
    }
    //判断结束时间是否符合
    if (end_time_timeInterval<[self.classModel.start_time intValue]-[self.classModel.start_day integerValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"课表结束时间不能早于该班级开班时间",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
        alertView.tag = 3000;
        [alertView show];
        [alertView release];
        return;
    }
    if (end_time_timeInterval>[self.classModel.end_time intValue]-[self.classModel.end_day integerValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"课表结束时间不能晚于该班级结束时间",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
        alertView.tag = 3000;
        [alertView show];
        [alertView release];
        return;
    }
    
    if (end_time_timeInterval < start_time_timeInterval){// 结束时间早于开始时间
        
        UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:@"结束时间不能早于开始时间" delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil] autorelease];
        alertView.tag = 3000;
        [alertView show];
        [alertView release];
        return;
    }
    
    lessomModel.start_date = [NSString stringWithFormat:@"%lf",start_date_timeInterval + start_time_timeInterval];
    lessomModel.end_date = [NSString stringWithFormat:@"%lf",start_date_timeInterval + end_time_timeInterval];
    lessomModel.live = @"1";
    
    self.editLesson = lessomModel;
    
    [OMNetWork_MyClass addLessonWithLessonModel:lessomModel WithCallBack:@selector(didAddLesson:) withObserver:self];
    [lessomModel release];
}


- (void)modifyLesson{
    Lesson *lessomModel = [[Lesson alloc]init];
    lessomModel.class_id = self.classModel.groupID;
    lessomModel.title = [[self.itemArray[0] cellModel] content];
    lessomModel.lesson_id = self.lessonModel.lesson_id;
    
    NSString *start_date = [[self.itemArray[1] cellModel]content];
    NSString *start_time = [[self.itemArray[2] cellModel]content];
    NSString *end_time = [[self.itemArray[3] cellModel]content];
    
    NSTimeInterval start_date_timeInterval = [NSDate ZeropointWihtDateString:start_date];
    NSTimeInterval start_time_timeInterval = [NSDate getTimeIntervalWithString:start_time];
    NSTimeInterval end_time_timeInterval = [NSDate getTimeIntervalWithString:end_time];
    
    lessomModel.start_date = [NSString stringWithFormat:@"%lf",start_date_timeInterval + start_time_timeInterval];
    lessomModel.end_date = [NSString stringWithFormat:@"%lf",start_date_timeInterval + end_time_timeInterval];
    lessomModel.live = @"1";
    
    self.editLesson = lessomModel;
    
    [OMNetWork_MyClass modifyLessonWithLessonModel:lessomModel WithCallBack:@selector(didModifyClassInfo:) withObserver:self];
    
    [lessomModel release];
}



#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OMBaseCellFrameModel *model = self.itemArray[indexPath.row];
    if (model.cellModel.type == OMBaseCellModelTypeTextField ){// 拥有textfield的cell
        OMBaseTextFieldCell *cell = [OMBaseTextFieldCell cellWithTableView:tableView];
        cell.cellFromeModel = model;
        cell.needAdjustPosition = NO;
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
    OMBaseCellFrameModel *model = self.itemArray[indexPath.row];
    return model.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - NetWork CallBack
- (void)didAddLesson:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
            if ([self.delegate respondsToSelector:@selector(editLessonVC:didAddLessonWithLessonModel:)]){
                [self.delegate editLessonVC:self didAddLessonWithLessonModel:self.editLesson];
            }
            [self.navigationController popViewControllerAnimated:YES];
    }else if (error.code == 50){
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"当天已经开设了这门课程",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil];
        [alerView show];
        [alerView release];
    }
    else if (error.code == 37){
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"你不是班级管理员",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil];
        [alerView show];
        [alerView release];
    }

}


- (void)didModifyClassInfo:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if ([self.delegate respondsToSelector:@selector(editLessonVC:didModifyLessonWithLessonModel:)]){
            [self.delegate editLessonVC:self didModifyLessonWithLessonModel:self.editLesson];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if (error.code == 37){
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"你不是班级管理员",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil];
        [alerView show];
        [alerView release];
    }
}


- (void)endEdit{
    [self.view endEditing:YES];
}

- (void)rollbackInfoArray{
    [_itemArray release],_itemArray = nil;
    [self.edit_tableView reloadData];
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 3000 || alertView.tag == 3001){
//         修改的时间非法，改回
        [self rollbackInfoArray];
        OMBaseCellFrameModel *model = self.itemArray[self.refresh_cell_index];
        
        model.cellModel.content = model.cellModel.old_content;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.refresh_cell_index inSection:0];
        
        [self.edit_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
//        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
}


#pragma mark - OMBaseTextFieldCellDelegate
-(void)baseTextFieldCell:(OMBaseTextFieldCell *)textFielldCell endEditing:(OMBaseCellFrameModel *)cellFrameModel{
    [self.view endEditing:YES];
}


#pragma mark - OMBaseDatePickerCellDelegate

- (void)baseDatePickerCell:(OMBaseDatePickerCell *)baseDatePickerCell hiddenWithModel:(OMBaseCellFrameModel *)cellFrameModel{
    [self.edit_tableView reloadData];
}

- (void)baseDatePickerCell:(OMBaseDatePickerCell *)baseDatePickerCell changeDateWithModel:(OMBaseCellFrameModel *)cellFrameModel{

    if (cellFrameModel.cellModel.type == OMBaseCellModelTypeTextField ){
        
    }else if (cellFrameModel == self.itemArray[1]){
        NSTimeInterval changedDate = [NSDate ZeropointWihtDateString:cellFrameModel.cellModel.content];
        NSTimeInterval startDate = [self.classModel.start_day doubleValue];
        NSTimeInterval endDate = [self.classModel.end_day doubleValue];
        if (changedDate < startDate){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"课表开始时间不能早于该班级开班日期",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
            alertView.tag = 3000;
            [alertView show];
            [alertView release];
        }
        if (changedDate > endDate){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"课表开始时间不能迟于该班级结束日期",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
            alertView.tag = 3001;
            [alertView show];
            [alertView release];
        }
    }else if (cellFrameModel.cellModel.type == OMBaseCellModelTypeTimePicker && (cellFrameModel == self.itemArray[2] ||cellFrameModel == self.itemArray[3])){
        
        self.refresh_cell_index = cellFrameModel == self.itemArray[2] ? 2 : 3 ;
        
        NSString *start_time = [[self.itemArray[2] cellModel]content];
        NSString *end_time = [[self.itemArray[3] cellModel]content];
        
        NSTimeInterval start_time_timeInterval = [NSDate getTimeIntervalWithString:start_time];
        NSTimeInterval end_time_timeInterval = [NSDate getTimeIntervalWithString:end_time];
        
        if (end_time_timeInterval < start_time_timeInterval){// 结束时间早于开始时间
            
            UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:@"结束时间不能早于开始时间" delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil] autorelease];
            alertView.tag = 3000;
            [alertView show];
            return;
        }
    }else{
        
    }
    
    
    
}












@end
