//
//  SchoolViewController.m
//  MG
//
//  Created by macbook air on 14-9-22.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import "SchoolViewController.h"
#import "HeaderView.h"
#import "GradeCell.h"
#import "Buddy.h"
#import "ClassModel.h"
#import "PersonModel.h"
#import "SchoolModel.h"
#import "GroupChatRoom.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "AddContactViewController.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"
#import "Constants.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "ContactListCell.h"
#import "AddBuddyFromSchoolVC.h"

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "MessagesVC.h"

#import "OMDateBase_MyClass.h"
#import "OMNetWork_MyClass.h"
#import "OMClass.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SchoolViewController ()<RATreeViewDelegate, RATreeViewDataSource>
{
    
    UISearchBar *_searchBar;
    UISearchDisplayController *_displayController;
    NSMutableArray *_searchResultDataArray;
    RATreeView *_treeView;
    id expanded;
}

@property (assign, nonatomic)BOOL classListDidDownLoad;

@property (assign, nonatomic)BOOL membersDidDownLoad;

@property (assign, nonatomic)BOOL schoolListDidDownLoad;

@end

@implementation SchoolViewController




-(void)dealloc{
    [_treeView release];
    
    [_schoolMembersDataArray release];
    [_searchBar release];
    [_displayController release];
    [_searchResultDataArray release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAddContactsView];
    
    [self prepareData];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetSchoolMemberThumbnail:) name:WT_GET_SCHOOL_MEMBER_PHOTO_THUMBNAIL object:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





- (void)didGetSchoolMemberThumbnail:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [_treeView reloadData];
    }
}



// 数据初始化
- (void)prepareData{
    
    _schoolMembersDataArray = [[NSMutableArray alloc]init];
    _searchResultDataArray = [[NSMutableArray alloc]init];
    
    [self fetchDataFromDB];
    
    if (_schoolMembersDataArray.count > 0){
       RATreeView *treeViewFromDB = [[RATreeView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 108)];
        treeViewFromDB.delegate = self;
        treeViewFromDB.dataSource = self;
        [treeViewFromDB setEditing:NO animated:NO];
        treeViewFromDB.editing = NO;
        treeViewFromDB.tag = 2000;
        [treeViewFromDB reloadData];
        [treeViewFromDB setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
        [self.view addSubview:treeViewFromDB];
    }
    
    [self loadData];
}

// 数据获取
- (void)loadData{
    self.membersDidDownLoad = NO;
    self.classListDidDownLoad = NO;
    self.schoolListDidDownLoad =NO;
    
    [WowTalkWebServerIF getSchoolListWithCallBack:@selector(didGetSchoolList:) withObserver:self];
    [WowTalkWebServerIF getSchoolMembersWithCallBack:@selector(didGetSchoolMembers:) withObserver:self];
    [OMNetWork_MyClass getClassListWithCallBack:@selector(didGetClassList:) withObserver:self];
}

- (void)didGetSchoolMembers:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.membersDidDownLoad = YES;
        if (self.classListDidDownLoad && self.schoolListDidDownLoad){
            [self fetchData];
        }
    }
}


- (void)didGetSchoolList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.schoolListDidDownLoad = YES;
        if (self.classListDidDownLoad && self.membersDidDownLoad){
            [self fetchData];
            [_treeView removeFromSuperview];
            return;
        }
    }
}



- (void)didGetClassList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.classListDidDownLoad = YES;
        if (self.membersDidDownLoad && self.schoolListDidDownLoad){
            [self fetchData];
        }
    }
}


- (void)fetchData{
    UIView *oldTreeView = [self.view viewWithTag:2000];
    [oldTreeView removeFromSuperview];
    
    [_schoolMembersDataArray removeAllObjects];
    
    [self fetchDataFromDB];
    [self loadTreeView];
    
    self.schoolListDidDownLoad = NO;
    self.classListDidDownLoad = NO;
    self.membersDidDownLoad = NO;
}


- (void)fetchDataFromDB{
    NSMutableArray *schoolArray = [Database fetchAllSchool];
    for (int i=0; i<schoolArray.count; i++){
        RADataObject *schollData = [RADataObject dataObjectWithName:[schoolArray[i] corp_name]
                                                           children:nil];
        schollData.raDataObjectType = RADataObjectTypeSchool;
        schollData.objectID = [schoolArray[i] corp_id];
        NSMutableArray *classArray = [OMDateBase_MyClass fetchClassWithSchoolID:[schoolArray[i] corp_id]];
        if (classArray.count == 0){
            [_schoolMembersDataArray addObject:schollData];
            break;
        }
        NSMutableArray *classDataArray = [[NSMutableArray alloc]init];
        for (int j=0; j<classArray.count; j++){
            RADataObject *classData = [RADataObject dataObjectWithName:[classArray[j] groupNameOriginal]
                                                              children:nil];
            classData.objectID = [classArray[j] groupID];
            classData.raDataObjectType = RADataObjectTypeClass;
            
            NSMutableArray *memberArray = [Database fetchMembersWithClassID:[classArray[j] groupID]];
            NSMutableArray *memberDataArray = [[NSMutableArray alloc]init];
            for (int k=0; k<memberArray.count; k++) {
                RADataObject *memberData = [RADataObject dataObjectWithName:[memberArray[k] nickName]
                                                                   children:nil];
                memberData.raDataObjectType = RADataObjectMember;
                PersonModel *personModel = [[PersonModel alloc]init];
                personModel.upload_photo_timestamp = [memberArray[k] upload_photo_timestamp];
                personModel.uid = [memberArray[k] uid];
                personModel.nickName = [memberArray[k] nickName];
                personModel.user_type = [memberArray[k] user_type];
                personModel.alias = [memberArray[k] alias];
                memberData.person = personModel;
                [personModel release];
                [memberDataArray addObject:memberData];
            }
            classData.children = memberDataArray;
            [memberDataArray release];
            
            [classDataArray addObject:classData];
        }
        schollData.children = classDataArray;
        [classDataArray release];
        [_schoolMembersDataArray addObject:schollData];
    }
}



- (void)loadTreeView{
    if (!_treeView){
       _treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 108)];
        _treeView.delegate = self;
        _treeView.dataSource = self;
        [_treeView setEditing:NO animated:NO];
        _treeView.editing = NO;
    }
    
    [_treeView reloadData];

    if (_schoolMembersDataArray.count >0 && !_schoolMembersDataArray){
    }
    
    [_treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];

    [self.view addSubview:_treeView];
}

// ui加载
- (void)uiConfig{
    if (_schoolMembersDataArray.count == 0){
        [self loadAddContactsView];
    }else{

    }
}

- (void)loadAddContactsView{
    UIImageView *smileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    smileView.center = CGPointMake(self.view.bounds.size.width / 2, 100);
    smileView.image = [UIImage imageNamed:@"messages_icon_empty_status"];
    [self.view addSubview:smileView];
    [smileView release];
    
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 150, self.view.bounds.size.width - 30, 44)];
    promptLabel.text = NSLocalizedString(@"点击右上角     加入班级，找到更多小伙伴", nil);
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.61 alpha:1];
    promptLabel.userInteractionEnabled = YES;
    
    UIButton *btn_Add = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Add.frame = CGRectMake(0, 0, 18, 18);
    btn_Add.center = CGPointMake(98, promptLabel.bounds.size.height/2);
    [btn_Add setImage:[UIImage imageNamed:@"messages_icon_empty_status_plus"] forState:UIControlStateNormal];
    [btn_Add addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
    [promptLabel addSubview:btn_Add];
    
    [self.view addSubview:promptLabel];
    [promptLabel release];
}



- (void)btnAddClick:(UIButton *)btn{
    [_delegate performSelector:@selector(addContact)];
}



#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:expanded]) {
        return YES;
    }
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = [UIColor colorWithRed:0.99 green:1 blue:0.96 alpha:1];
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = [UIColor colorWithRed:0.99 green:1 blue:0.98 alpha:1];
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
}


-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo{
    [treeView deselectRowForItem:item animated:NO];
    expanded = item;
    ((RADataObject *)item).isOpen = !((RADataObject *)item).isOpen;
    if (((RADataObject *)item).raDataObjectType !=  RADataObjectMember){
        SchoolContractContentsCell *cell = (SchoolContractContentsCell *)[self treeView:treeView cellForItem:item treeNodeInfo:treeNodeInfo];
        [cell state];
    }else{
        [_delegate addBuddyFromSchoolWithPersonModel:((RADataObject *)item).person];
    }
    
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSInteger numberOfChildren = [treeNodeInfo.children count];
    if (((RADataObject *)item).raDataObjectType == RADataObjectMember){
        ContactListCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ContactListCell" owner:self options:nil] lastObject];
//        cell.lab_name.text = ((RADataObject *)item).name;
        if (numberOfChildren != 0){
            cell.imageView_head.alpha = 0;
        }
        if (treeNodeInfo.treeDepthLevel == 0) {
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        cell.person = ((RADataObject *)item).person;
        
        return cell;
    }else if (((RADataObject *)item).raDataObjectType == RADataObjectTypeClass){
        SchoolContractContentsCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"SchoolContractContentsCell" owner:self options:nil] firstObject];
        cell.lab_title.text = ((RADataObject *)item).name;
        [cell setLevel: treeNodeInfo.treeDepthLevel];
        cell.raDataObject = ((RADataObject *)item);
        cell.delegate = self;
        cell.isClass = YES;
        cell.isHideGroupBtn = self.isHideGroupBtn;
        if (treeNodeInfo.treeDepthLevel == 0) {
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }else{
        SchoolContractContentsCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"SchoolContractContentsCell" owner:self options:nil] firstObject];
        
        cell.lab_title.text = ((RADataObject *)item).name;
        [cell setLevel: treeNodeInfo.treeDepthLevel];
        cell.raDataObject = ((RADataObject *)item);
        cell.delegate = self;
        cell.isClass = NO;
//        cell.isHideGroupBtn = self.isHideGroupBtn;
        if (treeNodeInfo.treeDepthLevel == 0) {
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
}


- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [_schoolMembersDataArray count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [_schoolMembersDataArray objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}


#pragma mark - SchoolContractContentsCellDelegate

- (void)beginGroupChatWithRAObject:(RADataObject *)raDataObject{
    NSString *classID = [raDataObject objectID];
    NSString *className = [raDataObject name];
    NSMutableArray *classMembers = [[NSMutableArray alloc]init];
    NSArray *members = [raDataObject children];
    for (int i=0; i<members.count; i++){
        PersonModel *person = [members[i] person];
        Buddy *buddy = [[Buddy alloc]initWithUID:person.uid andPhoneNumber:nil andNickname:person.nickName andStatus:nil andDeviceNumber:nil andAppVer:nil andUserType:person.user_type andBuddyFlag:nil andIsBlocked:nil andSex:person.sex andPhotoUploadTimeStamp:nil andWowTalkID:nil andLastLongitude:nil andLastLatitude:nil andLastLoginTimestamp:nil withAddFriendRule:nil andAlias:nil];
        [classMembers addObject:buddy];
        [buddy release];
    }
    
    GroupChatRoom *grouproom = [[GroupChatRoom alloc]initWithID:classID withGroupNameOriginal:className withGroupNameLocal:className withGroupStatus:nil withMaxNumber:nil withMemberCount:[NSString stringWithFormat:@"%zi",classMembers.count] isTemporaryGroup:NO];
    [Database storeGroupChatRoom:grouproom];
    [grouproom release];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC createGroupChatRoom:classMembers withGroupID:classID];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];

}






@end
