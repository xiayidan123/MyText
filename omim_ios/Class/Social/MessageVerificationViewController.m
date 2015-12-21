//
//  MessageVerificationViewController.m
//  dev01
//
//  Created by mac on 14/12/30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "MessageVerificationViewController.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"
@interface MessageVerificationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, retain) NSMutableArray *userResults;

@property (retain, nonatomic) UITableView * tableView;

@property (retain, nonatomic) UITextField * tf_message;

@property (retain, nonatomic) UITextField * tf_remark;

@end

@implementation MessageVerificationViewController

-(void)dealloc
{
    self.tableView = nil;
    self.tf_message = nil;
    self.tf_remark = nil;
    
    self.buddy = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    
    [self configNav];
    
    [self uiConfig];
}

-(void)configNav
{
    self.title = NSLocalizedString(@"朋友验证",nil);
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle: NSLocalizedString(@"发送",nil) style:UIBarButtonItemStylePlain target:self action:@selector(send)] autorelease];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)send
{
    self.omAlertViewForNet.title = @"正在发送";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertViewForNet showInView:self.view];
    
    [WowTalkWebServerIF addBuddy:_buddy.userID withMsg:_tf_message.text withCallback:@selector(didAddFriend:) withObserver:self];
    self.buddy.relationship_type = Buddy_Relationship_type_ADDING;
    
    
    if ([_delegate respondsToSelector:@selector(didAddBuddyWithUID:)]) {
        [_delegate didAddBuddyWithUID:_buddy.userID];
    }
    
    if ([self.delegate respondsToSelector:@selector(messageVerificationViewController:didAddBuddy:)]){
        [self.delegate messageVerificationViewController:self didAddBuddy:self.buddy];
    }
    
}

- (void)uiConfig{
    [self loadTF];
    
    [self loadTableView];
}


- (void)loadTF{
    self.tf_message = [[[UITextField alloc]initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width , 44)] autorelease];
    self.tf_remark = [[[UITextField alloc]initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width , 44)] autorelease];
    self.tf_message.delegate = self;
    self.tf_remark.delegate = self;
}

- (void)loadTableView{
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


#pragma mark -TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _tf_message.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"我是",nil),[WTUserDefaults getNickname]];
            [cell.contentView addSubview:_tf_message];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            _tf_remark.text = [NSString stringWithFormat:@"%@",_buddy.nickName];
            [cell.contentView addSubview:_tf_remark];
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"你需要发送验证申请，等待对方通过",nil);
    } else if (section == 1) {
        return NSLocalizedString(@"为好友设置备注名",nil) ;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - didnetwork
- (void)didAddFriend:(NSNotification *)notification
{
    NSDictionary *infodict = [notification userInfo];
    NSError *err = [infodict objectForKey:@"error"];
    if (err && err.code != 0)
    {
        self.omAlertViewForNet.title = NSLocalizedString(@"Failed to send request", nil);
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    else
    {
        if (_buddy.addFriendRule == 2) {
            self.omAlertViewForNet.title = NSLocalizedString(@"Friend has been added", nil);
            self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        }
        else{
            self.omAlertViewForNet.title = @"申请已发送";
            self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        }
    }
}

#pragma mark - OMAlertViewForNetDelegate
- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
