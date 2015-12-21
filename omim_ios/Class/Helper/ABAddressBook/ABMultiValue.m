/*
 * ABMultiValue.m
 * iPhoneContacts
 */

#import "ABMultiValue.h"

@implementation ABMultiValue

@synthesize multiValueRef=_ref;

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
    
    _ref = (ABMultiValueRef) CFRetain(ref);
    
    return ( self );
}

- (void) dealloc
{
    if ( _ref != NULL )
        CFRelease( _ref );
    [super dealloc];
}

- (id) copyWithZone: (NSZone *) zone
{
    return ( [self retain] );
}

- (id) mutableCopyWithZone: (NSZone *) zone
{
    ABMultiValueRef ref = ABMultiValueCreateMutableCopy( _ref );
    ABMutableMultiValue * result = [[ABMutableMultiValue allocWithZone: zone] initWithABRef: (CFTypeRef)ref];
    CFRelease( ref );
    return ( result );
}

- (ABPropertyType) propertyType
{
    return ( ABMultiValueGetPropertyType(_ref) );
}

- (NSUInteger) count
{
    return ( (NSUInteger) ABMultiValueGetCount(_ref) );
}

- (id) valueAtIndex: (NSUInteger) index
{
    id value = (id) ABMultiValueCopyValueAtIndex( _ref, (CFIndex)index );
    return ( [value autorelease] );
}

- (NSArray *) allValues
{
    NSArray * array = (NSArray *) ABMultiValueCopyArrayOfAllValues( _ref );
    return ( [array autorelease] );
}

- (NSString *) labelAtIndex: (NSUInteger) index
{
    NSString * result = (NSString *) ABMultiValueCopyLabelAtIndex( _ref, (CFIndex)index );
    return ( [result autorelease] );
}

- (NSString *) localizedLabelAtIndex: (NSUInteger) index
{
    NSString * result = (NSString *) ABAddressBookCopyLocalizedLabel((CFStringRef)[self labelAtIndex: index] );
    return ( [result autorelease] );
}

- (NSUInteger) indexForIdentifier: (ABMultiValueIdentifier) identifier
{
    return ( (NSUInteger) ABMultiValueGetIndexForIdentifier(_ref, identifier) );
}

- (ABMultiValueIdentifier) identifierAtIndex: (NSUInteger) index
{
    return ( ABMultiValueGetIdentifierAtIndex(_ref, (CFIndex)index) );
}

- (NSUInteger) indexOfValue: (id) value
{
    return ( (NSUInteger) ABMultiValueGetFirstIndexOfValue(_ref, (CFTypeRef)value) );
}

@end

#pragma mark -

@implementation ABMutableMultiValue

- (id) initWithPropertyType: (ABPropertyType) type
{
    ABMutableMultiValueRef ref = ABMultiValueCreateMutable(type);
    
    if ( ref == NULL )
    {
        [self release];
        return ( nil );
    }
    
    id result = [self initWithABRef: (CFTypeRef)ref];
   
    CFRelease(ref);
    return result;
}

- (id) copyWithZone: (NSZone *) zone
{
    // no AB method to create an immutable copy, so we do a mutable copy but wrap it in an immutable class
    CFTypeRef _obj = ABMultiValueCreateMutableCopy(_ref);
    ABMultiValue * result = [[ABMultiValue allocWithZone: zone] initWithABRef: _obj];
    CFRelease( _obj );
    return ( result );
}

- (ABMutableMultiValueRef) _mutableRef
{
    return ( (ABMutableMultiValueRef)_ref );
}

- (BOOL) addValue: (id) value
        withLabel: (NSString *) label
       identifier: (ABMultiValueIdentifier *) outIdentifier
{
    return ( (BOOL) ABMultiValueAddValueAndLabel([self _mutableRef], (CFTypeRef)value, (CFStringRef)label, outIdentifier) );
}

- (BOOL) insertValue: (id) value
           withLabel: (NSString *) label
             atIndex: (NSUInteger) index
          identifier: (ABMultiValueIdentifier *) outIdentifier
{
    return ( (BOOL) ABMultiValueInsertValueAndLabelAtIndex([self _mutableRef], (CFTypeRef)value, (CFStringRef)label, (CFIndex)index, outIdentifier) );
}

- (BOOL) addMultiValue: (ABMultiValue *)multivalue 
{  
    for(int i=0;i < [multivalue count];i++) {
        [self addValue: [multivalue valueAtIndex:i] withLabel:[multivalue labelAtIndex: i] identifier: nil];
    }
    return YES;
}


- (BOOL) removeValueAndLabelAtIndex: (NSUInteger) index
{
    return ( (BOOL) ABMultiValueRemoveValueAndLabelAtIndex([self _mutableRef], (CFIndex)index) );
}

- (BOOL) replaceValueAtIndex: (NSUInteger) index withValue: (id) value
{
    return ( (BOOL) ABMultiValueReplaceValueAtIndex([self _mutableRef], (CFTypeRef)value, (CFIndex)index) );
}

- (BOOL) replaceLabelAtIndex: (NSUInteger) index withLabel: (NSString *) label
{
    return ( (BOOL) ABMultiValueReplaceLabelAtIndex([self _mutableRef], (CFStringRef)label, (CFIndex)index) );
}

- (NSString*) description {
    return [NSString stringWithFormat: @"ABMultiValue with %lu elements",(unsigned long)[self count]];
}

@end
