//
//  NewClassDetailVC.m
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NewClassDetailVC.h"
#import "WTUserDefaults.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "CourseCell.h"
#import "ClassRoomVC.h"
#import "CameraListVC.h"

#import "ClassRoom.h"
#import "OMClass.h"
#import "Lesson.h"

#import "OMNetWork_MyClass.h"

#import "LessonDetailModel.h"
#import "OMBaseCellFrameModel.h"
#import "LessonPerformanceModel.h"
#import "StudentsListVC.h"
#import "LessonStatusVC.h"
#import "ParentsOpinionDetailVC.h"
#import "HomeworkVC.h"
#import "AssignmentVC.h"


@interface NewClassDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,ClassRoomVCDelegate,CameraListVCDelegate>
{
    BOOL _isTeacher;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic)ClassRoom *classRoom;

@property (retain, nonatomic)LessonDetailModel *lessonDetail;

@property (retain, nonatomic)NSMutableArray *itemsArray;


@property (assign, nonatomic)BOOL alreadyEnd;

@property (assign, nonatomic) BOOL isLeave;

@end

@implementation NewClassDetailVC

- (void)dealloc {
    [_itemsArray release];
    [_lessonDetail release];
    [_classModel release];
    [_classRoom release];
    [_lessonModel release];
    [_tableView release],_tableView.delegate = nil,_tableView.dataSource = nil,_tableView = nil;
    [super dealloc];
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadData{
    
     [self loadUserTypeLimits];
    
    if (_isTeacher) {
        [OMNetWork_MyClass getLessonDetailWithLessonID:self.lessonModel.lesson_id withCallBack:@selector(didGetLessonDetail:) withObserver:self];
    }else{
        [OMNetWork_MyClass StudentGetLessonDetailWithLessonID:self.lessonModel.lesson_id withCallBack:@selector(didGetLessonDetail:) withObserver:self];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self prepareData];
    [self configNavigation];
    [self uiConfig];
}


- (void)prepareData{
    
    NSTimeInterval now_timeInterval = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval end_timeInterval = [self.lessonModel.end_date doubleValue];
    
    if (now_timeInterval < end_timeInterval){
        self.alreadyEnd = NO;
    }else{
        self.alreadyEnd = YES;
    }
    
}


- (void)loadUserTypeLimits
{
    if([[WTUserDefaults getUsertype] isEqualToString:@"2"]){
        _isTeacher = YES;
    }
}

- (void)configNavigation
{
    self.title = self.lessonModel.title;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"刷新", nil) style:UIBarButtonItemStylePlain target:self action:@selector(loadData)];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uiConfig
{
    self.view.backgroundColor = [UIColor grayColor];
    _tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}


-(void)setClassRoom:(ClassRoom *)classRoom{
    [_classRoom release],_classRoom = nil;
    _classRoom = [classRoom retain];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000 && buttonIndex == 1){
        ClassRoomVC *classRoomVC = [[ClassRoomVC alloc] initWithNibName:@"ClassRoomVC" bundle:nil];
        classRoomVC.lessonModel = self.lessonModel;
        classRoomVC.delegate = self;
        [self.navigationController pushViewController:classRoomVC animated:YES];
        [classRoomVC release];
        return;
    }
}



#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCell *cell = [CourseCell cellWithTableView:tableView];
    
    cell.cellFrameModel = self.itemsArray[indexPath.section][indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemsArray.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OMBaseCellFrameModel *cellFrameModel = self.itemsArray[indexPath.section][indexPath.row];
    
    if (![cellFrameModel isKindOfClass:[OMBaseCellFrameModel class]])return;
    
    if ([cellFrameModel.cellModel.title isEqualToString:@"教室"]) {
        [self clickClassRoomCell];
    }
    else if ([cellFrameModel.cellModel.title isEqualToString:@"摄像头"]){
        return;
        [self clickCameraCell];
    }
    else if ([cellFrameModel.cellModel.title isEqualToString:@"课堂点评"]){
        [self clickClassComments];
    }
    else if ([cellFrameModel.cellModel.title isEqualToString:@"布置作业"]||[cellFrameModel.cellModel.title isEqualToString:@"作业"]){
        [self clickHomeWorkCell];
    }
    else if ([cellFrameModel.cellModel.title isEqualToString:@"家长意见"]){
        [self clickParentsOpinion];
    }
    else if ([cellFrameModel.cellModel.title isEqualToString:@"教学大纲"]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"很快回来" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
}


#pragma mark - Cell Click Action

// 点击教室cell
- (void)clickClassRoomCell{
    ClassRoomVC *classRoomVC = [[ClassRoomVC alloc] initWithNibName:@"ClassRoomVC" bundle:nil];
    classRoomVC.lessonModel = self.lessonModel;
    classRoomVC.classModel = self.classModel;
    classRoomVC.delegate = self;
    [self.navigationController pushViewController:classRoomVC animated:YES];
    [classRoomVC release];
}

// 点击摄像头cell
- (void)clickCameraCell{
    if (self.classRoom == nil || self.classRoom.classRoom_id == nil || self.classRoom.school_id == nil){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"Did not choose the classroom, whether the preferred To choose the classroom",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
        alertView.tag = 2000;
        [alertView show];
        [alertView release];
        return;
    }
    
    CameraListVC *cameraListVC = [[CameraListVC alloc] initWithNibName:@"CameraListVC" bundle:nil];
    cameraListVC.classRoom = self.classRoom;
    cameraListVC.delegate = self;
    
    [self.navigationController pushViewController:cameraListVC animated:YES];
    [cameraListVC release];
}

// 点击课堂点评
- (void)clickClassComments{
    if (!self.alreadyEnd)return;
    
    if (_isTeacher){
        StudentsListVC *studentListVC = [[StudentsListVC alloc]initWithNibName:@"StudentsListVC" bundle:nil];
        studentListVC.lessonModel = self.lessonModel;
        studentListVC.parentsOpinion = NO;
        [self.navigationController pushViewController:studentListVC animated:YES];
        [studentListVC release];
    }else{
        if (self.isLeave) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"你已请假不能点评" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }else{
            LessonStatusVC *lessonStatusVC = [[LessonStatusVC alloc]init];
            lessonStatusVC.lesson_id = self.lessonModel.lesson_id;
            lessonStatusVC.studentModel = [Database fetchStudentInClassWithStudentID:[WTUserDefaults getUid] withClassID:self.lessonModel.class_id];
            [self.navigationController pushViewController:lessonStatusVC animated:YES];
            [lessonStatusVC release];
        }
    }
}
// 点击作业
- (void)clickHomeWorkCell{
//    if (!self.alreadyEnd)return;
//    if (_isTeacher){
//        StudentsListVC *studentListVC = [[StudentsListVC alloc]initWithNibName:@"StudentsListVC" bundle:nil];
//        studentListVC.lessonModel = self.lessonModel;
//        studentListVC.parentsOpinion = NO;
//        [self.navigationController pushViewController:studentListVC animated:YES];
//        [studentListVC release];
//    }else{
//        HomeworkVC *homeWorkVC = [[HomeworkVC alloc]init];
//        homeWorkVC.lessonModel = self.lessonModel;
//        [self.navigationController pushViewController:homeWorkVC animated:YES];
//        [homeWorkVC release];
//    }
    AssignmentVC *assignmentVC = [[[AssignmentVC alloc] initWithNibName:@"AssignmentVC" bundle:nil] autorelease];
    assignmentVC.lessonModel = self.lessonModel;
    assignmentVC.classModel = self.classModel;
    [self.navigationController pushViewController:assignmentVC animated:YES];
}


// 家长意见
- (void)clickParentsOpinion{
    
    if (!self.alreadyEnd)return;
    if (_isTeacher){
        StudentsListVC *studentListVC = [[StudentsListVC alloc]initWithNibName:@"StudentsListVC" bundle:nil];
        studentListVC.lessonModel = self.lessonModel;
        studentListVC.parentsOpinion = YES;
        [self.navigationController pushViewController:studentListVC animated:YES];
        [studentListVC release];
    }else{
        if (self.isLeave) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"你已请假不能点评" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }else{
            ParentsOpinionDetailVC *parentsOpinionDetailVC = [[ParentsOpinionDetailVC alloc]init];
            parentsOpinionDetailVC.studentModel = [Database fetchStudentInClassWithStudentID:[WTUserDefaults getUid] withClassID:self.classModel.groupID];
            parentsOpinionDetailVC.lesson_id = self.lessonModel.lesson_id;
            [self.navigationController pushViewController:parentsOpinionDetailVC animated:YES];
            [parentsOpinionDetailVC release];
        }
        
    }
}



#pragma mark - ClassRoomVCDelegate
-(void)didSelectedClassRoom:(ClassRoomVC *)classRoomVC withClassRoom:(ClassRoom *)classRoom{
    self.lessonDetail.roomArray = [NSMutableArray arrayWithObject:classRoom];
    self.lessonDetail.cameraArray = classRoom.cameraArray;
    self.classRoom = classRoom;
    self.itemsArray = [LessonDetailModel parseLessonDetailModel:self.lessonDetail isTeacher:_isTeacher];
    [self.tableView reloadData];
}

-(void)didReleaseRoom:(ClassRoomVC *)classRoomVC withRoomID:(NSString *)room_id{
    self.lessonDetail.roomArray = nil;
    self.lessonDetail.cameraArray = nil;
    self.itemsArray = [LessonDetailModel parseLessonDetailModel:self.lessonDetail isTeacher:_isTeacher];
    
    [self.tableView reloadData];
}

#pragma mark - CameraListVCDelegate
- (void)cameraListVC:(CameraListVC *)cameraListVC didSetCameraWithCameraListArray:(NSMutableArray *)cameraListArray{
    self.lessonDetail.cameraArray = cameraListArray;
    self.itemsArray = [LessonDetailModel parseLessonDetailModel:self.lessonDetail isTeacher:_isTeacher];
    [self.tableView reloadData];
}


#pragma mark - NetWork CallBack

- (void)didGetLessonDetail:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        self.omAlertViewForNet.title = @"加载完成";
        [self.omAlertViewForNet showInView:self.view];
        self.lessonDetail = [[[notif userInfo] valueForKey:@"fileName"] firstObject];
        self.itemsArray = [LessonDetailModel parseLessonDetailModel:self.lessonDetail isTeacher:_isTeacher];
        [self.tableView reloadData];
    }else if(error.code==301)
    {
        [self.omAlertViewForNet dismiss];
    }
}

- (BOOL)isLeave{
    
    NSString *property_value = [[NSString alloc] init];
    property_value = ((LessonPerformanceModel *)[self.lessonDetail.performanceArray firstObject]).property_value;
    NSString *property_id = [[NSString alloc] init];
    property_id = ((LessonPerformanceModel *)[self.lessonDetail.performanceArray firstObject]).property_id;
    if ([property_id isEqualToString:@"10"]) {
        if ([property_value isEqualToString:@"2"] || [property_value isEqualToString:@"4"] || [property_value isEqualToString:@"1"]) {//如果老师批准了请假了返回yes 或者 只要学生提交请假申请就
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    
}

#pragma mark - Set and Get

-(void)setLessonDetail:(LessonDetailModel *)lessonDetail{
    [_lessonDetail release],_lessonDetail = nil;
    _lessonDetail = [lessonDetail retain];
    self.classRoom = [lessonDetail.roomArray firstObject];
}

- (void)setItemsArray:(NSMutableArray *)itemsArray{
    [_itemsArray removeAllObjects];
    [_itemsArray release],_itemsArray = nil;
    _itemsArray = [itemsArray retain];
}

-(BOOL)alreadyEnd{
    if (!_alreadyEnd){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"课程还未结束" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
    return _alreadyEnd;
}


@end
