//
//  omimUpdater.h
//  omimLibrary
//
//  Created by Yi Chen on 9/17/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WowTalkUpdater : NSObject


+(BOOL) fUpdater_checkWhetherUIDNeedToUpdate;
/**
 * 
 * update old wowtalk  uid to uuid mode
 */
+ (void)fUpdater_updateUID_withNetworkIFDidFinishDelegate:(SEL)selector withObserver:(id)observer;

@end
