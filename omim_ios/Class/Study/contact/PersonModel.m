//
//  PersonModel.m
//  MG
//
//  Created by macbook air on 14-9-23.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

-(void)dealloc{
    [_uid release],_uid = nil;
    [_nickName release],_nickName = nil;
    [_upload_photo_timestamp release],_upload_photo_timestamp = nil;
    [_user_type release],_user_type = nil;
    [_class_id release],_class_id = nil;
    [_sex release],_sex = nil;
    [_alias release],_alias = nil;
    [super dealloc];
}

@end
