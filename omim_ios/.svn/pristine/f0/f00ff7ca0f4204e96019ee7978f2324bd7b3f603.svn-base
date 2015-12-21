//
//  Communicator_GetAllFavoriteItems.m
//  dev01
//
//  Created by elvis on 2013/08/28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetAllFavoriteItems.h"

@implementation Communicator_GetAllFavoriteItems
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    
    if (errNo == NO_ERROR)
    {
        [Database deleteFavoritedBuddies];
        [Database deleteFavoritedGroups];
        
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        if (bodydict != nil && [bodydict objectForKey:WT_GET_FAVORITE_ITEMS] != nil){
            NSMutableDictionary *infodict = [bodydict objectForKey:WT_GET_FAVORITE_ITEMS];
            if ([[infodict objectForKey:@"item"] isKindOfClass:[NSMutableArray class]])
            {
                for (NSDictionary* dict in [infodict objectForKey:@"item"]) {
                    NSString* itemid = [dict objectForKey:@"item_id"];
                    NSString* type = [dict objectForKey:@"type"];
                    if ([type isEqualToString:@"1"]) {
                        [Database favoriteDepartment:itemid];
                    }
                    else
                        [Database favoriteBuddy:itemid];
                }
              //  [WTUserDefaults setEmail:[infodict objectForKey:XML_EMAIL_ADDRESS_KEY]];
            }
            else if([[infodict objectForKey:@"item"] isKindOfClass:[NSMutableDictionary class]]){
                NSDictionary* dict = [infodict objectForKey:@"item"];
                NSString* itemid = [dict objectForKey:@"item_id"];
                NSString* type = [dict objectForKey:@"type"];
                if ([type isEqualToString:@"1"]) {
                    [Database favoriteDepartment:itemid];
                }
                else
                    [Database favoriteBuddy:itemid];
            }
        }
    }
    
    
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
