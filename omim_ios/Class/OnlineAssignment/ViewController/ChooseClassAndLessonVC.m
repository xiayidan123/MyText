//
//  ChooseClassAndLessonVC.m
//  dev01
//
//  Created by Huan on 15/5/14.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  在线作业 选择班级和课表页


#import "ChooseClassAndLessonVC.h"
#import "OMClass.h"
#import "Lesson.h"
#import "SignInOrLeaveCell.h"
#import "PublicFunctions.h"
#import "ClassListViewController.h"
#import "LessonListViewController.h"
#import "AssignmentVC.h"
@interface ChooseClassAndLessonVC ()<ClassListViewControllerDelegate,LessonListViewController>
@property (retain, nonatomic) IBOutlet UITableView *classAndLessonTableView;
@property (retain, nonatomic) NSArray *NameArray;
@property (retain, nonatomic) Lesson  *OMLesson;
/**复用请假页面列表的cell */
@property (retain, nonatomic) SignInOrLeaveCell *valueCell;
/**用来判断是不是从之前页面传进来的OMClass */
@property (assign, nonatomic) BOOL isFromNextVC;

@end

@implementation ChooseClassAndLessonVC

- (void)dealloc {
    self.OMClass = nil;
    self.OMLesson = nil;
    [_classAndLessonTableView release];
    self.NameArray = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"在线作业";
    self.navigation_back_button_title=@"首页";
    [self configNavgation];
    self.classAndLessonTableView.tableFooterView = [[[UIView alloc] init] autorelease];
}
- (void)configNavgation{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(sure)] autorelease];
}
- (void)sure{
    
    if (self.OMClass && self.OMLesson) {
        AssignmentVC *assignmentVC = [[[AssignmentVC alloc] init] autorelease];
        assignmentVC.lessonModel = self.OMLesson;
        assignmentVC.classModel = self.OMClass;
        [self.navigationController pushViewController:assignmentVC animated:YES];
    }else{
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请填写完整信息", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil] autorelease];
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

#pragma mark tableView dataSource && delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SignInOrLeaveCell *cell = [SignInOrLeaveCell cellWithTableView:tableView];
    cell.title_label.text = self.NameArray[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0 && self.OMClass != nil){
        cell.content_label.text = self.OMClass.groupNameOriginal;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//cell 的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.valueCell = (SignInOrLeaveCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        if(self.OMClass != nil && !self.isFromNextVC)return;
        ClassListViewController *classVC = [[[ClassListViewController alloc] initWithNibName:@"LessonListViewController" bundle:nil] autorelease];
        classVC.delegate = self;
        [self.navigationController pushViewController:classVC animated:YES];
    }else{
        LessonListViewController *lessonVC = [[[LessonListViewController alloc] initWithNibName:@"LessonListViewController" bundle:nil] autorelease];
        lessonVC.isScreen = YES;
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

//cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
#pragma mark ClassListViewControllerDelegate
- (void)getClassName:(OMClass *)classModel
{
    self.OMClass = classModel;
    self.isFromNextVC = YES;
    self.valueCell.content_label.text = classModel.groupNameOriginal;
    [self.classAndLessonTableView reloadData];
}

#pragma mark LessonListViewControllerDelegate
- (void)getLessonList:(Lesson *)lesson
{
    self.OMLesson = lesson;
    self.valueCell.content_label.text = lesson.title;
    [self.classAndLessonTableView reloadData];
}
@end
