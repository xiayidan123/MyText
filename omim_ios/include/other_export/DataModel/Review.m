//
//  Review.m
//  yuanqutong
//
//  Created by coca on 13-4-12.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Review.h"
#import "NSString+Compare.h"

@implementation Review



@synthesize review_id;
@synthesize text;
@synthesize owerID;
@synthesize nickName;
@synthesize timestamp;

@synthesize type;

@synthesize replyToReviewId;
@synthesize replyToUid;
@synthesize replyToNickname;
@synthesize moment_id = _moment_id;



- (id)initWithDict:(NSMutableDictionary *)dict
{
    if (dict==nil) {
        return nil;
    }
    self = [self initWithReviewID:[dict objectForKey:@"review_id"]
                         withText:[dict objectForKey:@"comment"]
                       withOwerID:[dict objectForKey:@"reviewer_uid"]
                     withNickname:[dict objectForKey:@"nickname"]
                    withTimestamp:[dict objectForKey:@"insert_timestamp"]
                         withType:[dict objectForKey:@"comment_type"]
              withReplyToReviewID:[dict objectForKey:@"reply_to_review_id"]
                   withReplyToUID:[dict objectForKey:@"reply_to_uid"]
              withReplyToNickname:[dict objectForKey:@"reply_to_nickname"]
            withAlreadyRead:[[dict objectForKey:@"has_been_read"] boolValue]];
    
    return self;
}




- (id)initWithReviewID:(NSString*)strReviewID withText:(NSString*)strText withOwerID:(NSString*)strOwnerID withNickname:(NSString*)strNickname withTimestamp:(NSString*)strTimestamp withType:(NSString*)strType withReplyToReviewID:(NSString*)strReplyToReviewId withReplyToUID:(NSString*)strReplyToUid withReplyToNickname:(NSString*)strReplyToNickname withAlreadyRead:(BOOL)flag{
    
    if (self = [super init])
    {
        self.review_id = strReviewID;
        self.text = strText;
        self.owerID = strOwnerID;
        self.nickName= strNickname;
        
        self.timestamp = strTimestamp?[strTimestamp intValue]:-1;
        
        self.type = strType?[strType intValue]:-1;

        self.replyToReviewId= strReplyToReviewId;
        self.replyToUid= strReplyToUid;
        self.replyToNickname= strReplyToNickname;
        self.read = flag;
        self.invisible = FALSE;
        
    }
    
    return self;

    
}



// helper for review parser
+(NSString*)styledReview:(Review *)review
{
    NSString* str = @"";
    if ([NSString isEmptyString:review.replyToUid]) {
        str =  [NSString stringWithFormat:@"<a href=\'%@\'>%@</a>:%@",review.owerID,review.nickName, review.text];
    }
    else{
        str =  [NSString stringWithFormat:@"<a href=\'%@\'>%@</a><a href=\'\'></a>:%@",review.owerID,review.nickName,review.text];
    }
    
    return str;
    
}


-(void)dealloc
{
    self.review_id = nil;
    self.text = nil;
    self.owerID = nil;
    self.nickName= nil;
    self.replyToNickname = nil;
    self.replyToReviewId = nil;
    self.replyToUid = nil;
    self.moment_id = nil;
    [super dealloc];
}


@end
