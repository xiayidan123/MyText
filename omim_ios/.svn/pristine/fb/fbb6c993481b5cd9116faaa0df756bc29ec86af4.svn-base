/*
 * ABPerson.h
 * iPhoneContacts
 */

#import <Foundation/Foundation.h>
#import <AddressBook/ABPerson.h>
#import "ABRecord.h"

@interface ABPerson : ABRecord

@property (nonatomic,retain) NSString* sortName;
@property  int sectionNumber;
@property (nonatomic,retain) NSString* phonenumber;

// use -init to create a new person

+ (ABPropertyType) typeOfProperty: (ABPropertyID) property;
+ (NSString *) localizedNameOfProperty: (ABPropertyID) property;
+ (ABPersonSortOrdering) sortOrdering;
+ (ABPersonCompositeNameFormat) compositeNameFormat;

- (BOOL) setImageData: (NSData *) imageData error: (NSError **) error;
- (NSData *) imageData;
- (NSData *) thumbnailImage;

@property (nonatomic, readonly) BOOL hasImageData;
- (BOOL) removeImageData: (NSError **) error;

- (NSComparisonResult) compare: (ABPerson *) otherPerson;
- (NSComparisonResult) compare: (ABPerson *) otherPerson sortOrdering: (ABPersonSortOrdering) order;

@end
