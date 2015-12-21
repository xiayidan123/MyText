//
//  OMSettingVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMSettingVC.h"
#import "SetCellFrameModel.h"

#import "SetUserInfoCell.h"
#import "SetBaseCell.h"
#import "CheckVersionCell.h"
#import "OMSwitchCell.h"

#import "WTUserDefaults.h"
#import "PublicFunctions.h"

#import "AccountViewController.h"
#import "QRShowViewController.h"

#import "PersonalInfoVC.h"
#import "AboutViewController.h"

#import "leftBarBtn.h"

#import "OMNetWork_Setting.h"

@interface OMSettingVC ()<UITableViewDataSource,UITableViewDelegate,PersonalInfoVCDelegate,OMSwitchCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView *setting_tableView;

@property (retain, nonatomic) NSMutableArray *itemsArray;

@end

@implementation OMSettingVC

- (void)dealloc {
    [_setting_tableView release],_setting_tableView.dataSource = nil,_setting_tableView.delegate = nil,_setting_tableView = nil;
    [_itemsArray release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.setting_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self uiConfig];
}

- (void)prepareData{
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    NSString *nickname = [WTUserDefaults getNickname];
    if (nickname == nil)nickname = @"";
//    NSArray *titleArray = @[@[nickname
//                            ,NSLocalizedString(@"我的二维码",nil)
//                            ,NSLocalizedString(@"账号",nil)
//                            ,NSLocalizedString(@"拒绝接受任何学校邀请",nil)],
//                            @[NSLocalizedString(@"评价",nil)
//                            ,NSLocalizedString(@"关于本软件",nil)]];

    NSArray *titleArray = @[@[nickname
                              ,NSLocalizedString(@"我的二维码",nil)
                              ,NSLocalizedString(@"账号",nil)],
                            @[NSLocalizedString(@"评价",nil)
                              ,NSLocalizedString(@"关于本软件",nil)]];

    NSInteger count = titleArray.count;
    for (int i=0; i<count; i++){
        NSInteger jcount = [titleArray[i] count];
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        for (int j=0; j<jcount; j++ ){
            SetCellFrameModel *frameModel = [[SetCellFrameModel alloc]init];
            frameModel.cellHeight = (i==0&&j==0 ? 90 : 44);
            frameModel.title = titleArray[i][j];
            frameModel.canEnter = (i==1&&j==0) ? NO :YES;
            
//  关闭 拒绝接受任何学校的邀请 按钮 － Jon
//            if (i == 0 && j== 3){
//                OMUserSetting *user_setting = [OMUserSetting getUserSetting];
//                frameModel.on = user_setting.allow_school_invitation;
//            }
            
            [sectionArray addObject:frameModel];
            [frameModel release];
        }
        [itemsArray addObject:sectionArray];
        [sectionArray release];
    }
    self.itemsArray = itemsArray;
    [itemsArray release];
}


- (void)uiConfig{
    [self configNav];
    
    self.setting_tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    
    
}

-(void)configNav
{
    self.title = NSLocalizedString(@"Setting",nil);
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0){
        SetUserInfoCell *cell = [SetUserInfoCell cellWithTableView:tableView];
        cell.frameModel = self.itemsArray[indexPath.section][indexPath.row];
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 3){
        OMSwitchCell *cell = [OMSwitchCell cellWithTableView:tableView];
        cell.frame_model = self.itemsArray[indexPath.section][indexPath.row];
        cell.delegate = self;
        return cell;
    }else{
        SetBaseCell *cell = [SetBaseCell cellWithTableView:tableView];
        cell.frameModel = self.itemsArray[indexPath.section][indexPath.row];
        return cell;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemsArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemsArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.itemsArray[indexPath.section][indexPath.row] cellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}



#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                PersonalInfoVC *personalInfoVC = [[PersonalInfoVC alloc]initWithNibName:@"PersonalInfoVC" bundle:nil];
                personalInfoVC.delegate = self;
                [self.navigationController pushViewController:personalInfoVC animated:YES];
                [personalInfoVC release];
            }break;
            case 1:{
                QRShowViewController *QRShowVC = [[QRShowViewController alloc] initWithNibName:@"QRShowViewController" bundle:nil];
                [self.navigationController pushViewController:QRShowVC animated:YES];
                [QRShowVC release];
            }break;
            case 2:{
                AccountViewController *accountVC = [[AccountViewController alloc]initWithNibName:@"AccountViewController" bundle:nil];
                [self.navigationController pushViewController:accountVC animated:YES];
                [accountVC release];
            }break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://appsto.re/cn/32Oh1.i"]];
                
            }break;
            case 1:{
                AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                [self.navigationController pushViewController:aboutViewController animated:YES];
                [aboutViewController release];
            }break;
           
                
            default:
                break;
        }
    }
    
}


#pragma mark - PersonalInfoVCDelegate

-(void)personalInfoVC:(PersonalInfoVC *)personalInfoVC didChangeNickName:(NSString *)newNickName{
    /*
    SetCellFrameModel *infoFrameModel = self.itemsArray[0][0];
    
    infoFrameModel.title = newNickName;
    
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [self.setting_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
     */
    [self prepareData];
    [self.setting_tableView reloadData];
    
}

-(void)personalInfoVC:(PersonalInfoVC *)personalInfoVC didChangeHeadImageIsThumb:(BOOL)isThumb{
    [self prepareData];
    [self.setting_tableView reloadData];
}

#pragma mark - OMSwitchCellDelegate
- (void)switchCell:(OMSwitchCell *)switchCell didChangeState:(BOOL)on{
    OMUserSetting *user_setting = [OMUserSetting getUserSetting];
    user_setting.allow_school_invitation = on;
    
    [OMNetWork_Setting putUserSettings:user_setting withCallback:@selector(didChangeSetting:) withObserver:self];
}

- (void)didChangeSetting:(NSNotification *)notif{
    [self prepareData];
    [self.setting_tableView reloadData];
}



@end
