//
//  Communicator_UploadFile.h
//  omimLibrary
//
//  Created by Yi Chen on 5/5/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator.h"

@interface Communicator_UploadFile : Communicator
{
    ASIFormDataRequest *request;
    NSMutableString* strFileID;
}

@property (retain, nonatomic) ASIFormDataRequest *request;
@property(assign) id uploadProgressDelegate;
@property (nonatomic,retain) NSMutableString* strFileID;

- (id)fUploadFile:(NSString*)filePath withPostKeys:(NSMutableArray*)postKeys andPostValue:(NSMutableArray*)postValues;

@end
