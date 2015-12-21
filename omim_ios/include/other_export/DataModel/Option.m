//
//  Option.m
//  wowtalkbiz
//
//  Created by elvis on 2013/09/29.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Option.h"

@implementation Option
-(id)initWithMomentID:(NSString*)moment_id WithOptionID:(NSString*)option_id withDescription:(NSString*)description withVoteCount:(NSString*)vote_count withIsVoted:(NSString*)is_voted{
    self = [super init];
    if (self) {
        self.moment_id = moment_id;
        self.option_id = [option_id integerValue];
        self.desc = description;
        self.vote_count = [vote_count integerValue];
        self.is_voted = [is_voted boolValue];
    }
    return self;
}

@end
