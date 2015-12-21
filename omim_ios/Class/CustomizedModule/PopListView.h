//
//  PopListView.h
//  omim
//
//  Created by Harry on 14-1-17.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopListViewDelegate;

@interface PopListView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_options;
    NSInteger seletedRow;
}

@property (nonatomic, assign) id<PopListViewDelegate> delegate;

- (id)initWithOptions:(NSArray *)options;

- (void)showInView:(UIView *)view;
- (void)setSelectedIndex:(NSInteger)anIndex;

@end


@protocol PopListViewDelegate <NSObject>

- (void)popListView:(PopListView *)popListView didSelectedIndex:(NSInteger)anIndex;

- (void)popListViewDidCancel;

@end