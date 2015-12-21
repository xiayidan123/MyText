//
//  Communicator_GetMomentsForGroup.h
//  dev01
//
//  Created by elvis on 2013/11/29.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator.h"

@interface Communicator_GetMomentsForGroup : Communicator
@property (nonatomic,retain) NSString* gid;
@property NSInteger maxTimestamp;
@property (nonatomic,copy) NSArray* momentTags;
+(void) deleteMomentFromDbWhenLoadedFromServer:(NSMutableArray *)momentsFromServer compareAllMoments:(NSMutableArray *)allMoments withTimeStamp:(NSInteger)maxTimeStamp withTags:(NSArray *)momentTags;
@end
