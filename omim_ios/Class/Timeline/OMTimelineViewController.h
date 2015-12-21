//
//  OMTimelineViewController.h
//  wowtalkbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupList.h"
#import "PulldownMenuView.h"





//tag: grouplist: 1000 ; button: above 2000
@protocol MomentTypeViewDelegate;
@protocol VoiceMessagePlayerDelegate;
@protocol CoverViewDelegate;



typedef NS_ENUM(NSInteger, MomentOwnerType) {
    MomentOwnerTypePublicAccount  = 0,
    MomentOwnerTypeTeacher = 2,
    MomentOwnerTypeStudent = 1,
    MomentOwnerTypeALL = 99
    
};



typedef NS_ENUM(NSInteger, NewMomentType) {
    NewMomentTypeAll,
    NewMomentTypeNotification,
    NewMomentTypeQA,
    NewMomentTypeStudy,
    NewMomentTypeLife,
    NewMomentTypeSurvey,
    NewMomentTypeVideo
};


@interface OMTimelineViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,GroupListDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,PulldownMenuViewDelegate>


@property (assign) BOOL comeFromMySpace;

@property (nonatomic,retain) IBOutlet UITableView* tb_moments;
@property (nonatomic,retain) IBOutlet UIView* bg_header;
@property (retain,nonatomic) UIViewController* parent;
-(void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
