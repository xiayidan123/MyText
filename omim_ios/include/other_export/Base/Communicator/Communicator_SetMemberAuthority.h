//
//  Communicator_SetMemberAuthority.h
//  omim
//
//  Created by coca on 2013/04/26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator.h"

@interface Communicator_SetMemberAuthority : Communicator

@property (nonatomic,retain) NSString* memberid;
@property (nonatomic,retain) NSString* groupid;
@property (nonatomic,retain) NSString* level;

@end
