//
//  MomentReviewActionView.m
//  dev01
//
//  Created by 杨彬 on 15/4/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentReviewActionView.h"

#import "MomentBottomModel.h"
#import "Review.h"
#import "Moment.h"

#import "WowTalkWebServerIF.h"
#import "Database.h"
#import "WTHeader.h"
#import "OMInputManager.h"
#import "NSString+Compare.h"




@interface MomentReviewActionView ()<OMInputManagerDelegate>

@property (retain, nonatomic)IBOutlet UIButton *more_button;

@property (retain, nonatomic)IBOutlet UIButton *like_button;

@property (retain, nonatomic)IBOutlet UIButton *comment_button;


@end


@implementation MomentReviewActionView

-(void)dealloc{
    self.more_button = nil;
    self.like_button = nil;
    self.comment_button = nil;
    
    self.bottom_model = nil;
    
    [super dealloc];
}

+ (instancetype)momentReviewActionView{
    return [[[NSBundle mainBundle]loadNibNamed:@"MomentReviewActionView" owner:nil options:nil] lastObject];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
//    line.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1];
//    [self addSubview:line];
//    [line release];
    
}

-(void)setBottom_model:(MomentBottomModel *)bottom_model{
    [_bottom_model release],_bottom_model = nil;
    _bottom_model = [bottom_model retain];
    if (_bottom_model == nil)return;
    
    self.like_button.selected = _bottom_model.alreadyLike;
    self.comment_button.selected = _bottom_model.alreadyComment;
    
    if (_bottom_model.comment_count != 0){
        [self.comment_button setTitle:[NSString stringWithFormat:@" %ld",(long)_bottom_model.comment_count] forState:UIControlStateNormal];
    }else{
        [self.comment_button setTitle:@"评论" forState:UIControlStateNormal];
    }
    
    if (_bottom_model.like_count != 0){
        [self.like_button setTitle:[NSString stringWithFormat:@" %ld",(long)_bottom_model.like_count] forState:UIControlStateNormal];
    }else{
        [self.like_button setTitle:@"赞" forState:UIControlStateNormal];
    }
}


- (IBAction)like:(id)sender {
    if (self.bottom_model.alreadyLike) {
        Review* review = [Database getMyLikedReviewForMoment:self.bottom_model.moment.moment_id];
        [WowTalkWebServerIF deleteMomentReview:self.bottom_model.moment.moment_id reviewid:review.review_id withCallback:@selector(didClickLikeButtomAndCallBackFromServer:) withObserver:self ];
    }
    else{
        [WowTalkWebServerIF reviewMoment:self.bottom_model.moment.moment_id withType:[NSString stringWithFormat:@"%d",REVIEW_TYPE_LIKE] content:@"" withCallback:@selector(didClickLikeButtomAndCallBackFromServer:) withObserver:self];
    }
}


- (IBAction)comment:(id)sender {
    OMInputManager *inputManager = [OMInputManager sharedManager];
    inputManager.delegate = self;
    [inputManager setClick_view:self.comment_button];
}

- (IBAction)more:(id)sender {
    
    
}


#pragma  mark - OMInputManagerDelegate

- (void)beginShowKeyboardWithDistance:(CGFloat )distance{
    if ([self.delegate respondsToSelector:@selector(MomentReviewActionView:didClickCommentButton:withDistance:)]){
        [self.delegate MomentReviewActionView:self didClickCommentButton:self.bottom_model withDistance:distance];
    }
}


- (void)didClickReturnWithText:(NSString *)text{
    if ([NSString isEmptyString:text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Input is empty", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    } else if (text.length > 260) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"comment max length 260", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    [WowTalkWebServerIF reviewMoment:self.bottom_model.moment.moment_id withType:[NSString stringWithFormat:@"%d", REVIEW_TYPE_TEXT] content:text withCallback:@selector(didAddComment:) withObserver:self];
}

- (void)didEndHideKeyBoard{
    if ([self.delegate respondsToSelector:@selector(MomentReviewActionView:didEndEdit:)]){
        [self.delegate MomentReviewActionView:self didEndEdit:self.bottom_model];
    }
}


#pragma mark - NetWork CallBack

-(void)didClickLikeButtomAndCallBackFromServer:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if ([self.delegate respondsToSelector:@selector(MomentReviewActionView:didClickLikeButton:)]){
            [self.delegate MomentReviewActionView:self didClickLikeButton:self.bottom_model];
        }
    }
}

-(void)didAddComment:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if ([self.delegate respondsToSelector:@selector(MomentReviewActionView:didClickLikeButton:)]){
            [self.delegate MomentReviewActionView:self didClickLikeButton:self.bottom_model];
        }
    }
}





@end
