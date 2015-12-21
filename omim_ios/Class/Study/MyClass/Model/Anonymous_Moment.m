//
//  Anonymous_Moment.m
//  dev01
//
//  Created by 杨彬 on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Anonymous_Moment.h"




@implementation Anonymous_Moment

-(void)dealloc{
    self.anonymous_uid = nil;
    self.bulletin_id = nil;
    self.class_id = nil;
    [super dealloc];
}


- (instancetype)initWithDict:(NSDictionary *)dic
{
    NSMutableDictionary *dict  = [[NSMutableDictionary alloc]initWithDictionary:dic[@"moment"]];
    self = [super initWithDict:dict];
    if (self) {
        self.moment_id = dic[@"moment_id"];
        self.anonymous_uid = dic[@"uid"];
        self.bulletin_id = dic[@"bulletin_id"];
        self.class_id = dic[@"class_id"];
    }
    [dict release];
    return self;
}

- (instancetype)initWithMomentDic:(NSDictionary *)dic
{
     NSMutableDictionary *dict  = [[NSMutableDictionary alloc]initWithDictionary:dic];
    self = [super initWithDict:dict];
    if (self) {

    }
    [dict release];
    return self;
}


- (instancetype)initWithMoment:(Moment *)moment
{
    return [[[[self class] alloc] initWithMomentID:moment.moment_id withText:moment.text
                        withOwerID:moment.owner.userID
                      withUserType:[NSString stringWithFormat:@"%zi",moment.owner.userType]
                      withNickname:moment.owner.nickName
                     withTimestamp:[NSString stringWithFormat:@"%zi",moment.timestamp]
                     withLongitude:[NSString stringWithFormat:@"%lf",moment.longitude]
                      withLatitude:[NSString stringWithFormat:@"%lf",moment.latitude]
                  withPrivacyLevel:[NSString stringWithFormat:@"%zi",moment.privacyLevel]
                   withAllowReview:[NSString stringWithFormat:@"%zi",moment.allowReview]
                     withLikedByMe:[NSString stringWithFormat:@"%zi",moment.likedByMe]
                     withPlacename:moment.placename
                    withMomentType:[NSString stringWithFormat:@"%d",moment.momentType]
                      withDeadline:[NSString stringWithFormat:@"%lf",moment.deadline]] autorelease];
}



@end
