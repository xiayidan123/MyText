//
//  HomeworkDetailVC.m
//  dev01
//
//  Created by 杨彬 on 15/5/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  作业详情

#import "HomeworkDetailVC.h"

#import "OMNetWork_MyClass.h"
#import "WTUserDefaults.h"
#import "OMDateBase_MyClass.h"

#import "NewhomeWorkModel.h"
#import "HomeworkReviewModel.h"
#import "SchoolMember.h"

#import "HomeworkDetailCell.h"
#import "HomeworkReviewCell.h"

#import "GradeViewController.h"
#import "StudentUploadHomeworkVC.h"
#import "MJRefresh.h"




@interface HomeworkDetailVC ()<UITableViewDataSource,UITableViewDelegate,GradeViewControllerDelegate,StudentUploadHomeworkVCDelegate>

@property (retain, nonatomic) IBOutlet UITableView *homework_tableView;

@property (retain, nonatomic) NewhomeWorkModel * homework_model;

@property (retain, nonatomic) NSMutableArray * homework_moment_array;


@property (retain, nonatomic) IBOutlet UIButton *toolBar_button;

@property (assign, nonatomic) int user_type;



@end

@implementation HomeworkDetailVC



- (void)dealloc {
    [_homework_tableView release];
    
    self.lesson_id = nil;
    
    self.homework_model = nil;
    
    self.homework_moment_array = nil;
    
    self.student = nil;
    
    
    self.lessonmodel = nil;
    self.classmodel = nil;
    [_toolBar_button release];
    [super dealloc];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self uiConfig];
    
    [OMNetWork_MyClass getLessonHomeWorkWithLessonID:self.lesson_id withStudent_id:self.student.userID withCallBack:@selector(didGetHomework:) withObserver:self];
}

- (void)prepareData{
    self.user_type = [[WTUserDefaults getUsertype] intValue];
}


- (void)uiConfig{
    self.title = self.student.alias;
    self.homework_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homework_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
    [self loadMJRefresh];
    [self loadToolBar];
}

- (void)loadMJRefresh{
    
    [self.homework_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.homework_tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.homework_tableView.header setTitle:@"释放刷新" forState:MJRefreshHeaderStatePulling];
    [self.homework_tableView.header setTitle:@"正在加载..." forState:MJRefreshHeaderStateRefreshing];
    self.homework_tableView.header.font = [UIFont systemFontOfSize:14];
    self.homework_tableView.header.textColor = [UIColor lightGrayColor];
}
- (void)loadNewData{
    self.omAlertViewForNet.title = @"正在刷新师生名单";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
    [self.omAlertViewForNet showInView:self.view];
    [OMNetWork_MyClass getLessonHomeWorkWithLessonID:self.lesson_id withStudent_id:self.student.userID withCallBack:@selector(didGetHomework:) withObserver:self];
}
- (void)loadToolBar{
    self.toolBar_button.layer.cornerRadius = self.toolBar_button.bounds.size.height / 2;
    self.toolBar_button.layer.masksToBounds = YES;
    self.toolBar_button.enabled = NO;
    
    if (self.user_type == 2){// 老师
        [self.toolBar_button setTitle:@"去评分" forState:UIControlStateNormal];
    }else if (self.user_type == 1){// 学生
        [self.toolBar_button setTitle:@"修改作业" forState:UIControlStateNormal];
    }
}


- (IBAction)click_toolbar_button:(id)sender {
    if (self.user_type == 1){
        [self changeHomework];
    }else if (self.user_type == 2){
        [self checkHomework];
    }
}

// 学生修改作业
- (void)changeHomework{
    StudentUploadHomeworkVC *studentUploadHomeworkVC = [[StudentUploadHomeworkVC alloc]initWithNibName:@"StudentUploadHomeworkVC" bundle:nil];
    studentUploadHomeworkVC.delegate = self;
    studentUploadHomeworkVC.homeworkModel = self.homework_model;
    studentUploadHomeworkVC.classmodel = self.classmodel;
    studentUploadHomeworkVC.lessonmodel = self.lessonmodel;
    [self.navigationController pushViewController:studentUploadHomeworkVC animated:YES];
    [studentUploadHomeworkVC release];
}

// 老师评分
- (void)checkHomework{
    GradeViewController *gradeVC = [[GradeViewController alloc]initWithNibName:@"GradeViewController" bundle:nil];
    gradeVC.student = self.student;
    gradeVC.classmodel = self.classmodel;
    gradeVC.lessonmodel = self.lessonmodel;
    gradeVC.delegate = self;
    [self.navigationController pushViewController:gradeVC animated:YES];
    [gradeVC release];
}


- (void)didGetHomework:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.homework_model = [[notif userInfo] objectForKey:@"fileName"];
        self.omAlertViewForNet.title = @"刷新成功";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        [self.homework_tableView reloadData];
    }else{
        self.omAlertViewForNet.title = @"刷新失败";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    
    [self.homework_tableView.header endRefreshing];
}

#pragma mark - UITableViewDataSource


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    id obj = self.homework_moment_array[indexPath.row];
    
    if ([obj isKindOfClass:[Homework_Moment class]]){
        HomeworkDetailCell *cell = [HomeworkDetailCell cellWithTableView:tableView];
        id homework_objc = self.homework_moment_array[indexPath.row];
        cell.homework_objc = homework_objc;
        return cell;
    }else {
        HomeworkReviewCell *cell = [HomeworkReviewCell cellWithTableView:tableView];
        cell.review_model = obj;
        return cell;
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.homework_moment_array.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id obj = self.homework_moment_array[indexPath.row];
    
    return [obj cell_height];
}





#pragma mark - UITableViewDelegate


#pragma mark - GradeViewControllerDelegate

- (void)GradeViewController:(GradeViewController *)gradeVC didUploadReview:(HomeworkReviewModel *)homework_review_model{
    [self.homework_moment_array insertObject:homework_review_model atIndex:0];
    if (self.user_type == 1){
        self.toolBar_button.enabled = YES;
    }else {
        self.toolBar_button.enabled = NO;
    }
    [self.homework_tableView reloadData];
    
    self.student.homework_state = SchoolMemberHomeworkState_DidModify;
    
    if ([self.delegate respondsToSelector:@selector(homeworkDetailVC:didChangeHomeWorkStateWithStudent:)]){
        [self.delegate homeworkDetailVC:self didChangeHomeWorkStateWithStudent:self.student];
    }
}


#pragma mark - StudentUploadHomeworkVCDelegate

- (void)studentUploadHomeworkVC:(StudentUploadHomeworkVC *)studentUploadHomeworkVC didUploadHomeworkWithHomework_model:(NewhomeWorkModel *)homework_model andHomework_moment:(Homework_Moment *)homework_moment{
//    [self.homework_moment_array addObject:homework_moment];
    [self.homework_moment_array insertObject:homework_moment atIndex:0];
    [self.homework_tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(homeworkDetailVC:didChangeHomeWorkStateWithHomework_moment:)]){
        [self.delegate homeworkDetailVC:self didChangeHomeWorkStateWithHomework_moment:homework_moment];
    }
}



#pragma mark - Set and Get

-(void)setHomework_model:(NewhomeWorkModel *)homework_model{
    [_homework_model release],_homework_model = nil;
    _homework_model = [homework_model retain];
    if (_homework_model == nil)return;
    
    
    NSMutableArray *homework_moment_array = [[NSMutableArray alloc]init];
    
    
    
    NSInteger count = _homework_model.results_moments.count;
    for (int i= (int)(count - 1); i>= 0; i--){
        id homework_objc = _homework_model.results_moments[i];
        [homework_moment_array addObject:homework_objc];
        
//        if ([homework_objc isKindOfClass:[Homework_Moment class]]){
//            Homework_Moment *moment = (Homework_Moment *)homework_objc;
//            moment.text = @"jiao ge zuoye zheme nan ddddddddddddd 范德萨范德萨 jiao ge zuoye zheme nan";
//        }
    }
    
//    [homework_moment_array addObject:_homework_model.homework_moment];
//    int count = homework_moment_array.count;
//    for (int i = count; i >= 0; i--) {
//        [self.homework_moment_array addObject:homework_moment_array[i]];
//    }
    self.homework_moment_array = homework_moment_array;
    [homework_moment_array release];
}


- (void)setHomework_moment_array:(NSMutableArray *)homework_moment_array{
    [_homework_moment_array release],_homework_moment_array = nil;
    _homework_moment_array = [homework_moment_array retain];
    if (_homework_moment_array == nil) return;
    
    id objc = [_homework_moment_array firstObject];
    
    if ([objc isKindOfClass:[HomeworkReviewModel class]] && self.user_type == 1){
        self.toolBar_button.enabled = YES;
    }else if (self.user_type == 1 && _homework_moment_array.count == 1){
        self.toolBar_button.enabled = YES;
    }else if (self.user_type == 2 && [objc isKindOfClass:[Homework_Moment class]]){
        self.toolBar_button.enabled = YES;
    }else {
        self.toolBar_button.enabled = NO;
        self.toolBar_button.hidden = YES;
    }
    [self.homework_tableView reloadData];
}

-(SchoolMember *)student{
    if (_student == nil){
        _student = [[OMDateBase_MyClass fetchClassMemberByClass_id:_student.class_id andMember_id:_student.userID] retain];
    }
    
    if ( _student.alias.length == 0){
        SchoolMember *student = [OMDateBase_MyClass fetchClassMemberByClass_id:_student.class_id andMember_id:_student.userID];
        _student.alias = student.alias;
    }
    return _student;
}


@end
