//
//  TableHeaderView.h
//  dev01
//
//  Created by jianxd on 13-7-9.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const LastFreshTime;

typedef enum {
    HeaderViewStatePullBegin,
    HeaderViewStatePullDone,
    HeaderViewStateRefreshing
} HeaderViewState;

@interface TableHeaderView : UIView

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (retain, nonatomic) IBOutlet UILabel *refreshTimeLabel;

- (void)setHeaderViewState:(HeaderViewState)state;
- (void)updateRefreshTime;
- (BOOL)needToRefreshAutomatically;

@end
