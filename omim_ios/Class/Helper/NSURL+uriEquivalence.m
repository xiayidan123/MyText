//
//  NSURL+uriEquivalence.m
//  omimbiz
//
//  Created by elvis on 2013/07/31.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "NSURL+uriEquivalence.h"

@implementation NSURL (uriEquivalence)

- (BOOL)isEquivalent:(NSURL *)aURL {
    
    if ([self isEqual:aURL]) return YES;
    if ([[self scheme] caseInsensitiveCompare:[aURL scheme]] != NSOrderedSame) return NO;
    if ([[self host] caseInsensitiveCompare:[aURL host]] != NSOrderedSame) return NO;
    
    // NSURL path is smart about trimming trailing slashes
    // note case-sensitivty here
    if ([[self path] compare:[aURL path]] != NSOrderedSame) return NO;
    
    // at this point, we've established that the urls are equivalent according to the rfc
    // insofar as scheme, host, and paths match
    
    // according to rfc2616, port's can weakly match if one is missing and the
    // other is default for the scheme, but for now, let's insist on an explicit match
    if ([[self port] compare:[aURL port]] != NSOrderedSame) return NO;
    
    if ([[self query] compare:[aURL query]] != NSOrderedSame) return NO;
    
    // for things like user/pw, fragment, etc., seems sensible to be
    // permissive about these.  (plus, I'm tired :-))
    return YES;
}

@end
