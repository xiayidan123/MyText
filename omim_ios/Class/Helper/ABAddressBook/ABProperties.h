/*
 * ABProperties.h
 * iPhoneContacts
 */

#import <AddressBook/AddressBook.h>

// macros to avoid copious type-casts when using ObjC wrappers


#define ABPersonFirstNameProperty			kABPersonFirstNameProperty
#define ABPersonLastNameProperty			kABPersonLastNameProperty
#define ABPersonMiddleNameProperty			kABPersonMiddleNameProperty
#define ABPersonPrefixProperty				kABPersonPrefixProperty
#define ABPersonSuffixProperty				kABPersonSuffixProperty
#define ABPersonNicknameProperty			kABPersonNicknameProperty
#define ABPersonFirstNamePhoneticProperty	kABPersonFirstNamePhoneticProperty
#define ABPersonLastNamePhoneticProperty	kABPersonLastNamePhoneticProperty
#define ABPersonMiddleNamePhoneticProperty	kABPersonMiddleNamePhoneticProperty
#define ABPersonOrganizationProperty		kABPersonOrganizationProperty
#define ABPersonJobTitleProperty			kABPersonJobTitleProperty
#define ABPersonDepartmentProperty			kABPersonDepartmentProperty
#define ABPersonEmailProperty				kABPersonEmailProperty
#define ABPersonBirthdayProperty			kABPersonBirthdayProperty
#define ABPersonNoteProperty				kABPersonNoteProperty
#define ABPersonCreationDateProperty		kABPersonCreationDateProperty
#define ABPersonModificationDateProperty	kABPersonModificationDateProperty

// Generic labels
#define ABWorkLabel     (NSString *) kABWorkLabel
#define ABHomeLabel     (NSString *) kABHomeLabel
#define ABOtherLabel    (NSString *) kABOtherLabel

// Addresses
#define ABPersonAddressStreetKey        (NSString *) kABPersonAddressStreetKey
#define ABPersonAddressCityKey          (NSString *) kABPersonAddressCityKey
#define ABPersonAddressStateKey         (NSString *) kABPersonAddressStateKey
#define ABPersonAddressZIPKey           (NSString *) kABPersonAddressZIPKey
#define ABPersonAddressCountryKey       (NSString *) kABPersonAddressCountryKey
#define ABPersonAddressCountryCodeKey   (NSString *) kABPersonAddressCountryCodeKey

// Dates
#define ABPersonAnniversaryLabel        (NSString *) kABPersonAnniversaryLabel

// Kind
#define ABPersonKindPerson              (NSNumber *) kABPersonKindPerson
#define ABPersonKindOrganization        (NSNumber *) kABPersonKindOrganization

// Phone Numbers
#define ABPersonPhoneMobileLabel        (NSString *) kABPersonPhoneMobileLabel
#define ABPersonPhoneIPhoneLabel        (NSString *) kABPersonPhoneIPhoneLabel
#define ABPersonPhoneMainLabel          (NSString *) kABPersonPhoneMainLabel
#define ABPersonPhoneHomeFAXLabel       (NSString *) kABPersonPhoneHomeFAXLabel
#define ABPersonPhoneWorkFAXLabel       (NSString *) kABPersonPhoneWorkFAXLabel
#define ABPersonPhonePagerLabel         (NSString *) kABPersonPhonePagerLabel

// IM
#define ABPersonInstantMessageServiceKey    (NSString *) kABPersonInstantMessageServiceKey
#define ABPersonInstantMessageServiceYahoo  (NSString *) kABPersonInstantMessageServiceYahoo
#define ABPersonInstantMessageServiceJabber (NSString *) kABPersonInstantMessageServiceJabber
#define ABPersonInstantMessageServiceMSN    (NSString *) kABPersonInstantMessageServiceMSN
#define ABPersonInstantMessageServiceICQ    (NSString *) kABPersonInstantMessageServiceICQ
#define ABPersonInstantMessageServiceAIM    (NSString *) kABPersonInstantMessageServiceAIM
#define ABPersonInstantMessageUsernameKey   (NSString *) kABPersonInstantMessageUsernameKey

// URLs
#define ABPersonHomePageLabel           (NSString *) kABPersonHomePageLabel

// Related Names
#define ABPersonFatherLabel             (NSString *) kABPersonFatherLabel
#define ABPersonMotherLabel             (NSString *) kABPersonMotherLabel
#define ABPersonParentLabel             (NSString *) kABPersonParentLabel
#define ABPersonBrotherLabel            (NSString *) kABPersonBrotherLabel
#define ABPersonSisterLabel             (NSString *) kABPersonSisterLabel
#define ABPersonChildLabel              (NSString *) kABPersonChildLabel
#define ABPersonFriendLabel             (NSString *) kABPersonFriendLabel
#define ABPersonSpouseLabel             (NSString *) kABPersonSpouseLabel
#define ABPersonPartnerLabel            (NSString *) kABPersonPartnerLabel
#define ABPersonAssistantLabel          (NSString *) kABPersonAssistantLabel
#define ABPersonManagerLabel            (NSString *) kABPersonManagerLabel
