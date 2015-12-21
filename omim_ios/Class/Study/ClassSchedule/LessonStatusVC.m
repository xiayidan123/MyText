//
//  LessonStatusVC.m
//  dev01
//
//  Created by 杨彬 on 14-12-30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "LessonStatusVC.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "Database.h"
#import "WTHeader.h"
#import "OMAlertViewForNet.h"

@interface LessonStatusVC ()<UIAlertViewDelegate>
@property (retain, nonatomic) OMAlertViewForNet * omAlertView;

@end

@implementation LessonStatusVC{
    NSMutableArray *_lessonPerformanceArray;
    UITableView *_lessonPerformanceTableView;
    BOOL _isEmpty;
    BOOL _isTeacher;
    NSMutableArray *_emptyLessonPerformanceArray;
}


-(void)dealloc{
    self.omAlertView = nil;
    [_studentModel release];
    [_lesson_id release];
    
    [_lessonPerformanceArray release];
    [_lessonPerformanceTableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigation];
    
    [self loadUserTypeLimits];
    
    [self prepareData];
    
    [self uiConfig];
    
}


- (void)loadUserTypeLimits{
    if([[WTUserDefaults getUsertype] isEqualToString:@"2"]){
        _isTeacher = YES;
    }
}


- (void)configNavigation{
    
    self.title = self.studentModel.nickName;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)prepareData{
    _isEmpty = NO;
    _lessonPerformanceArray = [[NSMutableArray alloc]init];
    _emptyLessonPerformanceArray = [[NSMutableArray alloc]init];
    [self loadData];
}

- (void)loadData{
    [WowTalkWebServerIF getLessonPerformanceWithLessonID:_lesson_id withStudentID:_studentModel.uid WithCallBack:@selector(didGetLessonPerformance:) withObserver:self];
}


- (void)didGetLessonPerformance:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [_lessonPerformanceArray addObjectsFromArray:[Database fetchLessonPerformanceWithStudentID:_studentModel.uid WithLessonID:_lesson_id]];
        if (!_lessonPerformanceArray || (_lessonPerformanceArray.count == 0)){
            _isEmpty = YES;
            if (_isTeacher){
                _lessonPerformanceTableView.hidden = NO;
               [self loadEmptyData];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"老师还没评分哦", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认", nil)otherButtonTitles: nil];
                [alertView show];
                [alertView release];
                return;
            }
        }
        [_lessonPerformanceTableView reloadData];
    }
}

- (void)loadEmptyData{
    for (int i=0; i<9; i++){
        LessonPerformanceModel *lessonPerformanceModel = [[LessonPerformanceModel alloc]init];
        lessonPerformanceModel.lesson_id = _lesson_id;
        lessonPerformanceModel.student_id = _studentModel.uid;
        lessonPerformanceModel.property_id = [NSString stringWithFormat:@"%d",i + 1];
        lessonPerformanceModel.property_value = [NSString stringWithFormat:@"%d",1];
        lessonPerformanceModel.property_name = @[@"精神状态",@"参与程度",@"参与效果",@"认真",@"积极",@"自信",@"思维的条理性",@"思维的创造性",@"善于与人合作"][i];
        [_emptyLessonPerformanceArray addObject:lessonPerformanceModel];
        [lessonPerformanceModel release];
    }
}


- (void)uiConfig{
//    if (IS_IOS7) {
//        [self.view setAutoresizesSubviews:NO];
//        [self.view setAutoresizingMask:UIViewAutoresizingNone];
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    _lessonPerformanceTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _lessonPerformanceTableView.delegate = self;
    _lessonPerformanceTableView.dataSource = self;
    _lessonPerformanceTableView.hidden = YES;
    _lessonPerformanceTableView.tableFooterView = [[[UIView alloc] init]autorelease];
    [self.view addSubview:_lessonPerformanceTableView];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 301) {
        [self uploadAction];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *lessonStatusCellID = @"LessonStatusCellID";
    LessonStatusCell *lessonStatusCell = [tableView dequeueReusableCellWithIdentifier:lessonStatusCellID];
    if (!lessonStatusCell){
        lessonStatusCell = [[[NSBundle mainBundle]loadNibNamed:@"LessonStatusCell" owner:self options:nil] firstObject];
    }
    if (_isEmpty&& _isTeacher){
        lessonStatusCell.enabledSelect = YES;
        lessonStatusCell.lessonPerformanceModel = _emptyLessonPerformanceArray[indexPath.row];
        
    }else{
        lessonStatusCell.enabledSelect = NO;
        lessonStatusCell.lessonPerformanceModel = _lessonPerformanceArray[indexPath.row];
    }
    _lessonPerformanceTableView.hidden = NO;
    lessonStatusCell.delegate = self;
    
    return lessonStatusCell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _isEmpty ?  9 : _lessonPerformanceArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    bg_view.backgroundColor = [UIColor whiteColor];
    UIView *lab_bg_view = [[UIView alloc]initWithFrame:CGRectMake(bg_view.bounds.size.width/2, 0, 140, bg_view.bounds.size.height)];
    for (int i=0 ; i<3 ; i++){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(lab_bg_view.bounds.size.width/3 * i, 0, lab_bg_view.bounds.size.width/3, lab_bg_view.bounds.size.height)];
        if (i== 2){
            label.frame = CGRectMake(label.frame.origin.x - 10, label.frame.origin.y, lab_bg_view.bounds.size.width/3 + 20, label.frame.size.height);
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @[NSLocalizedString(@"棒极了", nil),NSLocalizedString(@"好", nil),NSLocalizedString(@"有待加强", nil)][i];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return _isEmpty ? 44 : 0;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UIButton *btn_upload = [UIButton buttonWithType:UIButtonTypeSystem];
    btn_upload.frame = CGRectMake(230, 10, 60, 24);
    [btn_upload setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [btn_upload setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_upload.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn_upload addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    btn_upload.layer.cornerRadius = 3;
    btn_upload.layer.masksToBounds = YES;
    btn_upload.layer.borderWidth = 1;
    btn_upload.layer.borderColor = [UIColor blackColor].CGColor;
    [bg_view addSubview:btn_upload];
    return [bg_view autorelease];
}


#pragma mark - LessonStatusCellDelegate
- (void)didSelectedStatusWithPropertyID:(NSInteger)property_id withIndex:(NSInteger)index{
    for (LessonPerformanceModel *lessonPerformanceModel in _emptyLessonPerformanceArray){
        if ([lessonPerformanceModel.property_id isEqualToString:property_id]){
            lessonPerformanceModel.property_value = [NSString stringWithFormat:@"%zi",index + 1];
        }
    }
}

- (void)sure{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"是否确定提交" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil] autorelease];
    alertView.tag = 301;
    [alertView show];
}



- (void)uploadAction{
    [WowTalkWebServerIF uploadLessonPerformanceWithLessonID:_lesson_id withStudentID:_studentModel.uid withPerFormanceArray:_emptyLessonPerformanceArray WithCallBack:@selector(didUploadLessonPerformance:) withObserver:self];
    self.omAlertViewForNet = [OMAlertViewForNet OMAlertViewForNet];
    self.omAlertView.type = OMAlertViewForNetStatus_Loading;
    self.omAlertViewForNet.title = @"正在提交";
    [self.omAlertViewForNet showInView:self.view];
}

- (void)didUploadLessonPerformance:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self storeUploadLessonStatus];
        [_lessonPerformanceArray addObjectsFromArray:[Database fetchLessonPerformanceWithStudentID:_studentModel.uid WithLessonID:_lesson_id]];
        if (_lessonPerformanceArray.count && (_lessonPerformanceArray.count != 0)){
            _isEmpty = NO;
        }
        [_lessonPerformanceTableView reloadData];
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        self.omAlertViewForNet.title = @"提交成功";
    }
}

- (void)storeUploadLessonStatus{
    for (int i=0; i<_emptyLessonPerformanceArray.count; i++){
        [Database storeLessonPerformance:_emptyLessonPerformanceArray[i]];
    }
}


@end
