//
//  OMBuddyDetailItem.m
//  dev01
//
//  Created by Starmoon on 15/7/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBuddyDetailItem.h"

#import "NSString+TextSize.h"

@implementation OMBuddyDetailItem

-(void)dealloc{
    self.title = nil;
    self.content = nil;
    self.moment = nil;
    self.moment_media_array = nil;
    [super dealloc];
}

#pragma mark - Set and Get

-(void)setContent:(NSString *)content{
    [_content release],_content = nil;
    _content = [content retain];
    
    CGFloat height = [_content sizeWithFont:OMBuddyDetailItem_TextFont maxW:OMBuddyDetailItem_MaxWidth].height;
    
    if (_content.length == 0){
        self.cell_height = 0;
    }else{
        self.cell_height = height + 28;
    }
}


-(void)setMoment:(Moment *)moment{
    [_moment release],_moment = nil;
    _moment = [moment retain];
    
    
    
    
}



@end
