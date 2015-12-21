//
//  FiveStarView.m
//  dev01
//
//  Created by Huan on 15/5/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "FiveStarView.h"
#import "TQStarRatingView.h"

@interface FiveStarView()<StarRatingViewDelegate>

@end


@implementation FiveStarView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 160, 5, 150, 30) numberOfStar:5];
        starRatingView.numberOfStar_set = 0;
        starRatingView.delegate = self;
        starRatingView.backgroundColor = [UIColor clearColor];
        [self addSubview:starRatingView];
    }
    return self;
}


-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
//    self.scoreLabel.text = [NSString stringWithFormat:@"%0.2f",score * 10 ];
    if ([_delegate respondsToSelector:@selector(fiveStarViewTag:andValue:)]) {
        [_delegate fiveStarViewTag:self.tag andValue:score];
    }
}


@end
