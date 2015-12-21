//
//  StudentsListVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/11.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "StudentsListVC.h"
#import "Lesson.h"
#import "PublicFunctions.h"
#import "StudentListCell.h"
#import "Database.h"
#import "OMDateBase_MyClass.h"
#import "OMNetWork_MyClass.h"
#import "LessonStatusVC.h"
#import "ParentsOpinionDetailVC.h"

@interface StudentsListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *studentsTableView;

@property (retain, nonatomic) NSMutableArray *studentArray;

@property (retain, nonatomic) NSMutableArray * performanceArray;

@end

@implementation StudentsListVC

-(void)dealloc{
    [_lessonModel release];
    [_studentArray release];
    self.studentsTableView = nil;
    [_studentsTableView release];
    [super dealloc];
}

- (NSMutableArray *)studentArray{
    if (!_studentArray) {
        _studentArray = [[NSMutableArray alloc] init];
    }
    return _studentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
    
    [self prepareData];
    
    [self uiConfig];
    
}


- (void)configNavigation{
    self.title = NSLocalizedString(_parentsOpinion ? @"家长意见" : @"上课状况一览表", nil);
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareData{
    [self loadData];
}

- (void)loadData{
    //    self.studentArray = [Database fetchStudentsWithClassID:self.lessonModel.class_id];
    // 更新班级学生类别
    [OMNetWork_MyClass getClassStudentsWithClass_id:self.lessonModel.class_id withCallback:@selector(didGetClassStudents:) withObserver:self];
    
    self.omAlertViewForNet.title = @"正在加载...";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertViewForNet showInView:self.view];
    
    
    
}

- (void)didGetClassStudents:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR){
        [OMNetWork_MyClass getLesson_sign_in_status_withLessonID:self.lessonModel.lesson_id withStudent_id:@"ALL" withCallBack:@selector(didGetLessonSigninStatus:) withObserver:self];
    }
    else if (error.code==301)
    {
        [self.omAlertViewForNet dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else{
        self.omAlertViewForNet.title = @"加载失败,请稍后再试";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
}


- (void)didGetLessonSigninStatus:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.omAlertViewForNet.title = @"加载成功";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        
        [self.studentArray addObjectsFromArray:[OMDateBase_MyClass fetchLessonPerformanceWithStudent_id:nil WithLesson_id:self.lessonModel.lesson_id withProperty_id:@"10" property_value:@"3"]];
        [self.studentArray addObjectsFromArray:[OMDateBase_MyClass fetchLessonPerformanceWithStudent_id:nil WithLesson_id:self.lessonModel.lesson_id withProperty_id:@"10" property_value:@"-1"]];
    }else{
        self.omAlertViewForNet.title = @"加载失败,请稍后再试";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    [self.studentsTableView reloadData];
}

- (void)uiConfig{
    self.studentsTableView.tableFooterView = [[[UIView alloc]init] autorelease];
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentListCell *cell = [StudentListCell cellWithTableView:tableView];
    cell.lesson = _studentArray[indexPath.row];
    cell.class_id = self.lessonModel.class_id;
    //    cell.studentModel = _studentArray[indexPath.row];
    
    //    cell.lesson_id = ((LessonPerformanceModel *)_studentArray[indexPath.row]).lesson_id;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _studentArray.count;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [OMNetWork_MyClass getClassStudentsWithClass_id:self.lessonModel.lesson_id  withCallback:@selector(didGetStudent:) withObserver:self];
    if (_parentsOpinion){
        ParentsOpinionDetailVC *parentsOpinionDetailVC = [[ParentsOpinionDetailVC alloc]init];
        parentsOpinionDetailVC.studentModel = [Database fetchStudentInClassWithStudentID:((LessonPerformanceModel *)_studentArray[indexPath.row]).student_id withClassID:self.lessonModel.class_id];
        parentsOpinionDetailVC.lesson_id = self.lessonModel.lesson_id;
        [self.navigationController pushViewController:parentsOpinionDetailVC animated:YES];
        [parentsOpinionDetailVC release];
    }else{
        LessonStatusVC *lessonStatusVC = [[LessonStatusVC alloc]init];
        lessonStatusVC.lesson_id = self.lessonModel.lesson_id;
        lessonStatusVC.studentModel = [Database fetchStudentInClassWithStudentID:((LessonPerformanceModel *)_studentArray[indexPath.row]).student_id withClassID:self.lessonModel.class_id];
        [self.navigationController pushViewController:lessonStatusVC animated:YES];
        [lessonStatusVC release];
    }
}

- (void)didGetStudent:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
    }
}

@end