//
//  Communicator.h
//  omim
//
//  Created by Harry on 12-12-10.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WowtalkXMLParser.h"
#import "NetworkConnector.h"
#import "WowtalkUIDelegates.h"
#import "WTHeader.h"
#import "XMLConstant.h"


@interface Communicator : NSObject<WowtalkXMLParserDelegate, NetworkIFDidFinishDelegate>
{
    NetworkConnector *networkConnector;
    WowtalkXMLParser *xmlParser;
    
    id<NetworkIFDidFinishDelegate> delegate;
    NSInteger tag;
}

@property (assign) id<NetworkIFDidFinishDelegate> delegate;
@property (assign) NSInteger tag;

- (void)fPost:(NSMutableArray *)postKeys withPostValue:(NSMutableArray *)postValues;

@end
