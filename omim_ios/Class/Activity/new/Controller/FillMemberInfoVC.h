//
//  FillMemberInfoVC.h
//  dev01
//
//  Created by 杨彬 on 14-11-9.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailVC.h"
#import "ActivityModel.h"

@interface FillMemberInfoVC : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *tf_realName;
@property (retain, nonatomic) IBOutlet UITextField *tf_telephoneNumber;

@property (retain, nonatomic) IBOutlet UIButton *btn_enter;

@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) NSMutableDictionary *applyMemberInfo;

@property (nonatomic,retain) ActivityModel *model;

- (IBAction)enterClick:(id)sender;


@end
