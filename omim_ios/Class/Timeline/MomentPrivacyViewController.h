//
//  MomentPrivacyViewController.h
//  wowtalkbiz
//
//  Created by elvis on 2013/10/02.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  MomentPrivacyViewController;

@protocol MomentPrivacyViewControllerDelegate<NSObject>

@optional
-(void)didSetShareRange:(MomentPrivacyViewController*)requestor;

@end

@protocol GroupListDelegate;
@protocol GroupButtonDelegate;

@interface MomentPrivacyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) IBOutlet UITableView* tb_options;

@property (nonatomic,retain) IBOutlet UIScrollView* sv_bg;

@property (assign) id<MomentPrivacyViewControllerDelegate> delegate;

@property (nonatomic,retain) NSMutableArray* selectedDepartments;


@property BOOL isNotEditable;

@end
