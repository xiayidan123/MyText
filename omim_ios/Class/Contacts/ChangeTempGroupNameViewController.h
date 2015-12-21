//
//  ChangeTempGroupNameViewController.h
//  omimbiz
//
//  Created by elvis on 2013/07/19.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupChatRoom;

@interface ChangeTempGroupNameViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,retain) GroupChatRoom* chatroom;

@property (nonatomic,retain) IBOutlet UITableView* tb_change;


@end
