//
//  SearchContactVC.m
//  dev01
//
//  Created by 杨彬 on 15-1-5.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SearchContactVC.h"
#import "PublicFunctions.h"
#import "BizSearchBar.h"
#import "Colors.h"
#import "Buddy.h"
#import "AvatarHelper.h"
#import "WowTalkWebServerIF.h"
#import "WTUserDefaults.h"
#import "SearchCell.h"
#import "UserGroup.h"
#import "Constants.h"
#import "GroupContactViewController.h"
#import "Database.h"
#import "OfficialAccountViewController.h"
#import "ContactInfoViewController.h"
#import "WTHeader.h"
#import "MessageVerificationViewController.h"
#import "SearchUserResultCell.h"
#import "OMAlertViewForNet.h"

@interface AddFriendStatusModel : NSObject

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,assign)SearchUserResultCellStatus status;

@end


@implementation AddFriendStatusModel

-(void)dealloc{
    [_uid release],_uid = nil;
    [super dealloc];
}
@end


@interface SearchContactVC ()<MessageVerificationViewControllerDelegate,SearchUserResultCellDelegate>


@property (nonatomic,retain)NSMutableArray *addFriendStatusArray;

@property (retain, nonatomic) OMAlertViewForNet * omAlertView;

@end

@implementation SearchContactVC{
    UISegmentedControl *_segmentedControl;
    BizSearchBar *_searchBar;
    BOOL _isIDSearch;
    UITableView *_resultTableView;
    NSMutableArray *_resultUserArray;
    NSMutableArray *_resultGroupArray;
}

-(void)dealloc{
    
    self.omAlertView = nil;
    [_addFriendStatusArray release],_addFriendStatusArray = nil;
    [_resultGroupArray release],_resultGroupArray = nil;
    [_resultUserArray release],_resultUserArray = nil;
    [_resultTableView release],_resultTableView = nil;
    [_segmentedControl release],_segmentedControl = nil;
    [_searchBar release],_searchBar = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    
    [self loadSearchBar];
    
    [self prepareData];
    
    [self loadResultTableView];
}

- (void)configNavigationBar
{
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"昵称搜索",nil),NSLocalizedString(@"IDSearch",nil)]];
    _segmentedControl.frame = CGRectMake(0, 0, 180, 30);
    [_segmentedControl setTintColor:[UIColor whiteColor]];
    _segmentedControl.selectedSegmentIndex = 1;
    _segmentedControl.userInteractionEnabled = YES;
    [_segmentedControl addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
    
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
}

- (void)clickSegment:(UISegmentedControl *)segment{
//    _searchBar.text = @"";
    if(segment.selectedSegmentIndex == 1){
        _searchBar.placeholder = NSLocalizedString(@"输入用户账号查找",nil);
        _isIDSearch = YES;
        [_resultGroupArray removeAllObjects];
        [_resultUserArray removeAllObjects];
    }
    else{
        _searchBar.placeholder = NSLocalizedString(@"输入用户昵称查找",nil);
        _isIDSearch = NO;
        [_resultUserArray removeAllObjects];
        [_resultGroupArray removeAllObjects];
    }
    [_resultTableView reloadData];
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadSearchBar{
    UIView *searchBar = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
    searchBar.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:searchBar];
    [searchBar release];
    
    UIButton *btn_search=[[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-60, 0, 60, 45)];
    [btn_search setTitle:NSLocalizedString(@"Search",nil) forState:UIControlStateNormal];
    [btn_search setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_search setTitleColor:[UIColor colorWithRed:72.0/255 green:177.0/255 blue:180.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    btn_search.titleLabel.font = [UIFont systemFontOfSize:15];
    btn_search.backgroundColor=[Colors wowtalkbiz_searchbar_bg];
    [btn_search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [searchBar addSubview:btn_search];
    [btn_search release];
    
    _searchBar = [[BizSearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width-60 , 45)];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.backgroundColor=[UIColor clearColor];
    
    if(_segmentedControl.selectedSegmentIndex == 1){
        _searchBar.placeholder = NSLocalizedString(@"输入用户账号查找",nil);
    }
    else{
        _searchBar.placeholder = NSLocalizedString(@"输入用户昵称查找",nil);
    }
    
    [searchBar addSubview:_searchBar];
}


-(void)search:(id)sender{
    [_searchBar resignFirstResponder];
    [_resultGroupArray removeAllObjects];
    [_resultGroupArray removeAllObjects];
    if (_segmentedControl.selectedSegmentIndex == 0){
        [self searchWithNickName];
    }else{
        [self searchWithID];
    }
}

- (void)searchWithNickName{
    if (_searchBar.text == nil || [_searchBar.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"搜索昵称不能为空" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        [_resultUserArray removeAllObjects];
        [_resultGroupArray removeAllObjects];
        [_resultTableView reloadData];
        return;
    }
//    [WowTalkWebServerIF getGroupByKey:_searchBar.text withCallback:@selector(getGroupSearchResult:) withObserver:self];
    
    self.omAlertView = [OMAlertViewForNet OMAlertViewForNet];
    self.omAlertView.title = @"正在搜索";
    self.omAlertView.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertView show];
    [WowTalkWebServerIF searchUserByKey:_searchBar.text byKeyType:NO withType:@[@1,@2] withCallBack:@selector(getUserSearchResult:) withObserver:self];
    
    
}


- (void)searchWithID{
    if (_searchBar.text == nil || [_searchBar.text isEqualToString:@""]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"搜索ID不能为空" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        [_resultUserArray removeAllObjects];
        [_resultGroupArray removeAllObjects];
        [_resultTableView reloadData];
        return;
    }
    
    self.omAlertView = [OMAlertViewForNet OMAlertViewForNet];
    self.omAlertView.title = @"正在搜索";
    self.omAlertView.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertView show];
    [WowTalkWebServerIF searchUserByKey:_searchBar.text byKeyType:YES withType:@[@1,@2] withCallBack:@selector(getUserSearchResult:) withObserver:self];
    
//    [WowTalkWebServerIF getGroupByKey:_searchBar.text withCallback:@selector(getGroupSearchResult:) withObserver:self];
}





- (void)prepareData{
    _isIDSearch = YES;
    _resultUserArray = [[NSMutableArray alloc]init];
    _resultGroupArray = [[NSMutableArray alloc]init];
    _addFriendStatusArray = [[NSMutableArray alloc]init];
}

- (void)loadResultTableView{
    _resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, self.view.bounds.size.width, self.view.bounds.size.height - 108)];
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    _resultTableView.tableFooterView = [[[UIView alloc]init] autorelease];
    [self.view addSubview:_resultTableView];
}


#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        static NSString *CellIdentifier = @"SearchUserResultCellID";
        SearchUserResultCell *cell = (SearchUserResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = (SearchUserResultCell *)[[[NSBundle mainBundle] loadNibNamed:@"SearchUserResultCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.delegate = self;
        Buddy *buddy = [_resultUserArray objectAtIndex:indexPath.row];
        NSData *data = [AvatarHelper getThumbnailForUser:buddy.userID];
        cell.buddy = buddy;
        cell.headImageView.buddy = buddy;
        cell.inputSearchContent = _searchBar.text;
        cell.selectedIndex = _segmentedControl.selectedSegmentIndex;
        if (data) {
            cell.headImageView.headImage = [UIImage imageWithData:data];
        } else if(buddy.needToDownloadThumbnail) {
            cell.headImageView.headImage = [UIImage imageNamed:@"avatar_84.png"];
            [WowTalkWebServerIF getThumbnailForUserID:buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
        }
        
        if (buddy.isFriend) {// 已经是好友
            cell.status = DIDADD;
        }
        else{
            if ([buddy.userID isEqualToString:[WTUserDefaults getUid]]){// 是当前用户自己
                cell.status = ISSELF;
            }
            else
            cell.status = NOTADD;// 还没加
        }
        
        for (AddFriendStatusModel *model in _addFriendStatusArray){// 判断是否是正在添加中...
            if ([model.uid isEqualToString:buddy.userID] ){
                cell.status = model.status;
            }
        }
        
        return cell;
    }else{
        static NSString *CellId = @"SearchCell";
        SearchCell *searchObjectCell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
        
        if (!searchObjectCell) {
            searchObjectCell = [[[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId] autorelease];
        }
        
        UserGroup* group = [_resultGroupArray objectAtIndex:indexPath.row];
        searchObjectCell.groupName.text = group.groupNameOriginal;
        searchObjectCell.groupNumber.text  = group.shortid;
        NSData* data = [AvatarHelper getThumbnailForGroup:group.groupID];
        
        if (data) {
            searchObjectCell.groupImageview.image =  [UIImage imageWithData:data];
        }
        else
        {
            searchObjectCell.groupImageview.image = [UIImage imageNamed:DEFAULT_GROUP_AVATAR];
            [WowTalkWebServerIF getGroupAvatarThumbnail:group.groupID withCallback:@selector(didGetGroupThumbnail:) withObserver:self];
        }
        return searchObjectCell;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? _resultUserArray.count : _resultGroupArray.count ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return _resultUserArray.count == 0 ? 0: 20;
    }else{
        return _resultGroupArray.count == 0 ? 0: 20;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 20)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
    label.text = section == 0 ?NSLocalizedString(@"用户",nil) : NSLocalizedString(@"群组",nil);
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    [label release];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 1, view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:1];
    [view addSubview:line];
    [line release];
    
    return [view autorelease];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        UserGroup *selectedGroup = [_resultGroupArray objectAtIndex:indexPath.row];
        GroupContactViewController* gcvc = [[GroupContactViewController alloc] init];
        gcvc.group = selectedGroup;
        
        UserGroup* group =  [Database getFixedGroupByID:selectedGroup.groupID];
        
        if (group!=nil) {
            gcvc.groupid = selectedGroup.groupID;
            gcvc.isStanger = NO;
        }
        else{
            gcvc.isStanger = YES;
            gcvc.group.memberList = nil;
            gcvc.NoNeedToInitGroup = YES;
        }
        [self.navigationController pushViewController:gcvc animated:YES];
        [gcvc release];
    } else {
        [self viewBuddyWithInfo:[_resultUserArray objectAtIndex:indexPath.row]];
    }
}



-(void)viewBuddyWithInfo:(Buddy *)buddy
{
    
    
    if ([buddy.userID isEqualToString:[WTUserDefaults getUid]]) {
        return;
    }
    
    if (buddy.userType  == 0) {
        OfficialAccountViewController* oavc = [[OfficialAccountViewController alloc] init];
        oavc.account = buddy;
        [self.navigationController pushViewController:oavc animated:YES];
        [oavc release];
    }
    
    else{
        if ([buddy.buddy_flag isEqualToString:@"1"]) {
            ContactInfoViewController *contactInfoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
            contactInfoViewController.buddy = buddy;
            contactInfoViewController.contact_type = CONTACT_FRIEND;
            [self.navigationController pushViewController:contactInfoViewController animated:YES];
            [contactInfoViewController release];
        }
        /*else if ([buddy.buddy_flag isEqualToString:@"2"]){
         NonUserContactViewController* nucvc = [[NonUserContactViewController alloc] init];
         nucvc.buddy = buddy;
         [self.navigationController pushViewController:nucvc animated:YES];
         [nucvc release];
         }*/
        else{
            ContactInfoViewController *contactInfoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
            contactInfoViewController.buddy = buddy;
            contactInfoViewController.contact_type = CONTACT_STRANGER;
            [self.navigationController pushViewController:contactInfoViewController animated:YES];
            [contactInfoViewController release];
        }
        
    }
}


- (void)getUserSearchResult:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    NSMutableArray *buddyArray = [error.userInfo valueForKey:@"buddyArray"];
    if (error.code == NO_ERROR) {
        self.omAlertView.title = @"搜索完成";
        self.omAlertView.type = OMAlertViewForNetStatus_Done;
        [_resultUserArray removeAllObjects];
        [_resultUserArray addObjectsFromArray:buddyArray];
        
        
        [_resultTableView reloadData];
    }else{
        [_resultUserArray removeAllObjects];
        [_resultTableView reloadData];
    }
}


-(void)getGroupSearchResult:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [_resultGroupArray removeAllObjects];
        [_resultGroupArray addObjectsFromArray:[[notif userInfo] valueForKey:WT_SEARCH_RESULT]];
        [_resultTableView reloadData];
    }else{
        [_resultGroupArray removeAllObjects];
        [_resultTableView reloadData];
    }
}


- (void)getBuddyThumbnail:(NSNotification *)notification
{
    NSError* error = [[notification userInfo]valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [_resultTableView reloadData];
    }
}

-(void)didGetGroupThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [_resultTableView reloadData];
    }
}

#pragma mark -
#pragma mark - MessageVerificationViewControllerDelegate
-(void)didAddBuddyWithUID:(NSString *)uid{
    for (AddFriendStatusModel *model in _addFriendStatusArray){
        if ([model.uid isEqualToString:uid]){
            model.status = ADDING;
        }
    }
    [_resultTableView reloadData];
}

#pragma mark - 
#pragma mark - SearchUserResultCellDelegate

- (void)addFriendWithBuddy:(Buddy *)buddy{
    BOOL isExist = NO;
    for (AddFriendStatusModel *model in _addFriendStatusArray){
        if ([model.uid isEqualToString:buddy.userID]){
            isExist = YES;
        }
    }
    if (!isExist){
        AddFriendStatusModel *model = [[AddFriendStatusModel alloc]init];
        model.uid = buddy.userID;
        model.status = NOTADD;
        [_addFriendStatusArray addObject:model];
        [model release];
    }
    [WowTalkWebServerIF getThumbnailForUserID:buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
    MessageVerificationViewController *message = [[MessageVerificationViewController alloc]init];
    message.buddy = buddy;
    message.delegate = self;
    [self.navigationController pushViewController:message animated:YES];
}


-(void)addMySelf{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"不能添加自己" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [av show];
    [av release];

}

@end
