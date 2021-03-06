/*
 * ABGroup.m
 * iPhoneContacts
 */


#import "ABGroup.h"
#import "ABPerson.h"
#import "ABSource.h"

extern NSArray * WrappedArrayOfRecords( NSArray * records, Class<ABRefInitialization> class );

@implementation ABGroup

- (id) init
{
    ABRecordRef group = ABGroupCreate();
    if ( group == NULL )
    {
        [self release];
        return ( nil );
    }
    else
    {   
        id result =  [super init];
        CFRelease(group);
        return  result;
    }
}

- (ABSource *) source
{
	ABRecordRef source = ABGroupCopySource( _ref );
    
    ABSource* result = [[[ABSource alloc] initWithABRef: source] autorelease];
    CFRelease(source);
    
	return result;
}

- (NSArray *) allMembers
{
    NSArray * members = (NSArray *) ABGroupCopyArrayOfAllMembers( _ref );
    if ( [members count] == 0 )
    {
        [members release];
        return ( nil );
    }
    
    NSArray * result = (NSArray *) WrappedArrayOfRecords( members, [ABPerson class] );
    [members release];
    
    return ( result );
}

- (NSArray *) allMembersSortedInOrder: (ABPersonSortOrdering) order
{
    NSArray * members = (NSArray *) ABGroupCopyArrayOfAllMembersWithSortOrdering( _ref, order );
    if ( [members count] == 0 )
    {
        [members release];
        return ( nil );
    }
    
    NSArray * result = (NSArray *) WrappedArrayOfRecords( members, [ABPerson class] );
    [members release];
    
    return ( result );
}

- (NSArray *) allMembersSorted
{
    NSArray * members = (NSArray *) ABGroupCopyArrayOfAllMembersWithSortOrdering( _ref, ABPersonGetSortOrdering() );
    if ( [members count] == 0 )
    {
        [members release];
        return ( nil );
    }
    
    NSArray * result = (NSArray *) WrappedArrayOfRecords( members, [ABPerson class] );
    [members release];
    
    return ( result );
}

- (BOOL) addMember:(ABPerson *) person{
	CFErrorRef error;
	if(!ABGroupAddMember(_ref, person.recordRef, &error)){
		return FALSE;
	}
	return TRUE;
}

- (BOOL) removeMember: (ABPerson *) person{
	CFErrorRef error;
	if(!ABGroupRemoveMember(_ref, person.recordRef, &error)){
		return FALSE;
	}
	return TRUE;
}



- (BOOL) addMember: (ABPerson *) person error: (NSError **) error
{
    return ( (BOOL) ABGroupAddMember(_ref, person.recordRef, (CFErrorRef *)error) );
}

- (BOOL) removeMember: (ABPerson *) person error: (NSError **) error
{
    return ( (BOOL) ABGroupRemoveMember(_ref, person.recordRef, (CFErrorRef *)error) );
}

- (NSIndexSet *) indexSetWithAllMemberRecordIDs
{
    NSArray * members = (NSArray *) ABGroupCopyArrayOfAllMembers( _ref );
    if ( [members count] == 0 )
    {
        [members release];
        return ( nil );
    }
    
    NSMutableIndexSet * mutable = [[NSMutableIndexSet alloc] init];
    for ( id person in members )
    {
        [mutable addIndex: (NSUInteger)ABRecordGetRecordID((ABRecordRef)person)];
    }
    
    [members release];
    
    NSIndexSet * result = [mutable copy];
    [mutable release];
    
    return ( [result autorelease] );
}

@end
