//
//  NewhomeWorkModel.m
//  dev01
//
//  Created by Huan on 15/5/19.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NewhomeWorkModel.h"

#import "HomeworkReviewModel.h"

@implementation NewhomeWorkModel

- (void)dealloc{
    self.teacher_id = nil;
    
    self.homework_moment = nil;
    
    self.results_moments = nil;
    
    [super dealloc];
}

+ (instancetype)NewhomeWorkModelWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc]initWithDict:dic] autorelease];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self parseWithDic:(NSDictionary *)dict];
    }
    return self;
}

- (void)parseWithDic:(NSDictionary *)dict{
    
    
    NSDictionary *moment_dic = dict[@"moment"];
    
    self.homework_moment =  [[[Homework_Moment alloc]initWithDict:moment_dic] autorelease];
    
    self.homework_moment.homework_id = dict[@"id"];
    self.homework_moment.lesson_id = dict[@"lesson_id"];
    self.teacher_id = dict[@"teacher_id"];
    id result_objc = dict[@"homework_results"][@"homework_result"];
    
    NSMutableArray *result_array = nil;
    if ([result_objc isKindOfClass:[NSArray class]]){
        result_array = [[NSMutableArray alloc]initWithArray:result_objc];
    }else if ([result_objc isKindOfClass:[NSDictionary class]]){
        result_array = [[NSMutableArray alloc]init];
        [result_array addObject:result_objc];
    }
    
    for (NSDictionary *dic in result_array){
        NSDictionary *homework_result_dic = dic;
        
        Homework_Moment *homework_result = [[Homework_Moment alloc]initWithDict:homework_result_dic[@"moment"]];
        homework_result.result_id = homework_result_dic[@"id"];
        homework_result.student_id = homework_result_dic[@"student_id"];
        homework_result.homework_id = homework_result_dic[@"homework_id"];
        [self.results_moments addObject:homework_result];
        
        if(homework_result_dic[@"homework_review"]){
            HomeworkReviewModel *review_model = [[HomeworkReviewModel alloc]initWithDict:homework_result_dic[@"homework_review"]];
            review_model.student_id = homework_result.student_id;
            review_model.homework_id = homework_result_dic[@"homework_id"];
            review_model.moment_id = homework_result.moment_id;
            [self.results_moments addObject:review_model];
            [review_model release];
        }
        
        [homework_result release];
    }
    
    [result_array release];
}



-(NSMutableArray *)results_moments{
    if (_results_moments == nil){
        _results_moments = [[NSMutableArray alloc]init];
    }
    return _results_moments;
}

@end
