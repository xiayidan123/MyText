//
//  LessonLiveCameraListVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/9.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LessonLiveCameraListVC.h"
#import "PublicFunctions.h"
#import "ClassScheduleModel.h"
#import "CameraForStudentListCell.h"
#import "OMNetWork_MyClass.h"
#import "ClassModel.h"
#import "Reachability.h"

@interface LessonLiveCameraListVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *cameraListTableView;

@property (retain, nonatomic)NSMutableArray *cameraArray;

@property (retain, nonatomic)NSIndexPath *indexPath;

@end

@implementation LessonLiveCameraListVC

- (void)dealloc {
    [_indexPath release];
    [_classModel release];
    [_cameraArray release];
    [_classScheduleModel release];
    [_cameraListTableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self configNavigation];
    
    [self uiConfig];
    
}


- (void)prepareData{
    _cameraArray = [[NSMutableArray alloc]init];
    
    [OMNetWork_MyClass getCameraByLessonID:self.classScheduleModel.lesson_id withClassModel:self.classModel withCallBack:@selector(didGetCameraList:)  withObserver:self];
    
}


- (void)configNavigation{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(_classScheduleModel.title,nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uiConfig{
    self.cameraListTableView.tableFooterView = [[[UIView alloc]init] autorelease];
}

- (BOOL)hasCamera{
    BOOL hasCamera = NO;
    if (_cameraArray && _cameraArray.count > 0){
        hasCamera = YES;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"绑定的教室没有摄像头",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    return hasCamera;
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CameraForStudentListCell *cell = [CameraForStudentListCell cellWithTableView:tableView];
    
    cell.classRoomCamera = self.cameraArray[indexPath.row];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cameraArray.count;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    
    NSInteger type = [self netWorkType];
    if (type == ReachableViaWWAN ){// 2G/3G网络
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"The non WiFi network, may consume more traffic, whether to continue.",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
        alertView.tag = 2000;
        [alertView show];
        [alertView release];
    }else if (type == ReachableViaWiFi){// wife
//        ClassRoomCamera *camera = self.cameraArray[self.indexPath.row];
        
    }else if (type == NotReachable){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"Slow network",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
        [alertView show];
        [alertView release];
    }
}


- (NSInteger)netWorkType{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    return [r currentReachabilityStatus];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000 && buttonIndex == 1){

//        ClassRoomCamera *camera = self.cameraArray[self.indexPath.row];
        
        return;
    }
}

#pragma mark - NetWork CallBack

- (void)didGetCameraList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSArray *cameraArray = [[notif userInfo] valueForKey:@"fileName"];
        if ([cameraArray isKindOfClass:[NSArray class]]){
            [_cameraArray removeAllObjects];
            [_cameraArray addObjectsFromArray:cameraArray];
            if ([self hasCamera]){
                [_cameraListTableView reloadData];
            }
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"获取摄像头列表失败",nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alertView show];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [self.navigationController popViewControllerAnimated: YES];
            [alertView release];
        });
    }
}

@end
