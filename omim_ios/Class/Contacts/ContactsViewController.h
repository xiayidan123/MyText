//
//  ContantsViewController.h
//  omim
//
//  Created by coca on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactListViewController.h"
#import "SchoolViewController.h"
#import "AddCourseController.h"

@interface ContactsViewController : UIViewController<SchoolViewControllerDelegate,AddCourseControllerDelegate>
{
    UIBarButtonItem *leftNavItem;

}

@property (nonatomic, retain) ContactListViewController *contactListVC;
@property (nonatomic, retain) SchoolViewController *schoolVC;
@property (nonatomic, retain) UISegmentedControl* mySeg;

@end
