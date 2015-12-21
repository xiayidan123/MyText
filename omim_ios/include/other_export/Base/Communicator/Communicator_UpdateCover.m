//
//  Communicator_UpdateCover.m
//  yuanqutong
//
//  Created by elvis on 2013/05/20.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_UpdateCover.h"

@implementation Communicator_UpdateCover

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    if (errNo == NO_ERROR) {
        
        if (![NSString isEmptyString:self.image.previousfile_id] ) {
            
            [NSFileManager removeFileAtAbsoulutePath:[NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:self.image.previousfile_id WithSubFolder:SDK_MOMENT_MEDIA_DIR withExtention:@"png"]]];
        }
        
        [Database storeCoverImage:self.image];
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
