//
//  CommentListVC.m
//  dev01
//
//  Created by Huan on 15/5/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  评语列表页

#import "CommentListVC.h"

@interface CommentListVC ()<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *commentArray;
@end

@implementation CommentListVC


- (void)dealloc {
    [_tableView release];
    self.commentArray = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}


- (void)uiConfig
{
    self.title = @"评语模板";
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}


#pragma mark - tableViewdataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"comment";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = self.commentArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(getCommentContent:)]) {
        [_delegate getCommentContent:self.commentArray[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma set and get

- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        NSArray *array = @[@"祝贺你每次都是五星！",@"喜欢你的认真劲儿！",@"我发现你的成绩又提高了！",@"这一次做的不错，再努力些就会更棒！",@"字迹美观，页面整洁",@"这么端正的作业，一定下了很大功夫！",@"作业挺多，你依然能写这么好，这就叫坚持！",@"认真写了吗？我喜欢你上次的作业！",@"你的朋友们快超过你啦，还不努力？！"];
        _commentArray = [[NSMutableArray alloc] initWithArray:array];
    }
    return _commentArray;
}

@end
