/*
 * ABRefInitialization.h
 * iPhoneContacts
 */

#import <CoreFoundation/CoreFoundation.h>

@protocol ABRefInitialization <NSObject>
+ (id) alloc;       // this keeps the compiler happy
- (id) initWithABRef: (CFTypeRef) ref;
@end
