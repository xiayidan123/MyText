//
//  AccountViewController.m
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "AccountViewController.h"
#import "WTUserDefaults.h"
#import "SetCellFrameModel.h"
#import "SetBaseCell.h"
#import "PublicFunctions.h"

#import "LogoutButtonView.h"
#import "AppDelegate.h"
#import "NSString+Format.h"

#import "ChangePasswordVC.h"

#import "BindingTelephoneViewController.h"
#import "OMChangeBindingTelephoneViewController.h"
#import "OMBindingEmailViewController.h"
#import "OMChangeBindingEmailViewController.h"


@interface AccountViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,LogoutButtonViewDelegate,OMBindingEmailViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *account_tableVIew;

@property (retain, nonatomic) NSMutableArray *itemsArray;

@property (assign, nonatomic) BOOL isFirstLoad;

/** 修改绑定的邮箱 */
@property (retain, nonatomic) OMChangeBindingEmailViewController *changeBindingEmailVC;
/** 绑定邮箱 */
@property (retain, nonatomic) OMBindingEmailViewController *bindingEmailVC;
/** 修改绑定的手机号码 */
@property (retain, nonatomic) OMChangeBindingTelephoneViewController *changeBindingTelephoneVC;
/** 绑定手机号码 */
@property (retain, nonatomic) BindingTelephoneViewController *bingdingTelephoneVC;

@end

@implementation AccountViewController

- (void)dealloc {
    
    [_account_tableVIew release],_account_tableVIew.dataSource = nil,_account_tableVIew.delegate = nil,_account_tableVIew = nil;
    [_itemsArray release];
    self.changeBindingEmailVC = nil;
    self.bindingEmailVC = nil;
    self.changeBindingTelephoneVC = nil;
    self.bingdingTelephoneVC = nil;
    
    [OMNotificationCenter removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self uiConfig];
}


- (void)prepareData{
    self.isFirstLoad = YES;
    
    [OMNotificationCenter addObserver:self selector:@selector(didChangeTelephoneNumber:) name:OM_DIDCHANGE_TELEPHONENUMBER object:nil];
    
    [OMNotificationCenter addObserver:self selector:@selector(didChangeEmail:) name:OM_DIDCHANGE_EMAIL object:nil];
}

- (void)uiConfig{
    
    self.account_tableVIew.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
    
    LogoutButtonView *logoutButtonView = [LogoutButtonView logoutButtonView];
    logoutButtonView.delegate = self;
    
    self.account_tableVIew.tableFooterView = logoutButtonView;
    
    [self configNav];
}



-(void)configNav
{
    self.title = NSLocalizedString(@"Account",nil);
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.isFirstLoad){
        [self prepareData];
        [self.account_tableVIew reloadData];
    }else{
        self.isFirstLoad = NO;
    }
}

#pragma mrak - Notifcation

- (void)didChangeTelephoneNumber:(NSNotification *)notif{
    self.itemsArray = nil;
    [self.account_tableVIew reloadData];
}


- (void)didChangeEmail:(NSNotification *)notif{
    self.itemsArray = nil;
    [self.account_tableVIew reloadData];
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetBaseCell *cell = [SetBaseCell cellWithTableView:tableView];
    
    cell.frameModel = self.itemsArray[indexPath.row];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}



#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                
            }break;
            case 1:{
                if ([WTUserDefaults getEmail]) {
                    OMChangeBindingEmailViewController *vc=[[OMChangeBindingEmailViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    [self.navigationController pushViewController:self.bindingEmailVC animated:YES];
                }

            }break;
            case 2:{
                SetCellFrameModel *frame_model = self.itemsArray[indexPath.row];
                if (frame_model.content.isTelephone){
                    [self.navigationController pushViewController:self.changeBindingTelephoneVC animated:YES];
                }else{
                    [self.navigationController pushViewController:self.bingdingTelephoneVC animated:YES];
                }
            }break;
            case 3:{
                ChangePasswordVC *changePasswordVC = [[ChangePasswordVC alloc]initWithNibName:@"ChangePasswordVC" bundle:nil];
                [self.navigationController pushViewController:changePasswordVC animated:YES];
                [changePasswordVC release];
            }break;
                
            default:
                break;
        }
    }
}

#pragma mark - OMBindingEmailViewControllerDelegate
-(void)didBindingEamil{
    [self prepareData];
    [self.account_tableVIew reloadData];
}


#pragma mark - LogoutButtonViewDelegate

-(void)logoutAppWithLogoutButtonView:(LogoutButtonView *)logoutButtonView{
    UIAlertView *showSelection = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Are you sure to logout?",nil)
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    [showSelection show];
    [showSelection release];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if ([WTUserDefaults getPwdChanged] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please set your password first", nil)
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        alertView.title = NSLocalizedString(@"正在退出", nil);
        
        [[AppDelegate sharedAppDelegate] logout];
    }
}

#pragma mark - Set and Get


-(NSMutableArray *)itemsArray{
    if (_itemsArray == nil){
        _itemsArray = [[NSMutableArray alloc]init];
        NSArray *titleArray = @[NSLocalizedString(@"用户名",nil)
                                ,NSLocalizedString(@"邮箱",nil)
                                ,NSLocalizedString(@"手机号码",nil)
                                ,NSLocalizedString(@"修改密码",nil)];
        
        NSString *userName = [WTUserDefaults getWTID];
        if (userName == nil || [userName length] == 0){
            userName = @"";
        }
        NSString *email = [WTUserDefaults getEmail];
        if (email == nil)email = NSLocalizedString(@"请绑定邮箱",nil);
        
        NSString *phone = [WTUserDefaults getPhoneNumber];
        if (phone == nil)phone = NSLocalizedString(@"请绑定手机号码",nil);
        NSString *changePassWord = @"";
        
        //    NSArray *contentArray = @[userName,email,phone,changePassWord];
        NSArray *contentArray = @[userName,email,phone,changePassWord];
        
        NSInteger count = titleArray.count;
        for (int i=0; i<count; i++){
            SetCellFrameModel *frameModel = [[SetCellFrameModel alloc]init];
            frameModel.cellHeight = 44;
            frameModel.title = titleArray[i];
            frameModel.content = contentArray[i];
            frameModel.canEnter = (i==0) ? NO :YES;
            [_itemsArray addObject:frameModel];
            [frameModel release];
        }
    }
    return _itemsArray;
}

-(OMChangeBindingEmailViewController *)changeBindingEmailVC{
    if (_changeBindingEmailVC){
        _changeBindingEmailVC = [[OMChangeBindingEmailViewController alloc]initWithNibName:@"OMChangeBindingEmailViewController" bundle:nil];
    }
    return _changeBindingEmailVC;
}

-(OMBindingEmailViewController *)bindingEmailVC{
    if (_bindingEmailVC == nil){
        _bindingEmailVC = [[OMBindingEmailViewController alloc]initWithNibName:@"OMBindingEmailViewController" bundle:nil];
        _bindingEmailVC.delegate = self;
    }
    return _bindingEmailVC;
}


-(OMChangeBindingTelephoneViewController *)changeBindingTelephoneVC{
    if (_changeBindingTelephoneVC == nil){
        _changeBindingTelephoneVC = [[OMChangeBindingTelephoneViewController alloc]initWithNibName:@"OMChangeBindingTelephoneViewController" bundle:nil];
    }
    return _changeBindingTelephoneVC;
}

-(BindingTelephoneViewController *)bingdingTelephoneVC{
    if (_bingdingTelephoneVC == nil){
        _bingdingTelephoneVC = [[BindingTelephoneViewController alloc]initWithNibName:@"BindingTelephoneViewController" bundle:nil];
    }
    return _bingdingTelephoneVC;
}






@end
