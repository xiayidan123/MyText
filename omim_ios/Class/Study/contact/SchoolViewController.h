//
//  SchoolViewController.h
//  MG
//
//  Created by macbook air on 14-9-22.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
#import "SchoolContractContentsCell.h"
#import "RATreeNodeInfo.h"
#import "RATreeView.h"
@protocol SchoolViewControllerDelegate <NSObject>

- (void)addBuddyFromSchoolWithPersonModel:(PersonModel *)person;

@end
@interface SchoolViewController : UIViewController<SchoolContractContentsCellDelegate>

@property (nonatomic,retain)id<SchoolViewControllerDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *schoolMembersDataArray;
@property (nonatomic,assign) BOOL isHideGroupBtn;
- (void)loadData;
- (void)fetchDataFromDB;
-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
@end
