//
//  Moment.m
//  yuanqutong
//
//  Created by coca on 13-4-11.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Moment.h"
#import "Database.h"
#import "WTFile.h"
#import "Review.h"
#import "Option.h"
#import "NSString+Compare.h"
#import "WTUserDefaults.h"
@implementation Moment
@synthesize moment_id;
@synthesize text;
@synthesize owner;
@synthesize timestamp;
@synthesize longitude;
@synthesize latitude;
@synthesize privacyLevel;
@synthesize allowReview;
@synthesize multimedias;
@synthesize reviews;
@synthesize likedByMe;
@synthesize placename = _placename;
@synthesize isFavorite;


-(void)dealloc
{
    self.moment_id = nil;
    self.text = nil;
    self.multimedias = nil;
    self.reviews = nil;
    self.placename = nil;
    self.owner = nil;
    
    [super dealloc];
    
}

- (id)initWithDict:(NSDictionary *)dict
{
    if (dict==nil) {
        return nil;
    }
    self = [self initWithMomentID:[dict objectForKey:@"moment_id"]
                         withText:[dict objectForKey:@"text"]
                       withOwerID:[dict objectForKey:@"uid"]
                     withUserType:[dict objectForKey:@"user_type"]
                     withNickname:[dict objectForKey:@"nickname"]
                    withTimestamp: [dict objectForKey:@"insert_timestamp"]
                    withLongitude:[dict objectForKey:@"insert_longitude"]
                     withLatitude:[dict objectForKey:@"insert_latitude"]
                 withPrivacyLevel:[dict objectForKey:@"privacy_level"]
                  withAllowReview:[dict objectForKey:@"allow_review"]
                    withLikedByMe:[dict objectForKey:@"liked"]
            withPlacename:[dict objectForKey:@"place"]
            withMomentType:[dict objectForKey:@"tag"]
                     withDeadline:[dict objectForKey:@"deadline"]];
    
        if ([[dict objectForKey:@"multimedia_set"] objectForKey:@"multimedia"])
        {
            if ([[[dict objectForKey:@"multimedia_set"] objectForKey:@"multimedia"] isKindOfClass:[NSMutableArray class]]){
                for (NSMutableDictionary *mediaDict in [[dict objectForKey:@"multimedia_set"] objectForKey:@"multimedia"] ) {
                    WTFile* wtfile = [[WTFile alloc] initWithDict:mediaDict] ;
                    [self.multimedias addObject:wtfile];
                    [wtfile release];
                }
            }
            
            else if([[[dict objectForKey:@"multimedia_set"] objectForKey:@"multimedia"] isKindOfClass:[NSMutableDictionary class]])
            {
                WTFile* wtfile = [[WTFile alloc] initWithDict:[[dict objectForKey:@"multimedia_set"] objectForKey:@"multimedia"]];
                [self.multimedias addObject:wtfile];
                [wtfile release];
            }
        }
       
        
        if ([[dict objectForKey:@"review_set"] objectForKey:@"review"])  //TODO: change here.
        {
            if ([[[dict objectForKey:@"review_set"] objectForKey:@"review"] isKindOfClass:[NSMutableArray class]]){
                for (NSMutableDictionary *reviewDict in [[dict objectForKey:@"review_set"] objectForKey:@"review"]) {
                    Review* review = [[Review alloc] initWithDict:reviewDict];
                    if (![NSString isEmptyString:review.nickName]) {
                        [self.reviews addObject:review];
                    }
                    
                    [review release];
                }
            }
            else if([[[dict objectForKey:@"review_set"] objectForKey:@"review"] isKindOfClass:[NSMutableDictionary class]])
            {
                Review* review = [[Review alloc] initWithDict:[[dict objectForKey:@"review_set"] objectForKey:@"review"]];
                if (![NSString isEmptyString:review.nickName]) {
                    [self.reviews addObject:review];
                }
                [review release];
            }

        }
    
    
    
    
    //add options for survey
    
    if ([[dict objectForKey:@"option_set"] objectForKey:@"option"]) {
        if ([[[dict objectForKey:@"option_set"] objectForKey:@"option"] isKindOfClass:[NSMutableArray class]]){
            for (NSMutableDictionary *optionDict in [[dict objectForKey:@"option_set"] objectForKey:@"option"]) {
                Option* option = [[Option alloc] initWithMomentID:self.moment_id WithOptionID:[optionDict objectForKey:@"option_id"] withDescription:[optionDict objectForKey:@"description"] withVoteCount:[optionDict objectForKey:@"vote_count"] withIsVoted:[optionDict objectForKey:@"is_voted"]];
                [self.options addObject:option];
                [option release];
            }
        }
        else if([[[dict objectForKey:@"option_set"] objectForKey:@"option"] isKindOfClass:[NSMutableDictionary class]])
        {
            NSMutableDictionary*optionDict = [[dict objectForKey:@"option_set"] objectForKey:@"option"];
            Option* option = [[Option alloc] initWithMomentID:self.moment_id WithOptionID:[optionDict objectForKey:@"option_id"] withDescription:[optionDict objectForKey:@"description"] withVoteCount:[optionDict objectForKey:@"vote_count"] withIsVoted:[optionDict objectForKey:@"is_voted"]];
            
            [self.options addObject:option];
            [option release];
        }
    }
    
    // add share range
    if ([[dict objectForKey:@"sharerange"] objectForKey:@"group_id"]) {
        if ([[[dict objectForKey:@"sharerange"] objectForKey:@"group_id"] isKindOfClass:[NSMutableArray class]]){
            for (NSString* groupid in [[dict objectForKey:@"sharerange"] objectForKey:@"group_id"]) {
                [self.viewableGroups addObject:groupid];
            }
        }
        else
        {
            NSString* groupid = [[dict objectForKey:@"sharerange"] objectForKey:@"group_id"];
            [self.viewableGroups addObject:groupid];
        }
    }
    //isFavorite = [Database isMomentMyFavorite:moment_id];
    
    return self;
}



- (id)initWithMomentID:(NSString*)strMomentID withText:(NSString*)strText withOwerID:(NSString*)strOwnerID withUserType:(NSString *)userType withNickname:(NSString*)strNickname  withTimestamp:(NSString*)strTimestamp withLongitude:(NSString*)strLongitude withLatitude:(NSString*)strLatitude withPrivacyLevel:(NSString*)strPrivacyLevel withAllowReview:(NSString*)strAllowReview withLikedByMe:(NSString*)strLikedByMe  withPlacename:(NSString*)placename withMomentType:(NSString*)momentType withDeadline:(NSString*)deadline{
    if (self = [super init])
    {
        self.moment_id = strMomentID;
        self.text = strText;
        
        self.timestamp = strTimestamp?[strTimestamp intValue]:-1;
        self.longitude = strLongitude?[strLongitude floatValue]:-1;
        self.latitude = strLatitude?[strLatitude floatValue]:-1;
        
        self.privacyLevel = strPrivacyLevel?[strPrivacyLevel intValue]:0;
        self.allowReview = strAllowReview?[strAllowReview isEqualToString:@"1"]:YES;
        self.likedByMe = strLikedByMe?[strLikedByMe isEqualToString:@"1"]:NO;
        
        if(strOwnerID){
            self.owner=[Database buddyWithUserID:strOwnerID];  //TODO: broken.
            if(self.owner==nil){
                self.owner = [[[Buddy alloc] initWithUID:strOwnerID andPhoneNumber:nil andNickname:strNickname andStatus:nil andDeviceNumber:nil andAppVer:nil andUserType:userType andBuddyFlag:nil andIsBlocked:nil andSex:nil andPhotoUploadTimeStamp:nil andWowTalkID:nil andLastLongitude:nil andLastLatitude:nil andLastLoginTimestamp:nil withAddFriendRule:0 andAlias:nil] autorelease];
                
            }
        }
        
        self.multimedias=[[[NSMutableArray alloc]init] autorelease];
        self.reviews=[[[NSMutableArray alloc]init]  autorelease];
        
        self.placename = placename? placename : @"";
        
        self.momentType = momentType?[momentType integerValue]:0;
        
        self.deadline = deadline? [deadline integerValue]: -1;
        
        self.viewableGroups = [[[NSMutableArray alloc] init] autorelease];
        
        if (self.momentType == 3 || self.momentType == 4) {
            self.options = [[[NSMutableArray alloc] init] autorelease];
        }
    }
    //isFavorite = [Database isMomentMyFavorite:moment_id];
    return self;

}

-(BOOL)isVotedMoment{
    if (self.options == nil || [self.options count] ==0) {
        return FALSE;
    }
    else{
        for (Option* option in self.options) {
            if (option.is_voted) {
                return TRUE;
            }
        }
    }
    return FALSE;
}

-(BOOL)isExpiredSurveyMoment{
    NSTimeInterval currentTime = [[[NSDate date] dateByAddingTimeInterval:[[WTUserDefaults getTimeOffset] intValue]] timeIntervalSince1970];
    if (currentTime > self.deadline && UNLIMIT_DEADLINE_VOTE_VALUE != self.deadline) {
        return TRUE;
    }
    else
        return FALSE;
}

-(int)currentVotes{
    int votes = 0;
    for (Option* option in self.options) {
        votes += option.vote_count;
    }
    return votes;
}

-(BOOL) isMomentLimited{
    if (self.viewableGroups!=NULL && [self.viewableGroups count] > 0) {
        return TRUE;
    }
    else
        return FALSE;
}


@end
