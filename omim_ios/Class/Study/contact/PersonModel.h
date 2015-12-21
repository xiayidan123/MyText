//
//  PersonModel.h
//  MG
//
//  Created by macbook air on 14-9-23.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (nonatomic,copy)NSString *personName;

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,copy)NSString *upload_photo_timestamp;
@property (nonatomic,copy)NSString *user_type;
@property (nonatomic,copy)NSString *class_id;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *alias;

@end
