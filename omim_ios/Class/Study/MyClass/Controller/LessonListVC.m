//
//  LessonListVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/12.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LessonListVC.h"
#import "PublicFunctions.h"
#import "OMClass.h"
#import "Lesson.h"
#import "ClasstimetableCell.h"
#import "AddClasstimetableCell.h"

#import "OMNetWork_MyClass.h"
#import "OMDateBase_MyClass.h"
#import "Database.h"

#import "LessonEditAlertView.h"
#import "NSDate+ClassScheduleDate.h"

#import "EditLessonVC.h"


@interface LessonListVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,LessonEditAlertViewDelegate,EditLessonVCDelegate>

@property (retain, nonatomic) IBOutlet UITableView *lessonTableView;

@property (assign, nonatomic) NSInteger deleteIndex;

@property (retain, nonatomic) Lesson *editLesson;

@property (retain, nonatomic) LessonEditAlertView *editAlertView;

@end

@implementation LessonListVC

- (void)dealloc {
    [_editAlertView release];
    [_editLesson release];
    [_lessonArray release];
    [_lessonTableView release];
    [super dealloc];
}


-(void)setEditAlertView:(LessonEditAlertView *)editAlertView{
    [_editAlertView release],_editAlertView = nil;
    _editAlertView = [editAlertView retain];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
    
    [self uiConfig];
}

- (void)configNavigation{

    self.title = NSLocalizedString(@"课表信息", nil);
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"取消",nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)] autorelease];
}

- (void)cancelButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uiConfig{
    _lessonTableView.tableFooterView = [[[UIView alloc]init] autorelease];
    
}


#pragma mark - Lesson handle
- (void)addLesson{
    EditLessonVC *editLessonVC = [[EditLessonVC alloc]initWithNibName:@"EditLessonVC" bundle:nil];
    [self.navigationController pushViewController:editLessonVC animated:YES];
    editLessonVC.delegate = self;
    editLessonVC.lessonArray = self.lessonArray;
    editLessonVC.classModel = self.classModel;
    [editLessonVC release];
}

- (void)deleteLesson{
    [OMNetWork_MyClass deletecLessonWithLessonModel:self.lessonArray[_deleteIndex] WithCallBack:@selector(didDeleteClassSchedule:) withObserver:self];
}

- (void)modifyLessonWithIndex:(NSIndexPath *)indexPath{
    EditLessonVC *editLessonVC = [[EditLessonVC alloc]initWithNibName:@"EditLessonVC" bundle:nil];
    [self.navigationController pushViewController:editLessonVC animated:YES];
    editLessonVC.delegate = self;
    editLessonVC.classModel = self.classModel;
    editLessonVC.lessonArray = self.lessonArray;
    editLessonVC.lessonModel = self.lessonArray[indexPath.row];
    [editLessonVC release];
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.lessonArray.count){
        AddClasstimetableCell *cell = [AddClasstimetableCell cellWithTableView:tableView];
        
        return cell;
    }
    
    ClasstimetableCell *cell = [ClasstimetableCell cellWithTableView:tableView];
    
    cell.lesson = self.lessonArray[indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lessonArray.count + 1;
}



#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.lessonArray.count){//添加课程
        [self addLesson];
    }else {
        [self modifyLessonWithIndex:indexPath];
    }
}



- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath{
    if (indexPath.row == self.lessonArray.count) return UITableViewCellEditingStyleNone;
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.lessonArray.count) return;
    
    _deleteIndex = indexPath.row;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"确认删除?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    alert.tag = 600;
    [alert show];
    [alert release];
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 600 && buttonIndex == 1){
        [self deleteLesson];
    }
}


#pragma mark - NetWork CallBack

- (void)didDeleteClassSchedule:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [OMDateBase_MyClass deleteLessonWithID:[self.lessonArray[_deleteIndex] lesson_id]];
        self.lessonArray = [OMDateBase_MyClass fetchLessonWithClassID:self.classModel.groupID];
        [self.lessonTableView reloadData];
        if ([self.delegate respondsToSelector:@selector(lessonListVC:didDeleteLessonWithLessonModel:)]){
            [self.delegate lessonListVC:self didDeleteLessonWithLessonModel:nil];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"删除课表失败",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)didAddClassSchedule:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.lessonArray = [OMDateBase_MyClass fetchLessonWithClassID:self.classModel.groupID];
        [self.lessonTableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(lessonListVC:didAddLessonWithLessonModel:)]){
            [self.delegate lessonListVC:self didAddLessonWithLessonModel:nil];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"添加课表失败",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


- (void)didModifyLesson:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
       
    }else{
        NSString *msg = [NSString stringWithFormat:@"%@ 修改时间失败",[error.userInfo[@"classScheduleModel"] title]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",nil)message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认",nil), nil];
        [alert show];
        [alert release];
    }
    
    self.lessonArray = [OMDateBase_MyClass fetchLessonWithClassID:self.classModel.groupID];
    [self.lessonTableView reloadData];
    
    if ([_delegate respondsToSelector:@selector(lessonListVC:didModifyLessonWithLessonModel:)]){
        [_delegate lessonListVC:self didModifyLessonWithLessonModel:nil];
    }
}


#pragma mark - LessonEditAlertViewDelegate

- (void)lessonEditAlertView:(LessonEditAlertView *)lessonEditAlerView addLesson:(Lesson *)lessonModel{
    self.editLesson = lessonModel;
    self.editLesson.class_id = self.classModel.groupID;
    
    [OMNetWork_MyClass addLessonWithLessonModel:self.editLesson WithCallBack:@selector(didAddClassSchedule:) withObserver:self];
    
    [self.editAlertView remove];
}

- (void)lessonEditAlertView:(LessonEditAlertView *)lessonEditAlerView modifyLesson:(Lesson *)lessModel{
    self.editLesson = lessModel;
    self.editLesson.class_id = self.classModel.groupID;
    [OMNetWork_MyClass modifyLessonWithLessonModel:self.editLesson WithCallBack:@selector(didModifyLesson:)  withObserver:self];
}


#pragma mark - EditLessonVCDelegate

- (void)editLessonVC:(EditLessonVC *)editLessonVC didAddLessonWithLessonModel:(Lesson *)lessonModel{
    self.lessonArray = [OMDateBase_MyClass fetchLessonWithClassID:self.classModel.groupID];
    [self.lessonTableView reloadData];
    if ([self.delegate respondsToSelector:@selector(lessonListVC:didAddLessonWithLessonModel:)]){
        [self.delegate lessonListVC:self didAddLessonWithLessonModel:nil];
    }
}

- (void)editLessonVC:(EditLessonVC *)editLessonVC didModifyLessonWithLessonModel:(Lesson *)lessonModel{
    self.lessonArray = [OMDateBase_MyClass fetchLessonWithClassID:self.classModel.groupID];
    [self.lessonTableView reloadData];
    if ([self.delegate respondsToSelector:@selector(lessonListVC:didModifyLessonWithLessonModel:)]){
        [self.delegate lessonListVC:self didModifyLessonWithLessonModel:nil];
    }
    
}

@end
