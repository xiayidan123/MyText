//
//  EventApplyMemberModel.h
//  dev01
//
//  Created by 杨彬 on 15-1-3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventApplyMemberModel : NSObject

@property (copy, nonatomic)NSString *event_id;
@property (copy, nonatomic)NSString *member_id;
@property (copy, nonatomic)NSString *nickname;
@property (copy, nonatomic)NSString *status;
@property (copy, nonatomic)NSString *upload_photo_timestamp;
@property (copy, nonatomic) NSString * real_name;
@property (copy, nonatomic) NSString * telephone_number;



@end
