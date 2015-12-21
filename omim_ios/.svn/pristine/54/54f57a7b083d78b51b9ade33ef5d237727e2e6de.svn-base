//
//  CallTheRollViewController.m
//  dev01
//
//  Created by Huan on 15/4/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "CallTheRollViewController.h"
#import "LessonStatusCell.h"


#import "OMNetWork_MyClass.h"
#import "OMDateBase_MyClass.h"
#import "WowTalkWebServerIF.h"


#import "OMClass.h"
#import "Lesson.h"
@interface CallTheRollViewController ()<UITableViewDataSource,UITableViewDelegate,LessonStatusCellDelegate,UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *student_array;

@property (retain, nonatomic) NSMutableArray *signIn_status_array;// 签到

@property (retain, nonatomic) NSMutableArray *leave_array;// 请假

@property (retain, nonatomic) NSMutableArray *absentee_array;// 缺勤

@property (assign, nonatomic) NSInteger upload_count;

@property (retain, nonatomic) NSMutableArray *lesson_signin_status;

@property (assign, nonatomic) BOOL canEdit;

@property (retain, nonatomic) IBOutlet UIButton *allSignInBtn;

@end



@implementation CallTheRollViewController
- (void)dealloc {
    self.student_array = nil;
    self.signIn_status_array = nil;
    self.leave_array = nil;
    self.absentee_array = nil;
    self.lesson_signin_status = nil;
    
    [_tableView release];
    [_allSignInBtn release];
    [super dealloc];
}

-(void)setStudent_array:(NSMutableArray *)student_array{
    [_student_array release],_student_array = nil;
    _student_array = [student_array retain];
    
    if (_student_array.count != 0){
        //get_lesson_performance 
        [OMNetWork_MyClass getLesson_sign_in_status_withLessonID:self.OMLesson.lesson_id withStudent_id:@"ALL" withCallBack:@selector(didGetLessonSigninStatus:) withObserver:self];
    }
}

-(void)setUpload_count:(NSInteger)upload_count{
    _upload_count = upload_count;
    
    if (_upload_count == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)setCanEdit:(BOOL)canEdit{
    _canEdit = canEdit;
    
    if (_canEdit){
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.allSignInBtn.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.allSignInBtn.enabled = NO;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.OMLesson.end_date integerValue] < (NSInteger)[[NSDate date] timeIntervalSince1970]) {
        self.canEdit = NO;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self configNavigation];
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    
}
- (void)configNavigation{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureChoose)] autorelease];
    self.canEdit = NO;
}


- (void)sureChoose{
    UIAlertView *alerView = [[[UIAlertView alloc] initWithTitle:@"" message:@"是否提交考勤" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确认", nil), nil] autorelease ];
    [alerView show];
}
#pragma mark UIAlertViewdelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self sure];
        self.canEdit = NO;
    }
}

- (void)sure{
    
    
    
    NSMutableArray *student_signin_array = [[NSMutableArray alloc]init];
    NSMutableArray *status_signin_array = [[NSMutableArray alloc]init];
    
    NSMutableArray *student_leave_array = [[NSMutableArray alloc]init];
    NSMutableArray *status_leave_array = [[NSMutableArray alloc]init];
    
    NSMutableArray *student_absentee_array = [[NSMutableArray alloc]init];
    NSMutableArray *status_absentee_array = [[NSMutableArray alloc]init];
    
    NSMutableArray *name_array1 = [[NSMutableArray alloc]init];
    NSMutableArray *name_array2 = [[NSMutableArray alloc]init];
    NSMutableArray *name_array3 = [[NSMutableArray alloc]init];
    

    NSInteger count = self.lesson_signin_status.count;
    for (int i=0; i<count; i++) {
        LessonPerformanceModel *model = self.lesson_signin_status[i];
        if ([model.property_value isEqualToString:@"1"]){
            [student_absentee_array addObject:model.student_id];
            [status_absentee_array addObject:model.property_value];
            [name_array1 addObject:model.property_name];
            
        }else if ([model.property_value isEqualToString:@"2"]){
            [student_leave_array addObject:model.student_id];
            [status_leave_array addObject:model.property_value];
            [name_array2 addObject:model.property_name];
        }
        else if ([model.property_value isEqualToString:@"3"]){
            [student_signin_array addObject:model.student_id];
            [status_signin_array addObject:model.property_value];
            [name_array3 addObject:model.property_name];
        }
    }
    
    if (student_absentee_array.count != 0){
        self.upload_count ++;
        [OMNetWork_MyClass uploadLesson_sign_in_status_withLessonID:self.OMLesson.lesson_id withStudent_array:student_absentee_array withStatus_array:status_absentee_array WithCallBack:@selector(didUploadLessonSignIn:) withObserver:self];
    }
    
    if (student_leave_array.count != 0){
        self.upload_count ++;
        [OMNetWork_MyClass uploadLesson_sign_in_status_withLessonID:self.OMLesson.lesson_id withStudent_array:student_leave_array withStatus_array:status_leave_array WithCallBack:@selector(didUploadLessonSignIn:) withObserver:self];
    }
    
    if (student_signin_array.count != 0){
        self.upload_count ++;
        [OMNetWork_MyClass uploadLesson_sign_in_status_withLessonID:self.OMLesson.lesson_id withStudent_array:student_signin_array withStatus_array:status_signin_array WithCallBack:@selector(didUploadLessonSignIn:) withObserver:self];
    }

    [student_absentee_array release];
    [status_absentee_array release];
    
    [student_leave_array release];
    [status_leave_array release];
    
    [student_signin_array release];
    [status_signin_array release];
    
}

- (void)prepareData{
    _upload_count = 0;
    [OMNetWork_MyClass getClassStudentsWithClass_id:self.OMClass.groupID withCallback:@selector(didGetStudentList:) withObserver:self];
}



#pragma mark - NetWork CallBack
- (void)didUploadLessonSignIn:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.upload_count --;
    }
}



- (void)didGetStudentList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.student_array = [OMDateBase_MyClass fetchClassMemberByClassID:self.OMClass.groupID andMemberType:@"1"];
    }
}


- (void)didGetLessonSigninStatus:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        self.lesson_signin_status = [OMDateBase_MyClass fetchLessonPerformanceWithStudent_id:nil WithLesson_id:self.OMLesson.lesson_id withProperty_id:@"10"];
        
        
        
        
        NSMutableArray *status_array = [[NSMutableArray alloc]init];
        NSInteger count = self.lesson_signin_status.count;
        for (int i = 0; i < count; i++) {
            if ([((LessonPerformanceModel *)self.lesson_signin_status[i]).property_value integerValue] == -1 || [((LessonPerformanceModel *)self.lesson_signin_status[i]).property_value integerValue] == 4) {
                self.canEdit = YES;
                SchoolMember *student = self.student_array[i];
                LessonPerformanceModel *status = [[LessonPerformanceModel alloc]init];
                status.student_id = student.userID;
                status.property_name = student.alias;
                if ([((LessonPerformanceModel *)self.lesson_signin_status[i]).property_value integerValue] == 4) {
                    status.property_value = @"2";
                }else{
                    status.property_value = @"3";
                }
                [status_array addObject:status];
                [status release];
            }else{
                self.canEdit = NO;
                SchoolMember *student = self.student_array[i];
                LessonPerformanceModel *status = self.lesson_signin_status[i];
                status.property_name = student.alias;
                [status_array addObject:status];
            }
            
        }
        self.lesson_signin_status = status_array;
        
        
        
//        if (self.lesson_signin_status.count == 0){
//            self.canEdit = YES;
//            int count = self.student_array.count;
//            
//            for (int i=0; i<count; i++){
//                SchoolMember *student = self.student_array[i];
//                LessonPerformanceModel *status = [[LessonPerformanceModel alloc]init];
//                status.student_id = student.userID;
//                status.property_name = student.alias;
//                status.property_value = @"3";
//                [status_array addObject:status];
//                [status release];
//            }
//            self.lesson_signin_status = status_array;
//        }else{
//            self.canEdit = NO;
//            int count = self.student_array.count;
//            for (int i=0; i<count; i++){
//                SchoolMember *student = self.student_array[i];
//                LessonPerformanceModel *status = self.lesson_signin_status[i];
//                status.property_name = student.alias;
//            }
//        }
        
        [status_array release];
        
        [self.tableView reloadData];
    }
}



#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lesson_signin_status.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LessonStatusCell *lessonStatusCell = [LessonStatusCell cellWithTableView:tableView];
    
    lessonStatusCell.delegate = self;
    lessonStatusCell.enabledSelect = self.canEdit;
    lessonStatusCell.lessonPerformanceModel = self.lesson_signin_status[indexPath.row];
    
    return lessonStatusCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    bg_view.backgroundColor = [UIColor whiteColor];
    UIView *lab_bg_view = [[UIView alloc]initWithFrame:CGRectMake(bg_view.bounds.size.width/2, 0, 140, bg_view.bounds.size.height)];
    for (int i=0 ; i<3 ; i++){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(lab_bg_view.bounds.size.width/3 * i, 0, lab_bg_view.bounds.size.width/3, lab_bg_view.bounds.size.height)];
        if (i== 2){
            label.frame = CGRectMake(label.frame.origin.x - 10, label.frame.origin.y, lab_bg_view.bounds.size.width/3 + 20, label.frame.size.height);
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @[NSLocalizedString(@"缺勤", nil),NSLocalizedString(@"请假", nil),NSLocalizedString(@"签到", nil)][i];
        label.font = [UIFont systemFontOfSize:12];
        [lab_bg_view addSubview:label];
        [label release];
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bg_view.frame.size.height - 1, bg_view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1];
    [bg_view addSubview:line];
    [line release];
    [bg_view addSubview:lab_bg_view];
    [lab_bg_view release];
    return [bg_view autorelease];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

#pragma mark - LessonStatusCellDelegate


- (void)didSelect_sign_in_status_withStudent_id:(NSString *)student_id withIndex:(NSInteger)index{
    NSInteger count = self.lesson_signin_status.count;
    for (int i=0; i<count; i++) {
        LessonPerformanceModel *status = self.lesson_signin_status[i];
        if ([student_id isEqualToString:status.student_id]){
            status.property_value = [NSString stringWithFormat:@"%zi",index + 1];
            return;
        }
    }
}

/**
 *  全部签到
 *
 */
- (IBAction)allSignIn:(id)sender {
    NSMutableArray *lesson_statuses = [[NSMutableArray alloc] init];
    [lesson_statuses addObjectsFromArray:self.lesson_signin_status];
    [self.lesson_signin_status removeAllObjects];
    NSInteger count = lesson_statuses.count;
    for (int i = 0; i < count; i++) {
        LessonPerformanceModel *status = lesson_statuses[i];
        status.property_value = @"3";
        [self.lesson_signin_status addObject:status];
    }
    [self.tableView reloadData];
    [lesson_statuses release];
}

@end
