//
//  LeaveViewController.m
//  dev01
//
//  Created by Huan on 15/4/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  签到  跟请假页面写反了

#import "LeaveViewController.h"
#import "ClassListViewController.h"
#import "LessonListViewController.h"
#import "ClassLessonTeacherCell.h"
#import "SignInOrLeaveCell.h"
#import "PublicFunctions.h"
#import "OMClass.h"
#import "Lesson.h"
#import "CallTheRollViewController.h"
@interface LeaveViewController ()<UITableViewDataSource,UITableViewDelegate,ClassListViewControllerDelegate,LessonListViewController>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *NameArray;
@property (retain, nonatomic) OMClass *OMClass;
@property (retain, nonatomic) Lesson  *OMLesson;
@property (retain, nonatomic) SignInOrLeaveCell *valueCell;

@end

@implementation LeaveViewController

- (void)dealloc {
    self.class_model = nil;
    self.NameArray = nil;
    self.OMClass = nil;
    self.OMLesson = nil;
    self.valueCell = nil;
    [_tableView release];
    [super dealloc];
}

-(void)setClass_model:(OMClass *)class_model{
    [_class_model release],_class_model = nil;
    _class_model = [class_model retain];
    
    
    self.OMClass = _class_model;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签到";
    [self configNavigation];
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}
- (void)configNavigation{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
}

- (void)sure{
    if (self.OMClass && self.OMLesson) {
//        if ([self.OMLesson.start_date integerValue] < (NSInteger)[[NSDate date] timeIntervalSince1970]) {
//            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"该节课已过期，不能进行签到", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil] autorelease];
//            [alertView show];
//            return;
//        }
        CallTheRollViewController *callTheRollVC = [[[CallTheRollViewController alloc] initWithNibName:@"CallTheRollViewController" bundle:nil] autorelease];
        callTheRollVC.OMClass = self.OMClass;
        callTheRollVC.OMLesson = self.OMLesson;
        [self.navigationController pushViewController:callTheRollVC animated:YES];
    }else{
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请填写完整班级和课表信息", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil] autorelease];
        [alertView show];
    }
}
- (NSArray *)NameArray
{
    if (!_NameArray) {
        
        NSArray *arr = @[@"班级",@"课表"];
        _NameArray = [arr retain];
    }
    return _NameArray;
}

#pragma mark tableViewDataSource && tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SignInOrLeaveCell *cell = [SignInOrLeaveCell cellWithTableView:tableView];
    cell.title_label.text = self.NameArray[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0 && self.class_model != nil){
        cell.content_label.text = self.class_model.groupNameOriginal;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.valueCell = (SignInOrLeaveCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        if(self.class_model != nil)return;
        ClassListViewController *classVC = [[[ClassListViewController alloc] initWithNibName:@"LessonListViewController" bundle:nil] autorelease];
        classVC.delegate = self;
        [self.navigationController pushViewController:classVC animated:YES];
    }else{
        LessonListViewController *lessonVC = [[[LessonListViewController alloc] initWithNibName:@"LessonListViewController" bundle:nil] autorelease];
        lessonVC.isLeave=YES;
        if (self.OMClass) {
            lessonVC.classModel = self.OMClass;
            lessonVC.delegate = self;
            [self.navigationController pushViewController:lessonVC animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"请先选择班级" delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil] autorelease];
            [alertView show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
#pragma mark ClassListViewControllerDelegate
- (void)getClassName:(OMClass *)classModel
{
    self.OMClass = classModel;
    self.valueCell.content_label.text = classModel.groupNameOriginal;
    [self.tableView reloadData];
}

#pragma mark LessonListViewControllerDelegate
- (void)getLessonList:(Lesson *)lesson
{
    self.OMLesson = lesson;
    self.valueCell.content_label.text = lesson.title;
    [self.tableView reloadData];
}
@end
