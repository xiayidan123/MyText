//
//  OMBuddySpaceViewController.h
//  wowtalkbiz
//
//  Created by elvis on 2013/10/09.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "OMViewController.h"

@protocol MomentTypeViewDelegate;
@protocol VoiceMessagePlayerDelegate;
@protocol CoverViewDelegate;

@class OMBuddySpaceViewController;
@class MomentLocationCellModel;
@class MomentBottomModel;
@class Buddy;
@class Moment;


@protocol OMBuddySpaceViewControllerDelegate <NSObject>


- (void)OMBuddySpaceViewController:(OMBuddySpaceViewController *)buddySpaceVC readNewReview:(NSArray *)review_array;

- (void)OMBuddySpaceViewController:(OMBuddySpaceViewController *)buddySpaceVC didClickHeadImageViewWithBuddy:(Buddy *)owner_buddy;

- (void)OMBuddySpaceViewController:(OMBuddySpaceViewController *)buddySpaceVC didClickLocationModel:(MomentLocationCellModel *)locationModel;

- (void)OMBuddySpaceViewController:(OMBuddySpaceViewController *)buddySpaceVC clickReviewBuddy:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath withBuddy_id:(NSString *)buddy_id;

- (void)OMBuddySpaceViewController:(OMBuddySpaceViewController *)buddySpaceVC clickMoment:(Moment *)moment;


@end


@interface OMBuddySpaceViewController : OMViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (assign) BOOL comeFromMySpace;

@property (assign, nonatomic) id <OMBuddySpaceViewControllerDelegate>delegate;

@property (nonatomic,retain) IBOutlet UITableView* tb_moments;
@property (nonatomic,retain) IBOutlet UIView* bg_header;

@property (nonatomic,retain) NSString* buddyid;
@property (assign,nonatomic) UIViewController* parent;

-(void)viewBuddyDetail;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
-(void)changeCategoryWithIndex:(NSInteger)index;

@end
