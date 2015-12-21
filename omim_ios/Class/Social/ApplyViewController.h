//
//  ApplyViewController.h
//  omim
//
//  Created by coca on 2013/05/01.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,retain) NSString* buddyid;
@property (nonatomic,retain) NSString* groupid;
@property (nonatomic,retain) NSString* helloword;
@property (nonatomic,retain) NSString* name;

@property BOOL isApplyForGroup;
@property BOOL isApplyForAddFriend;
@property BOOL isGroupInvitation;


@property (nonatomic,retain) IBOutlet UITableView* tb_apply;

@property (nonatomic,assign) id delegate;

@end
