//
//  AddressBookManager.m
//  omim
//
//  Created by coca on 2013/04/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "AddressBookManager.h"
#import "WTHeader.h"

@implementation AddressBookManager

@synthesize localcontacts = _localcontacts;

static AddressBookManager* myInstance = nil;

+(AddressBookManager*) defaultManager
{
    // check to see if an instance already exists
    if (nil == myInstance ) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}


-(NSArray*)localcontacts
{
    [self setLocalcontacts:[[ABAddressBook sharedAddressBook] allPeopleSorted]];
    return _localcontacts;
}

-(void)setLocalcontacts:(NSArray *)localcontacts
{
    _localcontacts = localcontacts;
    [_localcontacts retain];
}

-(NSMutableArray*)allNumbersInContactBook
{
    NSMutableArray* tmp = [[[NSMutableArray alloc] init] autorelease];
    
    for (ABPerson* aPerson in _localcontacts)
    {
        NSArray* arrPhone = [AddressBookManager multiFieldByRecord:[aPerson getRecordRef] byPropertyId:kABPersonPhoneProperty needLabel:NO];
        for(NSString* phoneNumber in arrPhone){
            if (phoneNumber==nil) {
                continue;
            }
            [tmp addObject:phoneNumber];
        }
    }
    return tmp;
}


+(NSArray*)phoneNumbersOfPerson:(ABPerson*)aPerson WithLabel:(BOOL)needLabel
{
     NSArray* arrPhone = [AddressBookManager multiFieldByRecord:[aPerson getRecordRef] byPropertyId:kABPersonPhoneProperty needLabel:needLabel];
     return arrPhone;
}

+(NSArray*)emailsOfPerson:(ABPerson*)aPerson WithLabel:(BOOL)needLabel
{
    NSArray* arrEmails = [AddressBookManager multiFieldByRecord:[aPerson getRecordRef] byPropertyId:kABPersonEmailProperty needLabel:needLabel];
    return arrEmails;
    
}
+(ABPerson*)personWithNumber:(NSString*)number
{
    NSMutableArray* tempcontacts = [NSMutableArray arrayWithArray:[AddressBookManager defaultManager].localcontacts];
    // add all the numbers.
    for (ABPerson* person in tempcontacts) {
        NSArray* numbers = [AddressBookManager phoneNumbersOfPerson:person WithLabel:NO];
        if (numbers == nil) {
            continue;
        }
        if ([numbers count] == 1) {
            person.phonenumber = [numbers objectAtIndex:0];
            if ([number isEqualToString:[WTHelper translatePhoneNumberToGlobalNumber:person.phonenumber]]) {
                return person;
            }
        }
        else{
            for(NSString* number in numbers) {
                if ([number isEqualToString:[WTHelper translatePhoneNumberToGlobalNumber:person.phonenumber]]) {
                    return person;
                }
            }
        }
    }
    return nil;
}

+(NSArray*) multiFieldByRecord:(ABRecordRef)record byPropertyId:(ABPropertyID)propertyId needLabel:(BOOL)needLabel
{
	if (!record)
	{
		return nil;
	}
    ABMutableMultiValueRef values = ABRecordCopyValue(record, propertyId);
	NSMutableArray* result=nil;
	if (values)
	{
        int count = ABMultiValueGetCount(values);
		if (count>0) {
			result = [[[NSMutableArray alloc]init] autorelease];
			
		}
        for (CFIndex i = 0; i < count; i++)
		{
			NSString *value = (NSString *)ABMultiValueCopyValueAtIndex(values, i);
			if (needLabel)
			{
				CFStringRef sysLabel = ABMultiValueCopyLabelAtIndex(values, i);
				CFStringRef labelRef= ABPersonCopyLocalizedPropertyName(propertyId);
				NSString *label = [NSString stringWithString:(NSString*)labelRef];
				if(sysLabel)
				{
					CFRelease(labelRef);
					labelRef = ABAddressBookCopyLocalizedLabel(sysLabel);
					label = [NSString stringWithString:(NSString*)labelRef];
					CFRelease(sysLabel);
				}
				CFRelease(labelRef);
				
				[result addObject:[NSArray arrayWithObjects:label,value,nil]];
			}
			else
			{
				[result addObject:value];
				
			}
			[value release];
		}
		CFRelease(values);
    }
	return result;
}


-(void)dealloc
{
    [_localcontacts release];
    [super dealloc];
}

@end
