//
//  OMBaseCellFrameModel.m
//  dev01
//
//  Created by 杨彬 on 15/2/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBaseCellFrameModel.h"

#define OriginalHeight 44

@implementation OMBaseCellFrameModel

-(void)dealloc{
    [_cellModel release],_cellModel = nil;
    [super dealloc];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellHeight = OriginalHeight;
        _isOpen = NO;
    }
    return self;
}

+ (instancetype)OMBaseCellFrameModel:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDict:dic] autorelease];
}


- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.cellModel = [OMBaseCellModel OMBaseCellModelWithDic:dic];
    }
    return self;
}


/**
 *  cellModel set方法 利用cellModel算出cellHeight
 *
 *  @param cellModel
 */
-(void)setCellModel:(OMBaseCellModel *)cellModel{
    _cellModel = [cellModel retain];
    
    if (!_isOpen)return;// 收起的cell 不需要计算cellheight
    
    if  (_cellModel.type == OMBaseCellModelTypeDatePicker || _cellModel.type == OMBaseCellModelTypeTimePicker) {
        _cellHeight = OriginalHeight + 206;
    }
//#warning 其他情况也需要判断，实际运用总再添加
//    else if (){
//        
//    }
}



-(void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    if (isOpen){
        _cellHeight = OriginalHeight + 200;
    }else{
        _cellHeight = OriginalHeight;
    }
}


@end
