//
//  RefreshTableHeaderView.h
//  dev01
//
//  Created by jianxd on 14-3-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshTableHeaderViewDelegate;

typedef NS_ENUM(NSInteger, PullRefreshState) {
    PullRefreshPulling = 0,
    PullRefreshNormal,
    PullRefreshLoading
};

@interface RefreshTableHeaderView : UIView

@property (nonatomic, assign) id<RefreshTableHeaderViewDelegate> delegate;

- (void)refreshLastUpdateDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView;

@end

@protocol RefreshTableHeaderViewDelegate <NSObject>

- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView *)headerView;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView *)headerView;
@optional
- (NSDate *)refreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView *)headerView;

@end
