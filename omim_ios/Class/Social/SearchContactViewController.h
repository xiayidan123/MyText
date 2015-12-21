//
//  SearchContactViewController.h
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSearchBar;

@class CustomNavButton;

@class  BizSearchBar;

#import "CustomIOS7AlertView.h"
#import "Communicator_SearchBuddy.h"

@interface SearchContactViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchBarDelegate,UIAlertViewDelegate,CustomIOS7AlertViewDelegate,UITextFieldDelegate,FuzzySearchDelegate>
{
    UISegmentedControl *segmentControl;
    
    UITableView *_tableView;
   
    BizSearchBar *_searchBar;
    
    UIImageView *imageViewFrame;
    UIImageView *imageViewPhoto;
    UILabel *nameLabel;
    UIButton *addButton;
    UILabel *addLabel;
    NSString *buddyid;
}

@property(nonatomic,retain) CustomNavButton *backButton;

@property (nonatomic,retain) UIView *idSearchView;

@property (nonatomic,retain) UITableView *tableView;

@property(nonatomic,retain) BizSearchBar *searchBar;

@property (nonatomic, copy) NSString *buddyid;

@property(assign)BOOL searchOfficialAccountMode;

@property (nonatomic, retain) UITableView *userTableView;



@end
