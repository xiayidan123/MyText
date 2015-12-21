//
//  SystemMessageViewController.h
//  omim
//
//  Created by elvis on 2013/05/23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatMessage;

@interface SystemMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) IBOutlet UITableView* tb_content;


-(void)fProcessNewIncomeMsg:(ChatMessage*)msg;
@end
