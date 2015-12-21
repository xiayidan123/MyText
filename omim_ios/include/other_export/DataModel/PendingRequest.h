//
//  PendingRequest.h
//
//  Created by elvis on 2013/05/09.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingRequest : NSObject

@property (nonatomic,retain) NSString* groupid;
@property (nonatomic,retain) NSString* groupname;

@property (nonatomic,retain) NSString* buddyid;
@property (nonatomic,retain) NSString* nickname;
@property (nonatomic,retain) NSString* msg;

@end
