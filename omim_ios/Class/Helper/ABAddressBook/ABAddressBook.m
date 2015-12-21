/*
 * ABAddressBook.m
 * iPhoneContacts
*/

#import <libkern/OSAtomic.h>

#import "ABAddressBook.h"
#import "ABPerson.h"
#import "ABGroup.h"
#import "ABSource.h"
#import "AddressBookManager.h"


 NSArray * WrappedArrayOfRecords( NSArray * records, Class<ABRefInitialization> wrapperClass )
{
    NSMutableArray * wrapped = [[NSMutableArray alloc] initWithCapacity: [records count]];
    for ( id record in records )
    {
        id obj = [[wrapperClass alloc] initWithABRef: (CFTypeRef)record];
        [wrapped addObject: obj];
        [obj release];
    }
    
    NSArray * result = [wrapped copy];
    [wrapped release];
    
    return ( [result autorelease] );
}



@implementation ABAddressBook

@synthesize addressBookRef=_ref;


+ (ABAddressBook *) sharedAddressBook
{
    static ABAddressBook * volatile __shared = nil;
    
    if ( __shared == nil) //|| [AddressBookManager defaultManager].rebuild)// || [[wowtalkAppDelegate sharedAppDelegate] isNeedToRebuildTheAddressBook])
    {
        if (__shared != nil){
             __shared = nil; 
        }

        ABAddressBook * tmp = [[ABAddressBook alloc] init];
        if ( OSAtomicCompareAndSwapPtr(nil, tmp, (void * volatile *)&__shared) == false )
            [tmp release];
        
     //    [AddressBookManager defaultManager].rebuild = FALSE;
        
    }
    
    return ( __shared );
}



- (id) initWithABRef: (CFTypeRef) ref
{
    if ( ref == NULL )
    {
        [self release];
        return ( nil );
    }
    
    self = [super init];
    
    if ( self == nil )
        
        return ( nil );
    
    // we can't to CFTypeID checking on AB types, so we have to trust the user
    _ref = (ABAddressBookRef) CFRetain(ref);
    
    return ( self );
}

- (id) init
{
    self = [super init];
    if ( self == nil )
        return ( nil );
    
    // ios 6
    if( &ABAddressBookRequestAccessWithCompletion == NULL)
    {
        _ref = ABAddressBookCreateWithOptions(NULL, NULL);
        
        // if the addressbook is not get authorized.
       if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
       {
     
           ABAddressBookRequestAccessWithCompletion(_ref, ^(bool granted, CFErrorRef error) {
            if (granted)
            {
           // [AddressBookManager defaultManager].rebuild = TRUE;
             //  [ABAddressBook sharedAddressBook];
                
           //     NSLog(@"the access is granted");
            }
            
        });
       }
      
    }
    
    // below ios 6.
    else
    {
        _ref = ABAddressBookCreate();
    }
    
    if ( _ref == NULL )
    {
        [self release];
        return ( nil );
    }
    
    return ( self );
}

- (void) dealloc
{

    if ( _ref != NULL )
        CFRelease( _ref );
    [super dealloc];
}





- (BOOL) save{
	CFErrorRef error;
    return ( (BOOL) ABAddressBookSave(_ref, &error) );
}

- (BOOL) save: (NSError **) error
{
    return ( (BOOL) ABAddressBookSave(_ref, (CFErrorRef *)error) );
}

- (BOOL) hasUnsavedChanges
{
    return ( (BOOL) ABAddressBookHasUnsavedChanges(_ref) );
}

- (BOOL) addRecord: (ABRecord *) record error: (NSError **) error
{
    return ( (BOOL) ABAddressBookAddRecord(_ref, record.recordRef, (CFErrorRef *)error) );
}

- (BOOL) removeRecord: (ABRecord *) record error: (NSError **) error
{
    return ( (BOOL) ABAddressBookRemoveRecord(_ref, record.recordRef, (CFErrorRef *)error) );
}

- (NSString *) localizedStringForLabel: (NSString *) label
{
    NSString * str = (NSString *) ABAddressBookCopyLocalizedLabel( (CFStringRef)label );
    return ( [str autorelease] );
}

- (void) revert
{
    ABAddressBookRevert( _ref );
}


@end

@implementation ABAddressBook (People)

- (NSUInteger) personCount
{
    return ( (NSUInteger) ABAddressBookGetPersonCount(_ref) );
}


- (BOOL) removePersonWithRecordRef: (ABRecordRef) person{
	CFErrorRef error;
	if(!ABAddressBookRemoveRecord(_ref, person, &error)){
		return FALSE;
	}
	if (!ABAddressBookSave(_ref, &error)) {
		return FALSE;
	}
	return TRUE;
}

- (ABPerson *) personWithRecordID: (ABRecordID) recordID
{
    ABRecordRef person = ABAddressBookGetPersonWithRecordID( _ref, recordID );
    if ( person == NULL )
        return ( nil );
    
    return ( [[[ABPerson alloc] initWithABRef: person] autorelease] );
}

- (NSArray *) allPeople
{
    NSArray * people = (NSArray *) ABAddressBookCopyArrayOfAllPeople( _ref );
    if ( [people count] == 0 )
    {
        [people release];
        return ( nil );
    }
    
    NSArray * result = WrappedArrayOfRecords( people, [ABPerson class] );
    [people release];
    
    return ( result );
}

- (NSArray *) allPeopleSorted
{
  CFArrayRef people = ABAddressBookCopyArrayOfAllPeople( _ref );
  if ( CFArrayGetCount(people) == 0 )
  {
      CFRelease(people);
      return ( nil );
  }
  
  CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                    CFArrayGetCount(people),
                                    people
                                    );
  CFRelease(people);
  CFArraySortValues(
            peopleMutable,
            CFRangeMake(0, CFArrayGetCount(peopleMutable)),
            (CFComparatorFunction) ABPersonComparePeopleByName,
            (void*)(long) ABPersonGetSortOrdering()
            );

  NSArray *peopleSorted = (NSArray*)peopleMutable;
  NSArray *result = WrappedArrayOfRecords( peopleSorted, [ABPerson class] );
  [peopleSorted release];
  
    
  return ( result );
}

- (NSArray *) allPeopleWithName: (NSString *) name
{
    NSArray * people = (NSArray *) ABAddressBookCopyPeopleWithName( _ref, (CFStringRef)name );
    if ( [people count] == 0 )
    {
        [people release];
        return ( nil );
    }
    
    NSArray * result = WrappedArrayOfRecords( people, [ABPerson class] );
    [people release];
    
    return ( result );
}

@end

@implementation ABAddressBook (Groups)

- (NSUInteger) groupCount
{
    return ( (NSUInteger) ABAddressBookGetGroupCount(_ref) );
}

- (ABGroup *) groupWithRecordID: (ABRecordID) recordID
{
    ABRecordRef group = ABAddressBookGetGroupWithRecordID( _ref, recordID );
    if ( group == NULL )
        return ( nil );
    
    return ( [[[ABGroup alloc] initWithABRef: group] autorelease] );
}

- (NSArray *) allGroups
{
    NSArray * groups = (NSArray *) ABAddressBookCopyArrayOfAllGroups( _ref );
    if ( [groups count] == 0 )
    {
        [groups release];
        return ( nil );
    }
    
    NSArray * result = WrappedArrayOfRecords( groups, [ABGroup class] );
    [groups release];
    
    return ( result );
}
- (BOOL) removeGroup: (ABGroup*)group{
	if(group==nil){
		return FALSE;
	}
	CFErrorRef error;
	ABRecordRef groupRef = group.recordRef;
	
	if(!ABAddressBookRemoveRecord(_ref, groupRef, &error)){
		return FALSE;
	}
	if (!ABAddressBookSave(_ref, &error)) {
		return FALSE;
	}
	return TRUE;
}

- (BOOL) addNewGroup: (NSString*)name{
	if(name==nil){
		return FALSE;
	}
	CFErrorRef error;
	ABRecordRef groupRef = ABGroupCreate();
	if (!ABRecordSetValue(groupRef, kABGroupNameProperty,name, &error)) {
        CFRelease(groupRef);
		return FALSE;
	}
	if(!ABAddressBookAddRecord(_ref, groupRef, &error)){
        CFRelease(groupRef);
		return FALSE;
	}
	if (!ABAddressBookSave(_ref, &error)) {
        CFRelease(groupRef);
		return FALSE;
	}
    
    CFRelease(groupRef);
	return TRUE;
}

- (BOOL) changeGroup:(ABGroup*)group toNewName:(NSString*)name{
	if(group==nil || name==nil){
		return FALSE;
	}
	CFErrorRef error;
	ABRecordRef groupRef = group.recordRef;
	
	if (!ABRecordSetValue(groupRef, kABGroupNameProperty,name, &error)) {
		return FALSE;
	}
	if (!ABAddressBookSave(_ref, &error)) {
		return FALSE;
	}
	return TRUE;
}


@end

@implementation ABAddressBook (Sources)

- (ABSource *) sourceWithRecordID: (ABRecordID) recordID
{
	ABRecordRef source = ABAddressBookGetSourceWithRecordID( _ref, recordID );
    
    if ( source == NULL )
        return ( nil );
    
    return ( [[[ABSource alloc] initWithABRef: source] autorelease] );
}

- (ABSource *) defaultSource
{
	ABRecordRef source = ABAddressBookCopyDefaultSource( _ref );
	if ( source == NULL )
        return ( nil );
    
    ABSource* returnSource = [[[ABSource alloc] initWithABRef: source] autorelease];
    
    CFRelease(source);
    
    return returnSource;
}

- (NSArray *) allSources
{
	NSArray * sources = (NSArray *) ABAddressBookCopyArrayOfAllSources( _ref );
    if ( [sources count] == 0 )
    {
        [sources release];
        return ( nil );
    }
    
    NSArray * result = WrappedArrayOfRecords( sources, [ABSource class] );
    [sources release];
    
    return ( result );
}

@end
