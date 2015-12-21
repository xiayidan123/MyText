//
//  MomentVoteView.h
//  dev01
//
//  Created by 杨彬 on 15/4/11.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MomentVoteView;


@protocol MomentVoteViewDelegate <NSObject>

- (void)MomentVoteView:(MomentVoteView *)voteView didVotedWithMoment_id:(NSString *)moment_id option_array:(NSArray *)option_array;

@end



@interface MomentVoteView : UIView

@property (assign, nonatomic)id<MomentVoteViewDelegate>delegate;

@property (retain, nonatomic)NSMutableArray *vote_option_array;

@property (assign, nonatomic)BOOL is_voted;

@property (assign, nonatomic)NSInteger voted_count;

@property (copy, nonatomic)NSString *moment_id;

@property (assign, nonatomic) BOOL isMultiple;

@property (assign, nonatomic) NSTimeInterval deadline;

@end
