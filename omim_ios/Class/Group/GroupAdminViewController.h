//
//  GroupAdminViewController.h
//  omim
//
//  Created by coca on 2013/05/01.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupAdminViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) IBOutlet UITableView* tb_members;
@property BOOL isCreator;
@property BOOL isManager;

@property (nonatomic,retain) NSArray* arr_requests;
@property (nonatomic,retain) NSMutableArray* arr_members;
@property (nonatomic,retain) NSString* groupid;

@end
