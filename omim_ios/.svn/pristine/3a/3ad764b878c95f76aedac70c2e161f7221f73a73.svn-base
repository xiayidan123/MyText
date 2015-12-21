//
//  CameraListVC.m
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "CameraListVC.h"
#import "PublicFunctions.h"
#import "CameraListCell.h"
#import "OMNetWork_MyClass.h"

#import "ClassRoom.h"
#import "ClassModel.h"
#import "ClassRoomCamera.h"

@interface CameraListVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *cameraListTab;
@property (retain, nonatomic) NSMutableArray *cameraArray;

@end

@implementation CameraListVC

- (void)dealloc {
    [_classRoom release];
    [_cameraArray release];
    [_cameraListTab release],_cameraListTab.delegate = nil,_cameraListTab.dataSource = nil,_cameraListTab = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self configNavigation];
    [self uiConfig];
}

- (void)prepareData
{
    _cameraArray = [[NSMutableArray alloc]init];
    
    [OMNetWork_MyClass getCameraWithClassRoom:self.classRoom withCallBack:@selector(didGetCameraList:) withObserver:self];
}

- (void)configNavigation
{
    self.title =  NSLocalizedString(@"摄像头", nil);
    
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarButton];
}
- (void)backAction
{
    if (self.cameraArray == nil || self.cameraArray.count == 0){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [OMNetWork_MyClass setCameraStatusWithCameraArray:self.cameraArray withCallBack:@selector(didSetCameraStatus:) withObserver:self];
}

- (void)uiConfig
{
    _cameraListTab.tableFooterView = [[[UIView alloc]init] autorelease];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CameraListCell *cell = [CameraListCell cellWithTableView:tableView];
    
    cell.classRoomCamera = self.cameraArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cameraArray.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000){
        [self.navigationController popViewControllerAnimated:YES];
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
            [_cameraListTab reloadData];
        }
    }else{
//#warning 做错误返回吗判断
    }
}

- (void)didSetCameraStatus:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if ([self.delegate respondsToSelector:@selector(cameraListVC:didSetCameraWithCameraListArray:)]){
            [self.delegate cameraListVC:self didSetCameraWithCameraListArray:self.cameraArray];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind",nil) message:NSLocalizedString(@"Modify the camera state failure",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:nil];
        alertView.tag = 2000;
        [alertView show];
        [alertView release];
    }
}



@end
