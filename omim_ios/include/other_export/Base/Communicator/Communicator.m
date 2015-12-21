//
//  Communicator.m
//  omim
//
//  Created by Harry on 12-12-10.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "Communicator.h"

@interface Communicator()

@property (nonatomic, retain) NSMutableArray *arrayNetworkConnectors;

@end

@implementation Communicator

@synthesize delegate;
@synthesize tag;

@synthesize arrayNetworkConnectors = _arrayNetworkConnectors;

-(void)fPost:(NSMutableArray *)postKeys withPostValue:(NSMutableArray *)postValues
{
  //  [self retain];  // test elvis.
    xmlParser = [[WowtalkXMLParser alloc] init];
    xmlParser.delegate = self;
    
	networkConnector = [[NetworkConnector alloc] init];
	networkConnector.strAlertViewTitle = NSLocalizedString(@"Loading...",nil);
	networkConnector.strAlertViewMsg = NSLocalizedString(@"Please wait for a while..",nil);
    networkConnector.didFinishDelegate = self;
    networkConnector.xmlParserDelegate = xmlParser;
    
	[networkConnector fPost:postKeys withPostValue:postValues];
    
    [_arrayNetworkConnectors addObject:networkConnector];
    
    [networkConnector release];
    //[xmlParser release];
}

#pragma mark -
#pragma mark Initialize
- (id)init
{
    self = [super init];
    if (self)
    {
        self.arrayNetworkConnectors = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [self.arrayNetworkConnectors removeAllObjects];
    self.arrayNetworkConnectors = nil;
    
    [xmlParser release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Network Delegate
- (void)networkTaskDidFinishWithReturningData:(NSObject *)data error:(NSError *)error
{
    if (self.delegate){
        if([self.delegate respondsToSelector:@selector(networkTaskDidFinishWithReturningData:error:)]){
            [self.delegate networkTaskDidFinishWithReturningData:data error:error];
        }
    }

    networkConnector.xmlParserDelegate = nil;
    
    [self autorelease];
}

- (void)networkTaskDidFailWithReturningData:(NSObject *)data error:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(networkTaskDidFailWithReturningData:error:)])
        [self.delegate networkTaskDidFailWithReturningData:data error:error];
    
    networkConnector.xmlParserDelegate = nil;
    [self autorelease];
}
// deprecated below.
-(void)didFailNetworkIFCommunicationWithTag:(int)tag withData:(NSObject *)data
{
    
}
-(void)didFinishNetworkIFCommunicationWithTag:(int)tag withData:(NSObject *)data
{
}

@end
