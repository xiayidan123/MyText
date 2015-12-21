//
//  OMTabBarVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMTabBarVC.h"

#import "OMNavigationController.h"


/**
 *  VC
 */
#import "MessagesVC.h"
#import "ContactsViewController.h"
#import "HomeViewController.h"
#import "TimelineContainerVC.h"
#import "NewHomeViewController.h"
#import "DiscoveryVC.h"
#import "MyClassViewController.h"
#import "OMMessageVC.h"
#import "BindingTelephoneViewController.h"

#import "GlobalSetting.h"
#import "WTUserDefaults.h"



@interface OMTabBarVC ()

@property (retain, nonatomic)UIView *customTabBar;

@property (retain, nonatomic)NSMutableArray *itemsArray;

@property (retain, nonatomic)NSLayoutConstraint *bottom;



@end

@implementation OMTabBarVC

-(void)dealloc{
    [_bottom release];
    [_itemsArray release];
    [_customTabBar release];
    
    /**
     *  VC
     */
    [_messageVC release];
    [_contactsVC release];
    [_homeVC release];
    [_timeLineVC release];
    [_omMessageVC release];
    [_myClassVC release];
    
    [_homeViewController release];
    
    [OMNotificationCenter removeObserver:self];
    
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [OMNotificationCenter addObserver:self selector:@selector(bindingPhoneNumber:) name:OM_NO_BINDING_MOBILE_PHONE object:nil];
    
    [self loadVC];

    self.selectedIndex = 2;
}


- (void)bindingPhoneNumber:(NSNotification *)notif{
    // 强制present绑定手机号码页面
    
    BindingTelephoneViewController *bindingTelephoneVC = [[BindingTelephoneViewController alloc]initWithNibName:@"BindingTelephoneViewController" bundle:nil];
    bindingTelephoneVC.LoginBingding = YES;
    OMNavigationController *navi = [[OMNavigationController alloc]initWithRootViewController:bindingTelephoneVC];
    [self presentViewController:navi animated:YES completion:nil];
    [navi release];
    [bindingTelephoneVC release];
    
}



- (void)loadVC{
    
    OMMessageVC *messageVC = [[OMMessageVC alloc] initWithNibName:@"OMMessageVC" bundle:nil];
    
    [self addChildVc:messageVC title:@"消息" image:@"tabbar_messages" selectedImage:@"tabbar_messages_press"];
    self.omMessageVC = messageVC;
    [messageVC release];
    
    
    ContactsViewController *contactsVC = [[ContactsViewController alloc] init];
    [self addChildVc:contactsVC title:@"小伙伴" image:@"tabbar_contacts" selectedImage:@"tabbar_contacts_press"];
    self.contactsVC = contactsVC;
    [contactsVC release];
    
    
    NewHomeViewController *homeVC = [[NewHomeViewController alloc] initWithNibName:@"NewHomeViewController" bundle:nil];
    [self addChildVc:homeVC title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_press"];
    self.homeViewController = homeVC;
    [homeVC release];
    
    
    MyClassViewController *myClassVC = [[MyClassViewController alloc]initWithNibName:@"MyClassViewController" bundle:nil];
    [self addChildVc:myClassVC title:@"我的教室" image:@"tabbar_myclass" selectedImage:@"tabbar_myclass_press"];
    self.myClassVC = myClassVC;
    [myClassVC release];
    

    DiscoveryVC *discovery = [[DiscoveryVC alloc] initWithNibName:@"DiscoveryVC" bundle:nil];
    [self addChildVc:discovery title:@"发现" image:@"tabbar_find" selectedImage:@"tabbar_find_press"];
    self.discoveryVC = discovery;
    [discovery release];
    
}


- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = OMMainUnSelectedColor;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = OMMainSelectedColor;
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    OMNavigationController *nav = [[OMNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
    [nav release];
}



- (void)jumpToOtherVCWithIndex:(NSInteger )index{
    self.selectedIndex = index;
}

- (void)badgeValue:(int)value withIndex:(int)index{
    UIViewController *vc = self.viewControllers[index];
    
    if (value <=0 ){
         vc.tabBarItem.badgeValue = nil;
    }else if (value > 99){
        vc.tabBarItem.badgeValue = @"99+";
    }else {
        vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",value];
    }
}

@end
