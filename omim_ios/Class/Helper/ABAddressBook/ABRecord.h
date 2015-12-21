/*
 * ABRecord.h
 * iPhoneContacts
 */

#import <Foundation/Foundation.h>
#import <AddressBook/ABRecord.h>
#import "ABRefInitialization.h"

@interface ABRecord : NSObject <ABRefInitialization>
{
    ABRecordRef     _ref;
}

@property (nonatomic, readonly, getter=getRecordRef) ABRecordRef recordRef;

@property (nonatomic, readonly) ABRecordID recordID;
@property (nonatomic, readonly) ABRecordType recordType;

- (id) valueForProperty: (ABPropertyID) property;
- (BOOL) setValue: (id) value forProperty: (ABPropertyID) property error: (NSError **) error;
- (BOOL) removeValueForProperty: (ABPropertyID) property error: (NSError **) error;

@property (nonatomic, readonly) NSString * compositeName;

@end
