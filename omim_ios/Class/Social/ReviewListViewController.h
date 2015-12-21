//
//  ReviewListViewController.h
//  omim
//
//  Created by elvis on 2013/05/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewListViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property BOOL newReviewOnly;

@property (nonatomic,retain) IBOutlet UITableView* tb_reviews;

@end
