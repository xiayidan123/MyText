/*
 * ABGroup.h
 * iPhoneContacts
 */


#import <Foundation/Foundation.h>
#import <AddressBook/ABGroup.h>
#import "ABRecord.h"

@class ABPerson;
@class ABSource;

@interface ABGroup : ABRecord

// use -init to create a new group

@property (nonatomic, readonly) ABSource *source;

- (NSArray *) allMembers;
- (NSArray *) allMembersSorted;
- (NSArray *) allMembersSortedInOrder: (ABPersonSortOrdering) order;

- (BOOL) addMember: (ABPerson *) person error: (NSError **) error;
- (BOOL) removeMember: (ABPerson *) person error: (NSError **) error;

- (BOOL) addMember: (ABPerson *) person;
- (BOOL) removeMember: (ABPerson *) person;


- (NSIndexSet *) indexSetWithAllMemberRecordIDs;

@end
