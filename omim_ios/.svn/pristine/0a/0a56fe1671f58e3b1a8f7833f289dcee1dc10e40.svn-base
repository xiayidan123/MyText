//
//  SegmentBar.h
//  dev01
//
//  Created by 杨彬 on 14-10-14.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SegmentBarDelegate <NSObject>

- (void)moveContentWihtTagIndex:(NSInteger)tag;

@end


@interface SegmentBar : UIView


@property (nonatomic,assign)id<SegmentBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andTitleNameArray:(NSArray *)titleNameArray;

-(void)moveSlideBar:(CGFloat)distance;

@end
