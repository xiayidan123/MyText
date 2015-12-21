//
//  EventsListVC.m
//  dev01
//
//  Created by 杨彬 on 14-10-20.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "EventsListVC.h"
#import "PublicFunctions.h"
#import "PulldownMenuView.h"

@interface EventsListVC ()
{
    PulldownMenuView *_pilldownView;
}

@end

@implementation EventsListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self configNavigation];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++){
        Tag *tag = [[Tag alloc]init];
        tag.tagTitle =@[@"主办方",@"类型",@"时间"][i];
        tag.contentArray = @[@[@"主办方1",@"主办方2",@"主办方3"],@[@"类型1",@"类型2",@"类型3",@"类型4"],@[@"时间1",@"时间2",@"时间3",@"时间4"]][i];
        [array addObject:tag];
        [tag release];
    }
    _pilldownView = [[[NSBundle mainBundle] loadNibNamed:@"PulldownMenuView" owner:self options:nil] firstObject];
    [_pilldownView loadPulldownViewWithFram:CGRectMake(0, 64, 320, 44) andCTagArry:array];
    [array release];
    
    [self.view addSubview:_pilldownView];
    
}

- (void)configNavigation{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"乐趣活动",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
    [backBarItem release];
    
    UIBarButtonItem* barButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:@"evetns_loupe_white 2"] selector:@selector(btnSearch)];
    [self.navigationItem addRightBarButtonItem:barButton];
    [barButton release];
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnSearch{
    NSLog(@"搜寻按钮实现方法接口EventsListVC ---->btnSearch");
}


- (void)dealloc {
//    [_pilldownView release];
    [super dealloc];
}
@end
