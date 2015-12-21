//
//  ContactListViewController.h
//  wowcity
//
//  Created by jianxd on 14-11-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopListView.h"
#import "RequestListViewController.h"

@interface ContactListViewController : UIViewController <
PopListViewDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate>
@property (retain, nonatomic) IBOutlet UITableView *contactTableView;
@property (retain, nonatomic) NSMutableArray *accountSectionArray;
@property (retain,nonatomic) UIViewController* parent;

@end
