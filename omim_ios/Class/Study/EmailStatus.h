//
//  EmailStatus.h
//  dev01
//
//  Created by Huan on 15/3/5.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailStatus : NSObject
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *verified;
@property (copy, nonatomic) NSString *paramName;
@end
