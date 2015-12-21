/*
 * ABSource.h
 * iPhoneContacts
 */


#import "ABSource.h"

#import "ABAddressBook.h"
#import "ABGroup.h"

extern NSArray * WrappedArrayOfRecords( NSArray * records, Class<ABRefInitialization> class );


@implementation ABSource

- (NSArray *) allGroups
{
	NSArray * groups = (NSArray *) ABAddressBookCopyArrayOfAllGroupsInSource( [ABAddressBook sharedAddressBook].addressBookRef, _ref );
    if ( [groups count] == 0 )
    {
        [groups release];
        return ( nil );
    }
    
    NSArray * result = (NSArray *) WrappedArrayOfRecords( groups, [ABGroup class] );
    [groups release];
    
    return ( result );
}

@end
