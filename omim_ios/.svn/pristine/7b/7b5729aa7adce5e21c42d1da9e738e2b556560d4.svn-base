//
//  Communicator_GetMomentsForGroup.m
//  dev01
//
//  Created by elvis on 2013/11/29.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_GetMomentsForGroup.h"

@interface Communicator_GetMomentsForGroup () {
    NSMutableArray *momentsFromServerArray;
}
@end

@implementation Communicator_GetMomentsForGroup

+(void) deleteMomentFromDbWhenLoadedFromServer:(NSMutableArray *)momentsFromServer compareAllMoments:(NSMutableArray *)allMoments withTimeStamp:(NSInteger)maxTimeStamp withTags:(NSArray *)momentTags
{
    int defaultMomentsFetchCount=20;
    [Communicator_GetMomentsForGroup deleteLocalMoment:maxTimeStamp withCount:defaultMomentsFetchCount withLocalMoments:allMoments withMomentsFromServer:momentsFromServer withTags:momentTags];
}

+(void) deleteLocalMoment:(long) maxTimestamp withCount:(int) count
         withLocalMoments:(NSArray *) localMomentList withMomentsFromServer: (NSArray *)momentFromServerList withTags:(NSArray *)momentTags{
    long maxTimeStampCheck=LONG_MIN;
    long minTimeStampCheck=LONG_MAX;
    if(nil==localMomentList || nil == momentFromServerList) {
        return;
    }
    
    NSMutableArray *momentInServerList=[[[NSMutableArray alloc] init] autorelease];
    long maxServerMomentTimestamp=-1;
    for(Moment *aMoment in momentFromServerList) {
        if(aMoment.timestamp > maxServerMomentTimestamp) {
            maxServerMomentTimestamp=aMoment.timestamp;
        }
    }
    
    if(maxTimestamp > 0) {
        for(Moment *aMoment in momentFromServerList) {
            if(aMoment.timestamp > maxTimeStampCheck) {
                maxTimeStampCheck=aMoment.timestamp;
            }
            
            for(Moment *aLocalMoment in localMomentList) {
                if(NSOrderedSame == [aMoment.moment_id compare:aLocalMoment.moment_id]) {
                    if(NSNotFound == [momentInServerList indexOfObject:aLocalMoment.moment_id]) {
                        [momentInServerList addObject:aLocalMoment.moment_id];
                    }
                    break;
                } else if ([Communicator_GetMomentsForGroup isMomentNewThanServerAndMine:aLocalMoment withTimeStamp:maxServerMomentTimestamp]) {
                    if(NSNotFound == [momentInServerList indexOfObject:aLocalMoment.moment_id]) {
                        [momentInServerList addObject:aLocalMoment.moment_id];
                    }
                }
            }
        }
        
        if(maxTimeStampCheck < maxTimestamp) {
            maxTimeStampCheck=maxTimestamp;
        }
        
        minTimeStampCheck=[Communicator_GetMomentsForGroup getMinTimeStamp:count withMoments:momentFromServerList];
    } else {
        maxTimeStampCheck=LONG_MAX;
        
        for(Moment *aMoment in momentFromServerList) {
            for(Moment *aLocalMoment in localMomentList) {
                if(NSOrderedSame == [aMoment.moment_id compare:aLocalMoment.moment_id]) {
                    if(NSNotFound == [momentInServerList indexOfObject:aLocalMoment.moment_id]) {
                        [momentInServerList addObject:aLocalMoment.moment_id];
                    }
                    break;
                } else if ([Communicator_GetMomentsForGroup isMomentNewThanServerAndMine:aLocalMoment withTimeStamp:maxServerMomentTimestamp]) {
                    //new created by me
                    if(NSNotFound == [momentInServerList indexOfObject:aLocalMoment.moment_id]) {
                        [momentInServerList addObject:aLocalMoment.moment_id];
                    }
                }
            }
        }
        
        minTimeStampCheck=[Communicator_GetMomentsForGroup getMinTimeStamp:count withMoments:momentFromServerList];
    }
//    Log.i("moment_web_server_if","delete local moment: \nminTimeStampCheck="+minTimeStampCheck+
//          "\nmaxTimeStampCheck="+maxTimeStampCheck);
//    NSLog(@"to delete moment,minTimeStampCheck: %ld,maxTimeStampCheck %ld",minTimeStampCheck,maxTimeStampCheck);
//    Database db = new Database(mContext);
    for(Moment *aMoment in localMomentList) {
//        NSLog(@"check moment %@,timestamp=%d,minCheck=%ld,maxCheck=%ld,found=%d",aMoment.moment_id,aMoment.timestamp,minTimeStampCheck,maxTimeStampCheck,[momentInServerList indexOfObject:aMoment.moment_id]);
        if(NSNotFound == [momentInServerList indexOfObject:aMoment.moment_id] &&
           aMoment.timestamp>minTimeStampCheck &&
           aMoment.timestamp<maxTimeStampCheck) {
//            Log.w("moment_web_server_if","moment with id "+aMoment.id+" deleted,timestamp "+aMoment.timestamp+",maxTimestam from server "+maxServerMomentTimestamp);
            BOOL canDel=true;
            if (nil != momentTags && ![momentTags containsObject:[NSNumber numberWithInt:aMoment.momentType]]) {
                canDel=false;
            }
            
            if (canDel) {
                NSLog(@"delete %@",aMoment.moment_id);
                [Database deleteMomentWithMomentID:aMoment.moment_id];
            }
        }
    }
}

+(BOOL) isMomentNewThanServerAndMine:(Moment *) aMoment withTimeStamp:(long) maxServerTimestamp  {
    NSString *uid = [WTUserDefaults getUid];
    if(aMoment.timestamp > maxServerTimestamp && NSOrderedSame == [uid compare:aMoment.owner.userID]) {
        return true;
    }
    
    return false;
}

+(long) getMinTimeStamp:(int) count withMoments:(NSArray *) momentFromServerList {
    long ret=LONG_MAX;
    
    if(momentFromServerList.count < count) {
        ret=LONG_MIN;
    } else {
        for(Moment *aMoment in momentFromServerList) {
            if(aMoment.timestamp < ret) {
                ret=aMoment.timestamp;
            }
        }
    }
    
    return ret;
}

-(void)handleMoment:(NSMutableDictionary*)momentDict
{
    if (nil == momentsFromServerArray) {
        momentsFromServerArray= [[[NSMutableArray alloc] init] autorelease];
    }
    
    Moment *moment = [[Moment alloc] initWithDict:momentDict];
    [momentsFromServerArray addObject:moment];
    [Database storeMoment:moment];
    [moment release];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
//        [Database deleteAllMoment];
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        
        NSMutableDictionary *infodict = [bodydict objectForKey:WT_GET_MOMENTS_FOR_GROUP];
        if ([[infodict objectForKey:XML_MOMENT_KEY] isKindOfClass:[NSMutableDictionary class]]) {
            NSMutableDictionary* momentDict = [infodict objectForKey:XML_MOMENT_KEY];
            [self handleMoment:momentDict];
        }
        else if ([[infodict objectForKey:XML_MOMENT_KEY] isKindOfClass:[NSMutableArray class]]){
            NSMutableArray *momentsArray = [infodict objectForKey:XML_MOMENT_KEY];
            
            for (NSMutableDictionary *momentDict in momentsArray){
                [self handleMoment:momentDict];
            }
        }
        
        NSMutableArray *momentsAll=[[[NSMutableArray alloc] init] autorelease];
        [momentsAll addObjectsFromArray: [Database fetchMomentsForAllBuddiesInGroup:self.gid WithLimit:LONG_MAX andOffset:0]];
        [Communicator_GetMomentsForGroup deleteMomentFromDbWhenLoadedFromServer:momentsFromServerArray compareAllMoments:momentsAll withTimeStamp:self.maxTimestamp withTags:self.momentTags];
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
