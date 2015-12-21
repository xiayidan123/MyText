//
//  PulldownMenuView.h
//  dev01
//
//  Created by 杨彬 on 14-10-20.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface Tag : NSObject
@property (nonatomic,copy)NSString *tagTitle;
@property (nonatomic,retain)NSArray *contentArray;
@end


@protocol PulldownMenuViewDelegate <NSObject>

- (void)didSelecteWithState:(NSArray *)stateArray;


@end



@interface PulldownMenuView : UIView<UITableViewDelegate,UITableViewDataSource>

// 用xib实例化
// [[[NSBundle mainBundle] loadNibNamed:@"PulldownMenuView" owner:self options:nil] firstObject];

@property (nonatomic,assign) id <PulldownMenuViewDelegate> delegate;


- (void)loadPulldownViewWithFram:(CGRect)frame andCTagArry:(NSArray *)tagArray;


- (void)action;
- (void)hideBranchMenu;
- (void)fastHideBranchMenu;
- (void)showBranchMenu;

@end
