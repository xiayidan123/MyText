//
//  YBPulldownItem.m
//  YBPulldownView
//
//  Created by Starmoon on 15/7/15.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "OMPulldownItem.h"

@implementation OMPulldownItem


-(NSMutableArray *)subitems{
    if (_subitems == nil){
        _subitems = [[NSMutableArray alloc]init];
    }
    return _subitems;
}

+ (instancetype)itemWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.item_title = dic[@"item_title"];
        NSArray *subItems = dic[@"subItem"];
        
        NSUInteger count = subItems.count;
        for (int i=0; i<count; i++) {
            OMPulldownSubItem *subItem = [[OMPulldownSubItem alloc]init];
            subItem.title = subItems[i];
            if (i == 0){
                subItem.seleted = YES;
            }
            [self.subitems addObject:subItem];
        }
    }
    return self;
}


@end
