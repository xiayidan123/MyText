//
//  AddressBookManager.h
//  omim
//
//  Created by coca on 2013/04/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressBook.h"
@interface AddressBookManager : NSObject

@property (nonatomic,retain) NSArray* localcontacts;
@property (nonatomic,assign) BOOL rebuild;
+(AddressBookManager*) defaultManager;

-(NSMutableArray*)allNumbersInContactBook;

//+(NSArray*)phoneNumbersOfPerson:(ABPerson*)person;

//+(NSArray*)emailsOfPerson:(ABPerson*)person;

+(NSArray*)phoneNumbersOfPerson:(ABPerson*)person WithLabel:(BOOL)needLabel;

+(NSArray*)emailsOfPerson:(ABPerson*)person WithLabel:(BOOL)needLabel;

+(NSArray*) multiFieldByRecord:(ABRecordRef)record byPropertyId:(ABPropertyID)propertyId needLabel:(BOOL)needLabel;

//+(NSString*)decrptedNumber:(NSString*)number;

+(ABPerson*)personWithNumber:(NSString*)number;
@end
