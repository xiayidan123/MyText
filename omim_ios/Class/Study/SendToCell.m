//
//  SendToCell.m
//  dev01
//
//  Created by Huan on 15/3/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SendToCell.h"
#import "BuddyDetailCell.h"
#import "Buddy.h"

@interface SendToCell()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SendToCell

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
    if ([self.dataArray[indexPath.row] isKindOfClass:[Buddy class]]) {
        cell.buddy = self.dataArray[indexPath.row];
    }else{
        cell.userGroup = self.dataArray[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray[indexPath.row] isKindOfClass:[Buddy class]]) {
        if ([_delegate respondsToSelector:@selector(getBuddyFromCell:)]) {
            [_delegate getBuddyFromCell:self.dataArray[indexPath.row]];
            
        }
    }
    else{
        if ([_delegate respondsToSelector:@selector(getGroupFromCell:)]) {
            [_delegate getGroupFromCell:self.dataArray[indexPath.row]];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
