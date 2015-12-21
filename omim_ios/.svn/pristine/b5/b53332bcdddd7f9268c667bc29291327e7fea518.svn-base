//
//  ChangeGroupNameViewController.h
//  omim
//
//  Created by elvis on 2013/05/28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChangeGroupNameViewController;
@protocol ChangeGroupNameDelegate <NSObject>

@optional
-(void)didChangeGroupNameTo:(NSString*)name withRequestor:(ChangeGroupNameViewController*)requestor;

@end

@interface ChangeGroupNameViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (assign) id<ChangeGroupNameDelegate> delegate;

@property (nonatomic,retain) NSString* oldGroupName;
@property (nonatomic,retain) IBOutlet UITableView* tb_change;

@end
