//
//  Option.h
//  wowtalkbiz
//
//  Created by elvis on 2013/09/29.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Option : NSObject

@property int option_id;
@property (nonatomic,retain) NSString* desc;
@property (nonatomic,retain) NSString* moment_id;

@property int vote_count;
@property BOOL is_voted;

-(id)initWithMomentID:(NSString*)moment_id WithOptionID:(NSString*)option_id withDescription:(NSString*)description withVoteCount:(NSString*)vote_count withIsVoted:(NSString*)is_voted;

-(id)initWithDict:(NSMutableDictionary*)dict;

@end
