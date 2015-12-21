/*
 * ABPerson.m
 * iPhoneContacts
 */

#import "ABPerson.h"
@implementation ABPerson
@synthesize sectionNumber,sortName;

+ (ABPropertyType) typeOfProperty: (ABPropertyID) property
{
    return ( ABPersonGetTypeOfProperty(property) );
}

+ (NSString *) localizedNameOfProperty: (ABPropertyID) property
{
    NSString * name = (NSString *) ABPersonCopyLocalizedPropertyName(property);
    return ( [name autorelease] );
}

+ (ABPersonSortOrdering) sortOrdering
{
    return ( ABPersonGetSortOrdering() );
}

+ (ABPersonCompositeNameFormat) compositeNameFormat
{
    return ( ABPersonGetCompositeNameFormat() );
}

- (id) init
{
    ABRecordRef person = ABPersonCreate();
    if ( person == NULL )
    {
        [self release];
        return ( nil );
    }
    id result = [super init];
    CFRelease(person);
    
    return result;
    
}

- (BOOL) setImageData: (NSData *) imageData error: (NSError **) error
{
    return ( (BOOL) ABPersonSetImageData(_ref, (CFDataRef)imageData, (CFErrorRef *)error) );
}

- (NSData *) imageData
{
	
	NSData* imageData1 = (NSData *) ABPersonCopyImageData( _ref );
    return ( [imageData1 autorelease] );


}

- (NSData *) thumbnailImage{
	NSString *reqSysVer = @"4.0";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	//if >= ios4.0
	if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){	
		NSData* imageData = (NSData *) ABPersonCopyImageDataWithFormat( _ref ,kABPersonImageFormatThumbnail);
		return ( [imageData autorelease] );
	}
	
	NSData* imageData1 = (NSData *) ABPersonCopyImageData( _ref );
    return ( [imageData1 autorelease] );
	
}


- (BOOL) hasImageData
{
    return ( (BOOL) ABPersonHasImageData(_ref) );
}

- (BOOL) removeImageData: (NSError **) error
{
    return ( (BOOL) ABPersonRemoveImageData(_ref, (CFErrorRef *)error) );
}

- (NSComparisonResult) compare: (ABPerson *) otherPerson
{
    return ( [self compare: otherPerson sortOrdering: ABPersonGetSortOrdering()] );
}

- (NSComparisonResult) compare: (ABPerson *) otherPerson sortOrdering: (ABPersonSortOrdering) order
{
    return ( (NSComparisonResult) ABPersonComparePeopleByName(_ref, otherPerson->_ref, order) );
}

@end
