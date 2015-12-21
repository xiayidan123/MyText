//
//  Communicator_SearchBuddy.h
//  wowcity
//
//  Created by elvis on 2013/06/06.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator.h"

@protocol FuzzySearchDelegate <NSObject>

- (void)didFinishFuzzySearchWithResult:(NSMutableArray *)result;

@end

@interface Communicator_SearchBuddy : Communicator

@property (nonatomic) BOOL isFuzzySearch;
@property (assign, nonatomic) id<FuzzySearchDelegate> fuzzySearchDelegate;

@end
