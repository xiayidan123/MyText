//
//  OMPulldownMenuView.m
//  OMPulldownView
//
//  Created by Starmoon on 15/7/15.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "OMPulldownMenuView.h"
#import "UIView+Extension.h"

#import "OMPulldownItemCell.h"

#define OMPulldownScreenW ([UIScreen mainScreen].bounds.size.height)

@interface OMPulldownMenuView ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) UITableView * item_tableView;


@property (weak, nonatomic) UIView * tableView_bgView;



@end


@implementation OMPulldownMenuView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.item_tableView.width = self.width;
    self.item_tableView.height = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView_bgView.frame = self.bounds;
    }];
    
}

#pragma mark - UITableViewDataSource


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    OMPulldownItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMPulldownItemCell"];
    
    OMPulldownSubItem *subItem = self.items[indexPath.row];
    
    cell.subItem = subItem;
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.item_height;
}

#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (OMPulldownSubItem *subItem in self.items) {
        subItem.seleted = NO;
    }
    OMPulldownSubItem *subItem = self.items[indexPath.row];
    subItem.seleted = YES;
    if ([self.delegate respondsToSelector:@selector(menuView:didSeletedItemtIndexPath:)]){
        [self.delegate menuView:self didSeletedItemtIndexPath:indexPath];
    }
}


#pragma mark - Set and Get

-(void)setItems:(NSMutableArray *)items{
    _items = items;
    
    
    CGFloat unfold_height = _items.count * self.item_height;
    
    CGRect rect = [self convertRect:self.bounds toView:nil];
    
    if (unfold_height > OMPulldownScreenW - rect.origin.y){
        self.unfold_height = OMPulldownScreenW - rect.origin.y;
    }else{
        self.unfold_height = unfold_height;
    }
    
    [self.item_tableView reloadData];
}


-(CGFloat)item_height{
    if (_item_height == 0){
        _item_height = 40;
    }
    return _item_height;
}


-(UITableView *)item_tableView{
    if (_item_tableView == nil){
        UITableView *item_tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        [item_tableView registerNib:[UINib nibWithNibName:@"OMPulldownItemCell" bundle:nil] forCellReuseIdentifier:@"OMPulldownItemCell"];
        
        item_tableView.dataSource = self;
        item_tableView.delegate = self;
        item_tableView.x = 0;
        item_tableView.y = 0;
        
        [self.tableView_bgView addSubview:item_tableView];
        _item_tableView = item_tableView;
        _item_tableView.scrollEnabled = NO;
    }
    return _item_tableView;
}


-(UIView *)tableView_bgView{
    if (_tableView_bgView == nil){
        UIView *tableView_bgView = [[UIView alloc]init];
        [self addSubview:tableView_bgView];
        tableView_bgView.clipsToBounds = YES;
        _tableView_bgView = tableView_bgView;
    }
    return _tableView_bgView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
