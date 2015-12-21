//
//  MomentReviewCellModel.m
//  dev01
//
//  Created by 杨彬 on 15/4/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentReviewCellModel.h"


#import "MomentCellDenfine.h"


@interface MomentReviewCellModel ()




@end

@implementation MomentReviewCellModel


-(void)dealloc{
    self.review = nil;
    
    [super dealloc];
}



-(void)setReview:(Review *)review{
    [_review release],_review = nil;
    _review = [review retain];
    if (_review == nil || _review.type == REVIEW_TYPE_LIKE){
        self.cellHeight = 0;
        return;
    }
    
    NSString *text_string;
    if ([_review.replyToReviewId isEqualToString:@"0"]){// 对moment 评论
        text_string = [NSString stringWithFormat:@"%@: %@",_review.nickName,_review.text];
        
    }else{// 对评论评论
        text_string = [NSString stringWithFormat:@"%@回复%@: %@",_review.nickName,_review.replyToNickname,_review.text];
    }
    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    CGSize maxSize = CGSizeMake(review_textLabel_width, MAXFLOAT);
    
    CGSize text_size = [text_string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    if (text_size.height < 13){
        self.cellHeight = review_likeCell_minHeight;
    }else{
        self.cellHeight = text_size.height + 10;
    }
    
    
}


@end
