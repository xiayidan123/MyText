//
//  ClassRoomVC.m
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassRoomVC.h"
#import "PublicFunctions.h"
#import "ClassRommCell.h"
#import "ClassRoom.h"
#import "Lesson.h"
#import "OMClass.h"

#import "ClassScheduleModel.h"

#import "OMNetWork_MyClass.h"
#import "OMDateBase_MyClass.h"

#import "ReleaseClassRoomModel.h"

#import "NSDate+ClassScheduleDate.h"
#import "MBProgressHUD.h"
@interface ClassRoomVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,retain)NSIndexPath *selectedIndex;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSMutableArray *classRoomArray;

@property (retain, nonatomic) UIButton *releaseBindBtn;

@property (retain, nonatomic) MBProgressHUD * hud;
@end

@implementation ClassRoomVC

- (void)dealloc {
    [_classModel release];
    
    [_classRoomArray release];
    
    [_lessonModel release];
    
    [_releaseBindBtn release],_releaseBindBtn = nil;
    
    [_tableView release],_tableView.delegate = nil;_tableView.dataSource = nil;_tableView = nil;;
    [super dealloc];
}


-(OMClass *)classModel{
    if (_classModel == nil){
        _classModel = [OMDateBase_MyClass getClassWithClassID:self.lessonModel.class_id];
    }
    return _classModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self configNavigation];
    [self uiConfig];
}
- (void)configNavigation
{
    self.title = NSLocalizedString(@"可选教室", nil);
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Save",nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveClassRoomAction)] autorelease];
}


- (void)saveClassRoomAction
{
    if (self.selectedIndex.section != 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"Did not choose the classroom",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"正在保存...";
    _hud.margin = 10.f;
    _hud.yOffset = 150.f;
    _hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES afterDelay:3];
    [OMNetWork_MyClass selectClassRoomWithClassRoom:self.classRoomArray[self.selectedIndex.row] andLessonModel:self.lessonModel withCallBack:@selector(didSelectedRoom:) withObserver:self];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)uiConfig
{
    [self loadTableViewFooterView];
}

- (void)loadTableViewFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 60)];
    
    self.releaseBindBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.releaseBindBtn.frame = CGRectMake(0, 0, footerView.bounds.size.width, 44);
    self.releaseBindBtn.center = CGPointMake(footerView.bounds.size.width/2, footerView.bounds.size.height/2);
    [self.releaseBindBtn setTitle:NSLocalizedString(@"解除绑定教室",nil) forState:UIControlStateNormal];
    [self.releaseBindBtn setTitle:NSLocalizedString(@"拼命加载中...",nil) forState:UIControlStateDisabled];
    self.releaseBindBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.releaseBindBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.releaseBindBtn setTitleColor:[UIColor colorWithRed:1 green:0.16 blue:0.23 alpha:1] forState:UIControlStateNormal];
    [self.releaseBindBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    self.releaseBindBtn.backgroundColor = [UIColor whiteColor];
    
    [self.releaseBindBtn addTarget:self action:@selector(releaseBinAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.releaseBindBtn.enabled = NO;
    
    [footerView addSubview:self.releaseBindBtn];
    
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = CGPointMake(self.releaseBindBtn.frame.size.width/2 - 60, self.releaseBindBtn.frame.size.height/2);
    activity.tag = 500;
    [self.releaseBindBtn addSubview:activity];
    [activity startAnimating];
    [activity release];
    
    _tableView.tableFooterView = footerView;
    [footerView release];

    _tableView.tableHeaderView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 10)] autorelease];
}


- (void)releaseBinAction:(UIButton *)button{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"确定要解除绑定教室?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil),nil];
    alertView.tag = 2000;
    [alertView show];
    [alertView release];
}

- (void)prepareData
{
    self.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    
    _classRoomArray = [[NSMutableArray alloc] init];

    [self loadData];
}


- (void)loadData{
    self.classModel = [OMDateBase_MyClass getClassWithClassID:self.lessonModel.class_id ];

    NSArray *introductionArray = [self.classModel.intro componentsSeparatedByString:@","];
    
    NSString *startTimeStr = nil;
    NSString *timelongStr = nil;
    if (introductionArray.count >= 5){
        startTimeStr = introductionArray[4];
    }
    if (introductionArray.count >= 7){
        timelongStr = introductionArray[6];
    }else{
        timelongStr = @"00:45";
    }
    
    [OMNetWork_MyClass getClassRoomWithSchoolID:self.classModel.school_id andStartDate:self.lessonModel.start_date andEndDate:self.lessonModel.end_date withCallBack:@selector(didGetRoom:) withObserver:self];
}






#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassRommCell *cell = [ClassRommCell cellWithTableView:tableView];
    
    cell.classRoom = _classRoomArray[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _classRoomArray.count;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectedRoomWithIndexPath:indexPath];
}





- (void)selectedRoomWithIndexPath:(NSIndexPath *)indexPath{
    ((ClassRoom *)_classRoomArray[_selectedIndex.row]).isSelected = NO;
    self.selectedIndex = indexPath;
    ((ClassRoom *)_classRoomArray[indexPath.row]).isSelected = YES ;
    [self.tableView reloadData];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000){
        if (buttonIndex == 1){
            [OMNetWork_MyClass releaseRoomWithLessonID:self.lessonModel.lesson_id withCallBack:@selector(didReleaseRoom:) withObserver:self];
        }
        return;
    }
    
    
}


#pragma mark - NetWork CallBack

- (void)didGetRoom:(NSNotification *)notif{
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self.releaseBindBtn viewWithTag:500];
    [activity stopAnimating];
    [activity removeFromSuperview];
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [_classRoomArray removeAllObjects];
        [_classRoomArray addObjectsFromArray:[[notif userInfo] valueForKey:@"fileName"]];
        
        if (_classRoomArray.count >0 ){
            self.releaseBindBtn.enabled = YES;
        }else{
            [self.releaseBindBtn setTitle:NSLocalizedString(@"没有可供绑定的教室",nil) forState:UIControlStateDisabled];

            self.releaseBindBtn.enabled = NO;
        }
        [_tableView reloadData];
    }else{
        
    }
}

- (void)didSelectedRoom:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSDictionary *dic = [[notif userInfo] valueForKey:@"fileName"];
        if ([dic[@"status"] integerValue] == 1){
            if ([self.delegate respondsToSelector:@selector(didSelectedClassRoom:withClassRoom:)]){
                [self.delegate didSelectedClassRoom:self withClassRoom:_classRoomArray[self.selectedIndex.row]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"该教室已被占用",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"绑定教室失败,请重新绑定",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)didReleaseRoom:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        id obj = [[notif userInfo] valueForKey:@"fileName"];
        
        if ([obj isKindOfClass:[NSArray class]]){
            ReleaseClassRoomModel *releaseClassRoomModel = [obj firstObject];
            if (releaseClassRoomModel.status){// 成功解除绑定的教室
                if ([self.delegate respondsToSelector:@selector(didReleaseRoom:withRoomID:)]){
                    [self.delegate didReleaseRoom:self withRoomID:releaseClassRoomModel.room_id];
                }
            }
            [self loadData];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"解除绑定失败",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


@end
