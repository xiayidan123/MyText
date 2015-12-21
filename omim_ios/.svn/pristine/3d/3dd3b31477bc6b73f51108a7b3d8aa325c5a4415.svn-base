//
//  HomeworkReviewModel.h
//  dev01
//
//  Created by 杨彬 on 15/5/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeworkReviewRankModel.h"

#define Homework_Review_gap_to_bottom 20

#define Homework_Review_Bubble_top 5

#define Homework_Review_rankCell_width 225

#define Homework_Review_rankCell_height 30

#define Homework_Review_content_label_top 5

#define Homewirk_Review_margins 5

#define Homework_Review_bubble_bgView_bottom 5


#define Homework_Review_content_text_font 14



@interface HomeworkReviewModel : NSObject


@property (copy, nonatomic) NSString * review_id;

@property (copy, nonatomic) NSString * result_id;

@property (copy, nonatomic) NSString * text;

@property (copy, nonatomic) NSString * student_id;

@property (copy, nonatomic) NSString * homework_id;

@property (copy, nonatomic) NSString * moment_id;

@property (copy, nonatomic) NSString * teacher_id;

@property (assign, nonatomic) NSTimeInterval last_timeInterval;

@property (retain, nonatomic) NSMutableArray * rank_array;

@property (assign, nonatomic) BOOL isFromMySelf;



@property (assign, nonatomic) CGFloat cell_height;

@property (assign, nonatomic) CGFloat time_label_height;

@property (assign, nonatomic) CGFloat text_label_width;

@property (assign, nonatomic) CGFloat text_label_height;

@property (assign, nonatomic) CGFloat bullble_bgView_width;

@property (assign, nonatomic) CGFloat bullble_bgView_height;

@property (assign, nonatomic) CGFloat review_tableView_height;

@property (assign, nonatomic) CGFloat review_tableView_width;








- (instancetype)initWithDict:(NSDictionary *)dict;

@end
