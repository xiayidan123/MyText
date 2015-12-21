//
//  PulldownView.h
//  111
//
//  Created by 杨彬 on 14-10-5.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PulldownView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *bgView;

@property (retain, nonatomic) IBOutlet UIButton *btn_share;


@property (retain, nonatomic) IBOutlet UIButton *btn_classify;

@property (nonatomic,copy) void(^CB)(NSArray *);


- (IBAction)shareClick:(id)sender;
- (IBAction)classifyClick:(id)sender;

- (void)pulldownViewPackup;

@end
