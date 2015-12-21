//
//  Communicator_RemoveCover.m
//  suzhou
//
//  Created by coca on 14-2-24.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_RemoveCover.h"

@implementation Communicator_RemoveCover
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
        
        self.image.coverNotSet = TRUE;
        self.image.timestamp=@"-1";
        self.image.needDownload = NO;
        self.image.file_id = nil;
        [Database storeCoverImage:self.image];
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
