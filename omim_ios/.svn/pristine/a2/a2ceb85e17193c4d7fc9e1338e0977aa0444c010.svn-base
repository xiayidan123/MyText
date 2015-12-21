//
//  Moment.h
//  yuanqutong
//
//  Created by coca on 13-4-11.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Buddy.h"

#define UNLIMIT_DEADLINE_VOTE_VALUE -1

typedef enum {
    MomentTypeNone = -1,
    MomentTypeStatus = 0,
    MomentTypeQA = 1,
    MomentTypeReport = 2,
    MomentTypeSurvey = 3
}MomentType;

@interface Moment : NSObject{
    
}

@property (nonatomic, copy) NSString* moment_id;

@property (nonatomic, copy) NSString* text;

@property (nonatomic, copy) Buddy* owner;

@property (assign) NSInteger timestamp;

@property (assign) double longitude;
@property (assign) double latitude;

@property (nonatomic,retain) NSString* placename;

@property (assign) NSInteger privacyLevel;    // this could be used to track whether it is limited or not.

@property (assign) BOOL allowReview;

@property (nonatomic, retain) NSMutableArray *multimedias;
@property (nonatomic, retain) NSMutableArray *reviews;

@property (assign) BOOL likedByMe;

@property int momentType;  //  (0:status; 1:q&a; 2:report; 3:single choice survey; 4:multiple choice survey 5:todo;)

@property BOOL isPlaying;

@property BOOL isLimited;

@property (nonatomic,retain) NSMutableArray* viewableGroups;  // store it in a table.

// for survey moment
@property NSTimeInterval deadline;
//@property BOOL isVoted;
@property (nonatomic,retain) NSMutableArray* options;
//@property int totalVotes;
@property BOOL multipleSelection;

@property (nonatomic) BOOL isFavorite;


- (id)initWithDict:(NSDictionary *)dict;

- (id)initWithMomentID:(NSString*)strMomentID withText:(NSString*)strText withOwerID:(NSString*)strOwnerID withUserType:(NSString *)userType withNickname:(NSString*)strNickname withTimestamp:(NSString*)strTimestamp withLongitude:(NSString*)strLongitude withLatitude:(NSString*)strLatitude withPrivacyLevel:(NSString*)strPrivacyLevel withAllowReview:(NSString*)strAllowReview withLikedByMe:(NSString*)strLikedByMe withPlacename:(NSString*)placename withMomentType:(NSString*)momentType withDeadline:(NSString*)deadline;

-(BOOL)isVotedMoment;

-(BOOL)isExpiredSurveyMoment;

-(int)currentVotes;

-(BOOL) isMomentLimited;
@end
