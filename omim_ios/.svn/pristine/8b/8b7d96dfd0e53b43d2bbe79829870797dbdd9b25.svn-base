//
//  GroupAdminVC.h
//  dev01
//
//  Created by 杨彬 on 15/2/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GroupAdminVCDelegate <NSObject>

- (void)didChangeManage;

@end


@interface GroupAdminVC : UIViewController

@property BOOL isCreator;
@property BOOL isManager;

@property (nonatomic,retain) NSMutableArray* arr_members;
@property (nonatomic,retain) NSString* groupid;
@property (nonatomic,assign) id <GroupAdminVCDelegate>delegate;




@end
