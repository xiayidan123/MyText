//
//  NetworkConnector.h
//  omim
//
//  Created by Coca on 7/5/11.
//  Copyright 2011 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIActivityAlertView.h"
#import "ASIFormDataRequest.h"
#import "WowtalkUIDelegates.h"

@interface NetworkConnector : NSObject {
    ASIFormDataRequest *request;

	//////////////////WEB SERVICE//////////////////////////
	//---web service access---
	NSData *xmlData;
    NSURLConnection *conn;
	
	//--error controll--
	BOOL connLock;
	
	NSXMLParser *xmlParser;

	//////////////////WEB SERVICE//////////////////////////
	
	id <NSXMLParserDelegate> xmlParserDelegate;
	UIActivityAlertView *activityAlert;
	NSString* strAlertViewTitle;
	NSString* strAlertViewMsg;


}
@property (retain, nonatomic) ASIFormDataRequest *request;
@property(assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;

@property (nonatomic, retain) id<NSXMLParserDelegate> xmlParserDelegate;
@property (copy) NSString* strAlertViewTitle;
@property (copy) NSString* strAlertViewMsg;

@property(assign) NSInteger tag;

-(void)fAbortXMLParser;
-(void)fPost:(NSMutableArray*)postKeys withPostValue:(NSMutableArray*)postValues;

@end
