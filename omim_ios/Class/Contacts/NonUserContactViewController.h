//
//  NonUserContactViewController.h
//  omim
//
//  Created by coca on 2013/04/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook.h"
@class  Buddy;
@interface NonUserContactViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic,retain) ABPerson* person;
@property (nonatomic,retain) Buddy* buddy;

@property (nonatomic,retain) IBOutlet UITableView* tb_person;


@end
