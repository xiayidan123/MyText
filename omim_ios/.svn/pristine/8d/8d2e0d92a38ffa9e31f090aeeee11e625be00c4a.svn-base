//
//  OMContactListViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMContactListViewController.h"

#import "Database.h"

#import "Buddy.h"
#import "UserGroup.h"

#import "OMContactFunctionCell.h"
#import "OMContactListCell.h"

#import "OMContactRequestListViewController.h"
#import "OfficialListViewController.h"
#import "OMBuddyDetailViewController.h"


@interface OMContactListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (retain, nonatomic) IBOutlet UITableView *contact_tableView;

/** buddy section数组 */
@property (retain, nonatomic) NSMutableArray * contact_array;

/** 索引数组 */
@property (retain, nonatomic) NSMutableArray * sectionIndex_array;

/** 有没有群组 */
@property (assign, nonatomic) BOOL hasGroup;

/** 搜索结果数组 */
@property (retain, nonatomic) NSMutableArray * result_array;;


@end

@implementation OMContactListViewController

- (void)dealloc {
    self.result_array = nil;
    self.contact_array = nil;
    self.sectionIndex_array = nil;
    [_contact_tableView release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[[UIView alloc]init] autorelease];
    self.contact_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.contact_tableView){
        if (indexPath.section == 0){
            OMContactFunctionCell *cell = [OMContactFunctionCell cellWithTableview:tableView];
            cell.info_dic = self.contact_array[indexPath.section][indexPath.row];
            return  cell;
        }else{
            OMContactListCell *cell = [OMContactListCell cellWithTableView:tableView];
            id object = self.contact_array[indexPath.section][indexPath.row];
            if ([object isKindOfClass:[Buddy class]]){
                cell.buddy = object;
            }else if ([object isKindOfClass:[UserGroup class]]){
                cell.group = object;
            }
            return cell;
        }
    }else{
        
        OMContactListCell *cell = [OMContactListCell cellWithTableView:tableView];
        id object = self.result_array[indexPath.row];
        if ([object isKindOfClass:[Buddy class]]){
            cell.buddy = object;
        }else if ([object isKindOfClass:[UserGroup class]]){
            cell.group = object;
        }
        return cell;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.contact_tableView){
        return [self.contact_array[section] count];
    }
    return self.result_array.count;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.contact_tableView){
        return self.contact_array.count;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || tableView != self.contact_tableView){
        return 0;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.contact_tableView){
        UIView *header_view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, OMScreenW, 20)] autorelease];
        header_view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 320, 20)] autorelease];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        [header_view addSubview:label];
        
        if (self.hasGroup && section == 1){
            label.text = @"Group";
        }else if (section != 0 && section != 1){
            Buddy *buddy = [self.contact_array[section] firstObject];
            label.text = buddy.section_name;
        }
        return header_view;
    }
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.contact_tableView){
        if (section != 0 && section != 1){
            Buddy *buddy = [self.contact_array[section] firstObject];
            return buddy.section_name;
        }
        return nil;
    }
    return nil;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.contact_tableView){
        return self.sectionIndex_array;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.contact_tableView){
        NSUInteger number = self.hasGroup ? 2 : 1 ;
        return [self.sectionIndex_array indexOfObject:title] + number;
    }
    return 0;
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.contact_tableView){
        
        if (indexPath.section == 0 && indexPath.row == 0){// 新朋友
            OMContactRequestListViewController *requestListVC = [[OMContactRequestListViewController alloc]initWithNibName:@"OMContactRequestListViewController" bundle:nil];
            [self.navigationController pushViewController:requestListVC animated:YES];
            [requestListVC release];
        }else if (indexPath.section == 0 && indexPath.row == 1){// 公众号
            OfficialListViewController *officialListVC = [[OfficialListViewController alloc]initWithNibName:@"OfficialListViewController" bundle:nil];
            [self.navigationController pushViewController:officialListVC animated:YES];
            [officialListVC release];
        }else{
            Buddy *buddy = self.contact_array[indexPath.section][indexPath.row];
            
            OMBuddyDetailViewController *buddyDetailVC = [[OMBuddyDetailViewController alloc]initWithNibName:@"OMBuddyDetailViewController" bundle:nil];
            buddyDetailVC.buddy = buddy;
            [self.navigationController pushViewController:buddyDetailVC animated:YES];
            [buddyDetailVC release];
        }
        
    }else{
        
    }
}


#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    
    [self filterContentForSearchText:searchText];
    
    
}


- (void)filterContentForSearchText:(NSString *)searchText
{
    if (self.result_array == nil) {
        self.result_array = [[[NSMutableArray alloc] init] autorelease];
    } else {
        [self.result_array removeAllObjects];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)", searchText];
    
    if (self.hasGroup) {
        for (UserGroup *group in self.contact_array[1]) {
            if ([predicate evaluateWithObject:group.groupNameLocal] || [predicate evaluateWithObject:group.shortid]) {
                [self.result_array addObject:group];
            }
        }
    }
    
    NSUInteger start_index = self.hasGroup ? 2 : 1 ;
    NSUInteger count = self.contact_array.count;
    for (NSInteger i = start_index; i < count; i++) {
        NSArray *temp = [self.contact_array objectAtIndex:i];
        for (Buddy *buddy in temp) {
            if ([predicate evaluateWithObject:buddy.nickName] || [predicate evaluateWithObject:buddy.wowtalkID]) {
                [self.result_array addObject:buddy];
            }
        }
    }
    NSLog(@"123");
    
}


#pragma mark - Set and Get

-(NSMutableArray *)contact_array{
    if (_contact_array == nil){
        
        NSMutableArray *allContacts = [Database getContactListWithoutOfficialAccounts];
        
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        // 根据语言 判断分组 和 分组个数
        // 索引数组
        NSMutableArray *sectionIndex_array = [[NSMutableArray alloc]initWithArray:collation.sectionTitles];
        
        NSInteger sectionTitlesCount = [[collation sectionTitles] count];
        
        // 创建分组数组 （用于存 各个section 数组）
        NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
        
        // 创建 sectionTItleCount 个子数组 用于将来存 子分组数据
        for (NSInteger index = 0; index < sectionTitlesCount; index++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [newSectionsArray addObject:array];
            [array release];
        }
        // 通过 buddy中的 nickName属性 排序
        for (Buddy *buddy in allContacts) {
            NSInteger sectionNumber = [collation sectionForObject:buddy collationStringSelector:@selector(nickName)];
            NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
            buddy.section_name = [collation sectionTitles][sectionNumber];
            [sectionNames addObject:buddy];
        }
        
        // 删除空数组 并且给每个分组数组里面的数据排序
        for (int index = 0; index < newSectionsArray.count; index++) {
            NSMutableArray *personArrayForSection = newSectionsArray[index];
            
            if (personArrayForSection.count == 0){
//                [newSectionsArray removeObject:personArrayForSection];
                [newSectionsArray removeObjectAtIndex:index];
                [sectionIndex_array removeObjectAtIndex:index];
                index --;
            }else{
                NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(nickName)];
                newSectionsArray[index] = sortedPersonArrayForSection;
            }
        }
        
        // 添加一个section （新朋友 公众账号）
        NSDictionary *newFriend_dic = @{@"title":NSLocalizedString(@"New friend", nil) ,@"image_name": @"new_friends.png"};
        NSDictionary *publicAccount_dic = @{@"title":NSLocalizedString(@"Public Account", nil) ,@"image_name": @"contact_official.png"};
        NSArray *first_section = @[newFriend_dic,publicAccount_dic];
        [newSectionsArray insertObject:first_section atIndex:0];
        
        // 添加群组数据
        NSMutableArray *group_array = [Database getAllFixedGroup];
        if(group_array.count > 0){
            self.hasGroup = YES;
            [newSectionsArray insertObject:group_array atIndex:1];
        }else{
            self.hasGroup = NO;
        }
        
        
        self.sectionIndex_array = sectionIndex_array;
        [sectionIndex_array release];
        _contact_array = newSectionsArray;
    }
    return _contact_array;
}




@end
