//
//  TabBarViewController.h
//  omim
//
//  Created by Harry on 14-1-10.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//


// 已放弃使用

#import <UIKit/UIKit.h>

typedef enum
{
    TAB_MESSAGE=0,
    TAB_CONTACT,
    TAB_HOME,
    TAB_TIMELINE,
    TAB_SETTING
} TAB_INDEX;

@class TabBarViewController;

@interface CustomTabBar : UIView
{
    UIButton *btnMessage;
    UIButton *btnContact;
    UIButton *btnTimeline;
    UIButton *btnHome;
    UIButton *btnSetting;
    
    UILabel *lblMessage;
    UILabel *lblContact;
    UILabel *lblTimeline;
    UILabel *lblSetting;
    
    TAB_INDEX selectedTab;
    
    TabBarViewController *controller;
    
}

@property (nonatomic, retain) TabBarViewController *controller;

@property (nonatomic,retain) UIImageView* unread_bg;
@property (nonatomic,retain) UILabel* unread_count_label;

@property (nonatomic,retain) UIImageView* unread_review_bg;
@property (nonatomic,retain) UILabel* unread_review_count_label;

@property (nonatomic,retain) UIImageView* unread_request_bg;
@property (nonatomic,retain) UILabel* unread_request_count_label;

@property (nonatomic,retain) UIImageView* unread_moment_notice;


@property (nonatomic, retain) UIImageView *unreadSettingBg;
@property (nonatomic, retain) UILabel *unreadSettingLabel;

@property (nonatomic,retain) UIColor* seleted_color;

- (void)selectTab:(UIButton *)newSelectedTab;

@end

@interface TabBarViewController : UITabBarController
{
    CustomTabBar *customTabBar;
}


- (void)hideTabbar;
- (void)showTabbar;
-(void)refreshCustomBarUnreadNum;
-(void)selectTabAtIndex:(int)index;
-(UIColor*)getSelectedTabColor;

@end
