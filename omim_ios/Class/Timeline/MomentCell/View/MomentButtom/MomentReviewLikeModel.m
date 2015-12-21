//
//  MomentReviewLikeModel.m
//  dev01
//
//  Created by 杨彬 on 15/4/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentReviewLikeModel.h"

#import "MomentCellDenfine.h"

@implementation MomentReviewLikeModel

-(void)dealloc{
    self.like_review_array = nil;
    self.like_review_string = nil;
    self.name_array = nil;
    [super dealloc];
}


-(void)setLike_review_string:(NSString *)like_review_string{
    [_like_review_string release],_like_review_string = nil;
    if (like_review_string.length == 0){
        self.like_review_height = 0;
        return;
    }
    _like_review_string = [like_review_string copy];
    
    
    
    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    CGSize maxSize = CGSizeMake(review_likeLabel_width, MAXFLOAT);
    
    CGSize text_size = [_like_review_string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    if (_like_review_string.length == 0){
        self.like_review_height = 0;
    }else if (text_size.height < 12){
        self.like_review_height = review_likeCell_minHeight;
    }else{
        self.like_review_height = text_size.height + 12;
    }
}

@end
