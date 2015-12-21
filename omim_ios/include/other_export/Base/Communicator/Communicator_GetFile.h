//
//  Communicator_GetFile.h
//  omimLibrary
//
//  Created by Yi Chen on 5/5/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "WowtalkXMLParser.h"
#import "WowtalkUIDelegates.h"

@interface Communicator_GetFile : NSObject
{
    ASIFormDataRequest *request;
    
	BOOL isInsideElement;
    
    NSData *xmlData;
	NSXMLParser *xmlParser;    
}

@property (retain, nonatomic) ASIFormDataRequest *request;
@property (assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign) id downloadProgressDelegate;

@property (assign) NSInteger tag;

- (id)fPost:(NSMutableArray *)postKeys withPostValue:(NSMutableArray *)postValues;

@end
