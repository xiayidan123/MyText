/*
 * ABAddressBook.h
 * iPhoneContacts
 */

#import <Foundation/Foundation.h>
#import <AddressBook/ABAddressBook.h>
#import "ABRefInitialization.h"

@class ABRecord, ABPerson, ABGroup, ABSource;

enum
{
    ABOperationNotPermittedByStoreError = kABOperationNotPermittedByStoreError
    
};

@interface ABAddressBook : NSObject <ABRefInitialization,UIAlertViewDelegate>
{
    ABAddressBookRef            _ref;

}

+ (ABAddressBook *) sharedAddressBook;
//+ (ABAddressBook *) renewSharedAddressBook;
@property (nonatomic, readonly, getter=getAddressBookRef) ABAddressBookRef addressBookRef;


- (BOOL) save;
- (BOOL) save: (NSError **) error;
@property (nonatomic, readonly) BOOL hasUnsavedChanges;

- (BOOL) addRecord: (ABRecord *) record error: (NSError **) error;
- (BOOL) removeRecord: (ABRecord *) record error: (NSError **) error;

- (NSString *) localizedStringForLabel: (NSString *) labelName;

- (void) revert;

@end

@interface ABAddressBook (People)

@property (nonatomic, readonly) NSUInteger personCount;
- (BOOL) removePersonWithRecordRef: (ABRecordRef) person;
- (ABPerson *) personWithRecordID: (ABRecordID) recordID;
- (NSArray *) allPeople;
- (NSArray *) allPeopleSorted;
- (NSArray *) allPeopleWithName: (NSString *) name;

@end

@interface ABAddressBook (Groups)

@property (nonatomic, readonly) NSUInteger groupCount;

- (ABGroup *) groupWithRecordID: (ABRecordID) recordID;
- (NSArray *) allGroups;
- (BOOL) addNewGroup: (NSString*)name;
- (BOOL) removeGroup: (ABGroup*)group;
- (BOOL) changeGroup:(ABGroup*)group toNewName:(NSString*)name;

@end

@interface ABAddressBook (Sources)

- (ABSource *) sourceWithRecordID: (ABRecordID) recordID;
- (ABSource *) defaultSource;
- (NSArray *) allSources;

@end

