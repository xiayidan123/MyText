//
//  SearchOfficialAccountViewController.h
//  dev01
//
//  Created by elvis on 2013/07/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communicator_SearchBuddy.h"
#import "Communicator_SearchOfficialAccount.h"
#import <CoreLocation/CoreLocation.h>

@interface SearchOfficialAccountViewController : UIViewController<
UIActionSheetDelegate,
UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,
UIAlertViewDelegate,
UISearchDisplayDelegate,
UIAlertViewDelegate,
CLLocationManagerDelegate,
SearchDelegate>

@property (nonatomic,retain) IBOutlet UITableView *tb_search;
@property (retain, nonatomic) IBOutlet UILabel *indicatorLabel;


@end
