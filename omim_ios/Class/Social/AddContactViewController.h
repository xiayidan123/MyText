//
//  AddContactViewController.h
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomNavButton.h"




@class CustomNavButton;
@class SearchContactViewController;

@interface AddContactViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    SearchContactViewController *_searchContactViewController;
}

@property(assign) BOOL enableGroupCreation;

@property(nonatomic,retain) UITableView *tableView;


@end
