//
//  Communicator_SearchOfficialAccount.h
//  dev01
//
//  Created by jianxd on 14-5-26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator.h"

@protocol SearchDelegate <NSObject>

@optional
- (void)didFinishSearchWithResult:(NSMutableArray *)results;

@end

@interface Communicator_SearchOfficialAccount : Communicator
@property (nonatomic, getter = isFuzzySearch) BOOL fuzzySearch;
@property (nonatomic, assign) id<SearchDelegate> searchDelegate;
@end
