//
//  OMSearchContactViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMSearchContactViewController.h"

#import "OMSearchBar.h"

#import "WowTalkWebServerIF.h"
#import "WTError.h"

#import "Buddy.h"

#import "OMSearchBuddyResultCell.h"

#import "MessageVerificationViewController.h"

@interface OMSearchContactViewController ()<OMSearchBarDelegate,UITableViewDataSource,UITableViewDelegate,OMSearchBuddyResultCellDelegate,MessageVerificationViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *result_tableView;

@property (retain, nonatomic) IBOutlet OMSearchBar *search_bar;

@property (assign, nonatomic) BOOL isIDSearch;

/** 用户搜索结果数组 */
@property (retain, nonatomic) NSMutableArray * buddy_result_array;

/** 群组搜索结果数组 */
@property (retain, nonatomic) NSMutableArray * group_result_array;

/** 正在添加数组 */
//@property (retain, nonatomic) NSMutableArray * adding_array;




@end

@implementation OMSearchContactViewController

- (void)dealloc {
//    self.adding_array = nil;
    self.buddy_result_array = nil;
    self.group_result_array = nil;
    [_result_tableView release];
    [_search_bar release];
    [super dealloc];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.turnoff_slide_back = YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.turnoff_slide_back = NO;
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];

    [self uiConfig];
}


- (void)prepareData{
    self.isIDSearch = YES;
}

- (void)uiConfig{
    
//    [self.navigationController.navigationBar.backItem setTitle:@"HH"];
    
    self.search_bar.button_title = NSLocalizedString(@"Search",nil);
    self.search_bar.placeholder =  NSLocalizedString(@"输入用户账号查找",nil);
    
    self.navigation_back_button_title = @"返回";
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"昵称搜索",nil),NSLocalizedString(@"IDSearch",nil)]];
    segmentedControl.frame = CGRectMake(0, 0, 140, 30);
    [segmentedControl setTintColor:[UIColor whiteColor]];
    segmentedControl.selectedSegmentIndex = 1;
    segmentedControl.userInteractionEnabled = YES;
    [segmentedControl addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl release];
    
    self.result_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
}

- (void)clickSegment:(UISegmentedControl *)seg{
    if(seg.selectedSegmentIndex == 1){
        self.search_bar.placeholder = NSLocalizedString(@"输入用户账号查找",nil);
        self.isIDSearch = YES;
    }
    else{
        self.search_bar.placeholder = NSLocalizedString(@"输入用户昵称查找",nil);
        self.isIDSearch = NO;
    }
    [self.result_tableView reloadData];
}

#pragma mark - OMSearchBuddyResultCellDelegate

-(void)searchBuddyResultCell:(OMSearchBuddyResultCell *)cell addBuddy:(Buddy *)buddy{
    MessageVerificationViewController *message = [[MessageVerificationViewController alloc]init];
    message.buddy = buddy;
    message.delegate = self;
    [self.navigationController pushViewController:message animated:YES];
}


#pragma mark - OMSearchBarDelegate


- (void)searchBarShouldReturn:(OMSearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self searchBarCancelButtonClicked:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    if (self.search_bar.text.length == 0){
        NSString *message = self.isIDSearch ? @"搜索ID不能为空" : @"搜索昵称不能为空" ;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips",nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        [self.result_tableView reloadData];
        return;
    }
    
    
    self.omAlertViewForNet.title = @"正在搜索";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertViewForNet showInView:self.view];
    
    // 判断搜索类型
    if (self.isIDSearch){
        [self searchWithID];
    }else{
        [self searchWithNickName];
    }
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OMSearchBuddyResultCell *cell = [OMSearchBuddyResultCell cellWithTableview:tableView];
    cell.delegate = self;
    Buddy *buddy = self.buddy_result_array[indexPath.row];
    cell.buddy = buddy;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return self.buddy_result_array.count;
    }else{
        return self.group_result_array.count;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return self.buddy_result_array.count == 0 ? 0 : 20;
    }else{
        return self.group_result_array.count == 0 ? 0 : 20;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    header_view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1];
    
    UILabel *header_label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, header_view.width - 8, header_view.height)];
    header_label.font = [UIFont systemFontOfSize:12];
    header_label.textColor = [UIColor lightGrayColor];
    [header_view addSubview:header_label];
    [header_label release];
    
    header_label.text = section == 0 ? NSLocalizedString(@"用户",nil) : NSLocalizedString(@"群组",nil);
    
    return [header_view autorelease];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma makr - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark - Network
- (void)searchWithNickName{
    [WowTalkWebServerIF searchUserByKey:self.search_bar.text byKeyType:NO withType:@[@1,@2] withCallBack:@selector(getUserSearchResult:) withObserver:self];
}


- (void)searchWithID{
    [WowTalkWebServerIF searchUserByKey:self.search_bar.text byKeyType:YES withType:@[@1,@2] withCallBack:@selector(getUserSearchResult:) withObserver:self];
}

- (void)getUserSearchResult:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    self.buddy_result_array = [error.userInfo valueForKey:@"buddyArray"];
    if (error.code == NO_ERROR) {
        self.omAlertViewForNet.title = @"搜索完成";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
    }else{
        self.omAlertViewForNet.title = @"搜索失败";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    [self.result_tableView reloadData];
}

#pragma mark - MessageVerificationViewControllerDelegate
- (void)messageVerificationViewController:(MessageVerificationViewController *)messageVerificationVC didAddBuddy:(Buddy *)buddy{
    
    [self.result_tableView reloadData];
}

#pragma mark - Set and Get


//-(NSMutableArray *)adding_array{
//    if (_adding_array == nil){
//        _adding_array = [[NSMutableArray alloc]init];
//    }
//    return _adding_array;
//}







@end
