//
//  MomentBottomModel.m
//  dev01
//
//  Created by 杨彬 on 15/4/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentBottomModel.h"

#import "Moment.h"
#import "MomentReviewCellModel.h"
#import "MomentReviewLikeModel.h"

#import "MomentCellDenfine.h"
#import "WTUserDefaults.h"
#import "YBAttrbutedLabel.h"

@interface MomentBottomModel ()

@property (assign, nonatomic)CGFloat like_review_height;
@property (assign, nonatomic)CGFloat text_review_height;

@end


@implementation MomentBottomModel

-(void)dealloc{
    self.moment = nil;
    
    self.review_array = nil;
    
    [super dealloc];
}


-(void)setMoment:(Moment *)moment{
    [_moment release],_moment = nil;
    _moment = [moment retain];
    if(_moment == nil){
        self.like_review_height = 0;
        self.text_review_height = 0;
        self.alreadyLike = NO;
        self.alreadyComment = NO;
        self.like_count = 0;
        self.comment_count = 0;
        self.review_array = nil;
        
        return;
    }
    
    
    int count = _moment.reviews.count;
    
    NSMutableArray *like_review_array = [[NSMutableArray alloc]init];
    NSString *name_string = @"";
    NSMutableArray *text_review_array = [[NSMutableArray alloc]init];
    self.like_review_height = 0;
    self.text_review_height = 0;
    self.alreadyLike = NO;
    self.alreadyComment = NO;
    self.like_count = 0;
    self.comment_count = 0;
    NSMutableArray *name_array = [[NSMutableArray alloc]init];
    
    for (int i=0; i<count; i++){
        Review *review = _moment.reviews[i];
        MomentReviewCellModel *momentReviewCellModel = [[MomentReviewCellModel alloc]init];
        
        momentReviewCellModel.review = review;
        
        if (review.type == REVIEW_TYPE_LIKE){
            [like_review_array addObject:momentReviewCellModel];
            
            if ([name_string isEqualToString:@""]){
                name_string = [NSString stringWithFormat:@"%@%@",name_string,review.nickName];
            }else{
                name_string = [NSString stringWithFormat:@"%@、%@",name_string,review.nickName];
            }
            
            YBAttrbutedModel *model = [[YBAttrbutedModel alloc]init];
            model.text = review.nickName;
            model.data = review.owerID;
            model.range = [name_string rangeOfString:review.nickName];
            [name_array addObject:model];
            [model release];
            
            if ([review.owerID isEqualToString:[WTUserDefaults getUid]]) {
                self.alreadyLike = YES;
            }
            self.like_count++;
            
        }else if (review.type == REVIEW_TYPE_TEXT){
            [text_review_array addObject:momentReviewCellModel];
            self.text_review_height += momentReviewCellModel.cellHeight;
            
            if ([review.owerID isEqualToString:[WTUserDefaults getUid]] ) {
                self.alreadyComment = YES;
            }
            self.comment_count ++;
        }
        [momentReviewCellModel release];
    }
    
    MomentReviewLikeModel *momentReviewLikeModel = [[MomentReviewLikeModel alloc]init];
    momentReviewLikeModel.like_review_string = name_string;
    momentReviewLikeModel.like_review_array = like_review_array;
    momentReviewLikeModel.name_array = name_array;
    [name_array release];
    self.like_review_height = momentReviewLikeModel.like_review_height;
    [like_review_array release];
    
    NSMutableArray *review_array = [[NSMutableArray alloc]init];
    [review_array addObject:momentReviewLikeModel];
    [review_array addObject:text_review_array];
    [momentReviewLikeModel release];
    [text_review_array release];
    
    
    self.reviewViewF = (CGRect) {{MomentBottom_borderW, MomentBottom_borderH},{OMScreenW , self.like_review_height + self.text_review_height}};
    
    self.review_array = review_array;
    [review_array release];
    
    
    CGFloat actionViewX = 0;
    CGFloat actionViewY = CGRectGetMaxY(self.reviewViewF) + MomentBottom_borderH;
    self.actionViewF = (CGRect){{actionViewX,actionViewY},{OMScreenW ,MomentBottom_ActionViewH}};
    
    self.content_height = CGRectGetMaxY(self.actionViewF) + MomentBottom_borderH;
}




@end
