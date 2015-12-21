//
//  CallLog.m
//  omim
//
//  Created by Coca on 7/2/11.
//  Copyright 2011 WowTech Inc. All rights reserved.
//

#import "CallLog.h"


@implementation CallLog
@synthesize primaryKey;
@synthesize contact;
@synthesize  displayName;
@synthesize status;
@synthesize direction;
@synthesize startDate;
@synthesize duration;
@synthesize quality;

@synthesize phoneType;
@synthesize compositeName;
@synthesize chatUserRecordID;

- (id) init {
	self = [super init];
	if (self == nil)
		return nil;
	
	primaryKey = -1;
	
	return self;
}

- (id) copyWithZone:(NSZone *)zone {
	CallLog *log = [[CallLog alloc] init];
	if ([self hasPrimaryKey]) {
		//if(PRINT_LOG)NSLog(@"CallLog: Set Primary Key");
		log.primaryKey = self.primaryKey;
	}
	log.contact = self.contact;
    log.displayName = self.displayName;
	log.status = self.status;
	log.direction = self.direction;
	log.startDate =self.startDate;
	log.duration = self.duration;
	log.quality = self.quality;
	
	log.phoneType = self.phoneType;
	log.compositeName = self.compositeName;
	log.chatUserRecordID = self.chatUserRecordID;
	return log;
}

- (BOOL) hasPrimaryKey {
	return primaryKey != -1;
}

- (NSInteger)primaryKey {
	return primaryKey;
}

- (void)setPrimaryKey:(NSInteger)anInteger {
	primaryKey = anInteger;
}

-(void)dealloc
{
    //    self.primaryKey = nil;
    self.contact = nil;
    self.displayName = nil;
    //    self.status = nil;
    self.direction = nil;
    self.startDate = nil;
    //    self.duration = nil;
    //    self.quality = nil;
    
    self.phoneType = nil;
    self.compositeName = nil;
    //    self.chatUserRecordID = nil;
    
    [super dealloc];
}


@end
