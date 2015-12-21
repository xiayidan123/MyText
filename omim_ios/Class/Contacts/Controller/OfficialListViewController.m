//
//  OfficialListViewController.m
//  dev01
//
//  Created by jianxd on 14-12-6.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "OfficialListViewController.h"

#import "OfficialAccountViewController.h"
#import "SearchOfficialAccountViewController.h"
#import "Database.h"
#import "PublicFunctions.h"
#import "Constants.h"

#import "OMOfficialListCell.h"

@interface OfficialListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray *officialAccounts;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OfficialListViewController

- (void)dealloc {
    [_tableView release];
    self.officialAccounts = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configNavigationBar];
    self.tableView.tableFooterView = [[[UIView alloc]init] autorelease];
    
}


- (void)configNavigationBar
{
    self.title = NSLocalizedString(@"Public Account", nil);
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:NAV_ADD_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(addOfficial)] autorelease];
}

- (void)addOfficial
{
    SearchOfficialAccountViewController *searchViewController = [[SearchOfficialAccountViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
    [searchViewController release];
}



#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMOfficialListCell *cell = [OMOfficialListCell cellWithTableView:tableView];
    cell.buddy = self.officialAccounts[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.officialAccounts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OfficialAccountViewController *officialViewController = [[OfficialAccountViewController alloc] init];
    officialViewController.account = [self.officialAccounts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:officialViewController animated:YES];
    [officialViewController release];
}


#pragma mark - Set and Get

-(NSMutableArray *)officialAccounts{
    if (_officialAccounts == nil){
        _officialAccounts = [[Database fetchOfficialAccount] retain];
    }
    return _officialAccounts;
}



@end
