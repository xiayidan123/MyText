//
//  SearchGroupViewController.h
//  dev01
//
//  Created by elvis on 2013/07/01.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchGroupViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchBarDelegate,UIAlertViewDelegate,UISearchDisplayDelegate>



@property (nonatomic,retain) IBOutlet UITableView *tb_search;


@end
