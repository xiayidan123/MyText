//
//  BizMomentDetailViewController.h
//  wowtalkbiz
//
//  Created by elvis on 2013/10/09.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@class Moment;
@class Review;

@interface BizMomentDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>


@property (nonatomic,assign)BOOL isDeep;

@property (nonatomic,retain) HPGrowingTextView* inputTextView;

@property BOOL needToBecomeFirstResponser;

@property (nonatomic,retain) IBOutlet UITableView* tb_detail;

@property BOOL isMe;

@property (nonatomic,retain) Moment* moment;


-(void)tryToCommentMoment:(NSString *)momentid;

-(void) tryToCommentReview:(Review*)review InMoment:(NSString*)momentid;

-(void)likedTheMoment;
-(void)unlikedTheMoment;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
