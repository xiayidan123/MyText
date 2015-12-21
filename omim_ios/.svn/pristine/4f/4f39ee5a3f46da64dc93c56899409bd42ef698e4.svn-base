//
//  HomeworkReviewModel.m
//  dev01
//
//  Created by 杨彬 on 15/5/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "HomeworkReviewModel.h"
#import "WTUserDefaults.h"

@interface HomeworkReviewModel ()

@property (assign, nonatomic) CGFloat content_label_height;

@property (assign, nonatomic) BOOL alreadySetSize;


@end

@implementation HomeworkReviewModel


-(void)dealloc{
    self.review_id = nil;
    self.result_id = nil;
    self.text = nil;
    self.student_id = nil;
    self.homework_id = nil;
    self.moment_id = nil;
    
    self.rank_array = nil;
    self.teacher_id = nil;
    
    [super dealloc];
}


- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.review_id = dict[@"id"];
        self.result_id = dict[@"homeworkresult_id"];
        
        NSArray *title_array = @[@"完整性",@"及时性",@"准确性"];
        
        self.teacher_id = dict[@"teacher_id"];
        
        for (int i=0; i< 3; i++){
            HomeworkReviewRankModel *rank_model = [[HomeworkReviewRankModel alloc]init];
            rank_model.rank_title = title_array[i];
            rank_model.rank_value = dict[[NSString stringWithFormat:@"rank%d",i+1]];
            [self.rank_array addObject:rank_model];
            [rank_model release];
        }
        
        self.text = dict[@"text"];
    }
    return self;
}

- (void)setSize{
    
    NSInteger user_type = [[WTUserDefaults getUsertype] intValue];
    
    if (user_type == 2 ){
        self.isFromMySelf = YES;
    }else{
        self.isFromMySelf = NO;
    }
    
    
    // time_label
    self.time_label_height = 0;
    
    
    // review_tableView
    self.review_tableView_width = Homework_Review_rankCell_width;
    
    self.review_tableView_height = self.rank_array.count * Homework_Review_rankCell_height;
    
    
    // content_label
    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:Homework_Review_content_text_font]};
    CGSize maxSize = CGSizeMake(Homework_Review_rankCell_width, MAXFLOAT);
    CGSize text_size = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    self.text_label_width = Homework_Review_rankCell_width;
    self.text_label_height = text_size.height;
    
    
    // bubble_bgView
    self.bullble_bgView_width = self.review_tableView_width + Homewirk_Review_margins * 2;
    
    self.bullble_bgView_height = self.review_tableView_height + self.text_label_height + Homework_Review_content_label_top + Homewirk_Review_margins * 2 + Homework_Review_bubble_bgView_bottom;
    
}


-(CGFloat)cell_height{
    if (!self.alreadySetSize){
        [self setSize];
        self.alreadySetSize = YES;
    }
    
    return self.time_label_height + self.bullble_bgView_height + Homework_Review_gap_to_bottom + Homework_Review_Bubble_top;
}


-(NSMutableArray *)rank_array{
    if (_rank_array == nil){
        _rank_array = [[NSMutableArray alloc]init];
    }
    return _rank_array;
}

@end
