//
//  ChangeCoverViewController.h
//  suzhou
//
//  Created by xu xiao feng on 14-4-9.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeCoverViewControllerDelegate <NSObject>

- (void)changeCover;


@end

@interface ChangeCoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) id<ChangeCoverViewControllerDelegate>delegate;

@end
