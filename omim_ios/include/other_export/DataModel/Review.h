//
//  Review.h
//  yuanqutong
//
//  Created by coca on 13-4-12.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

enum WTReviewType {
	REVIEW_TYPE_UNKNOWN=-1, 
	REVIEW_TYPE_LIKE=0 ,
    REVIEW_TYPE_TEXT=1
};

@interface Review : NSObject{
    
}

@property (nonatomic, copy) NSString* review_id;

@property (nonatomic, copy) NSString* text;

@property (nonatomic, copy) NSString* owerID;

@property (nonatomic, copy) NSString* nickName;

@property (assign) NSInteger timestamp;

@property (assign) enum WTReviewType type;

@property (nonatomic, copy) NSString* replyToReviewId;

@property (nonatomic, copy) NSString* replyToUid;

@property (nonatomic, copy) NSString* replyToNickname;

@property BOOL read;

@property (nonatomic,retain) NSString* moment_id;

@property BOOL invisible;

- (id)initWithDict:(NSMutableDictionary *)dict;

- (id)initWithReviewID:(NSString*)strReviewID withText:(NSString*)strText withOwerID:(NSString*)strOwnerID withNickname:(NSString*)strNickname withTimestamp:(NSString*)strTimestamp withType:(NSString*)strType withReplyToReviewID:(NSString*)strReplyToReviewId withReplyToUID:(NSString*)strReplyToUid withReplyToNickname:(NSString*)replyToNickname withAlreadyRead:(BOOL)flag;



// helper for review parser
+(NSString*)styledReview:(Review*)review;



@end
