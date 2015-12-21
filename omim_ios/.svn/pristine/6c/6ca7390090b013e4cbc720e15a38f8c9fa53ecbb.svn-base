//
//  RefreshTableHeaderView.m
//  dev01
//
//  Created by jianxd on 14-3-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "RefreshTableHeaderView.h"
@interface RefreshTableHeaderView()
@property (nonatomic, retain) UILabel *lastUpdateLabel;
@property (nonatomic, retain) UILabel *stateLabel;
@property (nonatomic, assign) PullRefreshState state;
@end

@implementation RefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)refreshLastUpdateDate
{
    if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceLastUpdated:)]) {
        NSDate *date = [_delegate refreshTableHeaderDataSourceLastUpdated:self];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setAMSymbol:@"AM"];
        [formatter setPMSymbol:@"PM"];
        [formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
        _lastUpdateLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateLabel forKey:@"RefreshTableHeaderView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [formatter release];
    } else {
        _lastUpdateLabel.text = nil;
    }
}

- (void)setState:(PullRefreshState)aState
{
    switch (aState) {
        case PullRefreshPulling:
            _stateLabel.text = NSLocalizedString(@"Release to refresh...", nil);
            break;
        case PullRefreshLoading:
            _stateLabel.text = NSLocalizedString(@"Loading...", nil);
            break;
        case PullRefreshNormal:
            if (_state == PullRefreshPulling) {
                
            }
            break;
        default:
            break;
    }
    _state = aState;
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == PullRefreshLoading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
    } else if (scrollView.isDragging) {
        BOOL loading = NO;
        if (_state == PullRefreshPulling && scrollView.contentOffset.y > 65.0f && scrollView.contentOffset.y < 0.0f && !loading) {
            [self setState:PullRefreshNormal];
        } else if (_state == PullRefreshNormal && scrollView.contentOffset.y < -65.0f && !loading) {
            [self setState:PullRefreshPulling];
        }
        
        if (scrollView.contentInset.top != 0.0f) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL loading = NO;
    if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
        loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y <= -65.0f && !loading) {
        if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate refreshTableHeaderDidTriggerRefresh:self];
        }
        
        [self setState:PullRefreshLoading];
    }
}

- (void)refreshScrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView
{
    [self setState:PullRefreshNormal];
}

- (void)dealloc
{
    [_lastUpdateLabel release];
    [_stateLabel release];
    [super dealloc];
}
@end
