//
//  CallLog.h
//  omim
//
//  Created by Coca on 7/2/11.
//  Copyright 2011 WowTech Inc. All rights reserved.
//

enum WTCallStatus { 
	WTCallSuccess=0, /**< The call was sucessful*/
	WTCallMissed=1 /**< The call was missed (unanswered/aborted)*/
};

@interface CallLog : NSObject {
	NSInteger  primaryKey;
	NSString   *contact;
    NSString   *displayName;
	enum WTCallStatus status;
	NSString   *direction;   //"out" or "in"
	NSString   *startDate;
	NSInteger duration;
	NSInteger quality;
	
	/////////////// properties below shouldn't be stored in DB/////////
	NSString   *compositeName;  //user composite name in address book
	NSString   *phoneType;  //number phone type in address book
	NSInteger chatUserRecordID;
}
@property (assign) NSInteger primaryKey;
@property (copy) NSString *contact;
@property (copy) NSString *displayName;
@property (assign) enum WTCallStatus status;
@property (copy) NSString *direction;
@property (copy) NSString *startDate;
@property (assign) NSInteger duration;
@property (assign) NSInteger quality;

@property (copy) NSString *compositeName;
@property (copy) NSString *phoneType;
@property (assign) NSInteger chatUserRecordID;

- (BOOL) hasPrimaryKey;

@end
