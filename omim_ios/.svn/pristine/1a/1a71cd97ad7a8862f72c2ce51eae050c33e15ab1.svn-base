//
//  SendToRecently.m
//  dev01
//
//  Created by Huan on 15/3/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SendToRecently.h"
#import "BuddyDetailCell.h"
#import "ChatMessage.h"
#import "Database.h"
@interface SendToRecently ()<UITableViewDataSource, UITableViewDelegate,BuddyDetailCellDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation SendToRecently

- (void)awakeFromNib {
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyDetailCell *cell = [BuddyDetailCell cellWithTableView:tableView];
//    cell.buddy = [Database buddyWithUserID:((ChatMessage *)self.dataArray[indexPath.row]).chatUserName];
    cell.delegate = self;
    cell.chatMessage = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(getBuddyFromRecentCell:)]) {
        [_delegate getBuddyFromRecentCell:[Database buddyWithUserID:((ChatMessage *)self.dataArray[indexPath.row]).chatUserName]];
        [_delegate getChatMessageFromCell:self.dataArray[indexPath.row]];
    }
}
- (void)CallBackBuddys:(NSMutableArray *)buddys{
    if ([_delegate respondsToSelector:@selector(getBuddysFromCell:)]) {
        [_delegate getBuddysFromCell:buddys];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
- (void)dealloc {
    [_dataArray release];
    [_tableView release];
    [super dealloc];
}
@end
