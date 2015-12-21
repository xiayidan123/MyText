//
//  ActivityModel.m
//  dev01
//
//  Created by 杨彬 on 14-10-24.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ActivityModel.h"
#import "WTFile.h"

@implementation ActivityModel

-(void)dealloc{
    [_event_id release];
    [_owner_id release];
    [_owner_name release];
    [_tag release];
    [_category release];
    [_insert_timestamp release];
    [_latitude release];
    [_longitude release];
    [_area release];
    [_max_member release];
    [_member_count release];
    [_text_title release];
    [_text_content release];
    [_coin release];
    [_date_type release];
    [_date_info release];
    [_classification release];
    [_is_get_member_info release];
    [_is_open release];
    [_start_timestamp release];
    [_end_timestamp release];
    [_is_joined release];
    [_mediaArray release];
    [super dealloc];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _mediaArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (instancetype)initWithDic:(NSMutableDictionary *)dic
{
    if (dic == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _event_id = [dic[@"event_id"] copy];
        _owner_id  = [dic[@"owner_id"] copy];
        _owner_name = [dic[@"owner_name"] copy];
        _tag = [dic[@"tag"] copy];
        _category = [dic[@"category"] copy];
        _insert_timestamp  = [dic[@"insert_timestamp"] copy];
        _latitude  = [dic[@"latitude"] copy];
        _longitude  = [dic[@"longitude"] copy];
        _area  = [dic[@"area"] copy];
        _max_member  = [dic[@"max_member"] copy];
        _member_count  = [dic[@"member_count"] copy];
        _text_title  = [dic[@"text_title"] copy];
        _text_content  = [dic[@"text_content"] copy];
        _coin  = [dic[@"coin"] copy];
        _date_type  = [dic[@"date_type"] copy];
        _date_info  = [dic[@"date_info"] copy];
        _classification  = [dic[@"classification"] copy];
        _is_get_member_info  = [dic[@"is_get_member_info"] copy];
        _is_open  = [dic[@"is_open"] copy];
        _start_timestamp = [dic[@"start_timestamp"] copy];
        _end_timestamp = [dic[@"end_timestamp"] copy];
        _is_joined = [dic[@"is_joined"]copy];
        if ([dic[@"multimedia"] isKindOfClass:[NSArray class]]){
            _mediaArray = [[NSMutableArray alloc]init];
            for (NSDictionary *wtfDic in ((NSArray *)dic[@"multimedia"])){
                WTFile *file = [[WTFile alloc]initWithDict:(NSMutableDictionary *)wtfDic];
                [_mediaArray addObject:file];
                [file release];
            }
        }else if([dic[@"multimedia"] isKindOfClass:[NSDictionary class]]){
            WTFile *file = [[WTFile alloc]initWithDict:dic[@"multimedia"]];
            _mediaArray = [[NSMutableArray alloc]initWithObjects:file, nil];
            [file release];
        }else{
            _mediaArray = [[NSMutableArray alloc]init];
        }
       
        
    }
    return self;
}





@end
