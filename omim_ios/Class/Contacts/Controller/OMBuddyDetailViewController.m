//
//  OMBuddyDetailViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/29.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBuddyDetailViewController.h"

#import "OMDatabase_moment.h"

#import "OMBuddyDetailHeadView.h"
#import "OMBuddyDetailActionFootView.h"

#import "Buddy.h"
#import "OMBuddyDetailItem.h"

#import "OMBuddyDetailCell.h"
#import "OMBuddyDetailPhotosCell.h"

@interface OMBuddyDetailViewController ()<UITableViewDataSource,UITableViewDelegate,OMBuddyDetailActionFootViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *detail_tableView;

@property (retain, nonatomic) NSMutableArray *items;

@end

@implementation OMBuddyDetailViewController

- (void)dealloc {
    [_detail_tableView release];
    self.buddy = nil;
    self.items = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细资料";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_share_list_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)] autorelease];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
    self.detail_tableView.backgroundColor = [UIColor clearColor];
    
    OMBuddyDetailHeadView *buddyDetailHeadView = [OMBuddyDetailHeadView buddyDetailHeadView];
    buddyDetailHeadView.width = self.detail_tableView.width;
    buddyDetailHeadView.buddy = self.buddy;
    self.detail_tableView.tableHeaderView = buddyDetailHeadView;
    
    OMBuddyDetailActionFootView *footView = [OMBuddyDetailActionFootView buddyDetailActionFootView];
    footView.width = self.detail_tableView.width;
    footView.delegate = self;
    self.detail_tableView.tableFooterView = footView;
}
- (void)moreAction{
    
    
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OMBuddyDetailItem *item = self.items[indexPath.row];
    
    if (indexPath.row == 2){// 动态cell
        OMBuddyDetailPhotosCell *cell = [OMBuddyDetailPhotosCell cellWithTableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.item = item;
        return cell;
    }
    
    OMBuddyDetailCell *cell = [OMBuddyDetailCell cellWithTableView:tableView];
    cell.item = item;
    
    switch (indexPath.row) {
        case 0:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }break;
        case 1:{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }break;
        default:
            break;
    }
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OMBuddyDetailItem *item = self.items[indexPath.row];
    return item.cell_height;
}




#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - OMBuddyDetailActionFootViewDelegate

-(void)didClickSendMessageButtonWithFootView:(OMBuddyDetailActionFootView *)foot_view{
    NSLog(@"%s",__FUNCTION__);
}

-(void)didClickVoiceButtonWithFootView:(OMBuddyDetailActionFootView *)foot_view{
    NSLog(@"%s",__FUNCTION__);
}


-(void)didClickVideoButtonWithFootView:(OMBuddyDetailActionFootView *)foot_view{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - Set and Get

-(NSMutableArray *)items{
    if (_items == nil){
        _items = [[NSMutableArray alloc]init];
        
        OMBuddyDetailItem *item_mark = [[OMBuddyDetailItem alloc]init];
        item_mark.title = @"标签";
        item_mark.content = @"";
        [_items addObject:item_mark];
        [item_mark release];
        
        OMBuddyDetailItem *item_intro = [[OMBuddyDetailItem alloc]init];
        item_intro.title = @"个性签名";
        item_intro.content = self.buddy.status;
        [_items addObject:item_intro];
        [item_intro release];
        
        OMBuddyDetailItem *item_moment = [[OMBuddyDetailItem alloc]init];
        item_moment.title = @"动态";
        item_moment.content = @"";
        item_moment.moment_media_array = [OMDatabase_moment getLastMomentPhotosWithBuddy_id:self.buddy.userID];
        item_moment.cell_height = 70;
        [_items addObject:item_moment];
        [item_moment release];
    }
    return _items;
}





@end
