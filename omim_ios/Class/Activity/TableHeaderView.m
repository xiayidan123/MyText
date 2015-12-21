//
//  TableHeaderView.m
//  dev01
//
//  Created by jianxd on 13-7-9.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "TableHeaderView.h"

NSString *const LastFreshTime = @"last_refresh_time";

#define INTERVAL_MINUTE         60
#define INTERVAL_HOUR           (60 * INTERVAL_MINUTE)
#define INTERVAL_DAY            (24 * INTERVAL_HOUR)

@interface TableHeaderView()

@end

@implementation TableHeaderView

@synthesize activityIndicator = _activityIndicator;
@synthesize infoLabel = _infoLabel;
@synthesize refreshTimeLabel = _refreshTimeLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [super awakeFromNib];
}

- (void)setHeaderViewState:(HeaderViewState)state
{
    if (state == HeaderViewStatePullBegin) {
        self.activityIndicator.hidden = YES;
        self.refreshTimeLabel.hidden = NO;
        self.infoLabel.text = NSLocalizedString(@"header pull to refresh", nil);
        NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:LastFreshTime];
        NSDate *nowDate = [NSDate date];
        NSTimeInterval interval = [nowDate timeIntervalSinceDate:lastDate];
        NSString *lastTimeString;
        if (!lastDate) {
            self.infoLabel.text = NSLocalizedString(@"header pull to refresh", nil);
            self.refreshTimeLabel.text = @"从未";
            return;
        }
        if (interval < INTERVAL_MINUTE) {
            lastTimeString = NSLocalizedString(@"header just now", nil);
        } else if (interval < INTERVAL_HOUR) {
            NSInteger minute = interval / INTERVAL_MINUTE;
            lastTimeString = [NSString stringWithFormat:@"%zi %@", minute, NSLocalizedString(@"header minute ago", nil)];
        } else if (interval < INTERVAL_DAY) {
            NSInteger hour = interval / INTERVAL_HOUR;
            lastTimeString = [NSString stringWithFormat:@"%zi %@", hour, NSLocalizedString(@"header hour ago", nil)];
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            lastTimeString = [formatter stringFromDate:lastDate];
            [formatter release];
        }
        self.refreshTimeLabel.text = [NSLocalizedString(@"header last refresh time", nil) stringByAppendingString:lastTimeString];
        CGRect infoRect = self.infoLabel.frame;
        infoRect.origin.y = 5;
        self.infoLabel.frame = infoRect;
        
        CGRect timeRect = self.refreshTimeLabel.frame;
        timeRect.origin.y = 25;
        self.refreshTimeLabel.frame = timeRect;
    } else if (state == HeaderViewStatePullDone) {
        self.activityIndicator.hidden = YES;
        self.refreshTimeLabel.hidden = NO;
        self.infoLabel.text = NSLocalizedString(@"header release to refresh", nil);
    } else if (state == HeaderViewStateRefreshing) {
        self.refreshTimeLabel.hidden = NO;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        self.infoLabel.text = NSLocalizedString(@"header refreshing", nil);
    }
}

- (void)updateRefreshTime
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LastFreshTime];
}

- (BOOL)needToRefreshAutomatically
{
    NSDate *nowDate = [NSDate date];
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:LastFreshTime];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:lastDate];
    if (interval > INTERVAL_HOUR) {
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc {
    [_activityIndicator release];
    [_infoLabel release];
    [_refreshTimeLabel release];
    [super dealloc];
}
@end
