//
//  Communicator_GetCover.m
//  yuanqutong
//
//  Created by elvis on 2013/05/20.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_GetCover.h"
#import "CoverImage.h"
@implementation Communicator_GetCover

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    if (errNo == NO_ERROR) {
        
        CoverImage* image = [[CoverImage alloc] initWithDict:[[[result objectForKey:XML_BODY_NAME] objectForKey:WT_GET_ALBUM_COVER] objectForKey:@"album_cover"]];
        [Database storeCoverImage:image];
        [image release];
                        
        
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
