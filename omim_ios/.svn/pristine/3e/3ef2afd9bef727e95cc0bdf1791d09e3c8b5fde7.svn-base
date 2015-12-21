//
//  Communicator_BlidingEmail.m
//  dev01
//
//  Created by Huan on 15/3/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_BlidingEmail.h"
#import "EmailStatus.h"

@interface Communicator_BlidingEmail ()

@property (retain, nonatomic)EmailStatus *emailStatus;

@end

@implementation Communicator_BlidingEmail

-(void)dealloc{
    [_emailStatus release];
    [super dealloc];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    [self parseResult:result];
    
    [self networkTaskDidFinishWithReturningData:self.emailStatus error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
}
- (void)parseResult:(NSMutableDictionary *)result
{
    self.emailStatus = [[[EmailStatus alloc] init] autorelease];
    NSDictionary *bodyDic = result[@"body"];
    NSDictionary *Status = bodyDic[@"email_binding_status"];
    self.emailStatus.email = Status[@"email"];
    self.emailStatus.verified = Status[@"verified"];
}
@end
