//
//  OMTableViewHeadView.m
//  dev01
//
//  Created by 杨彬 on 15/3/26.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMTableViewHeadView.h"



@interface OMTableViewHeadView ()

@property (retain, nonatomic) IBOutlet UILabel *title_label;



@end

@implementation OMTableViewHeadView

- (void)dealloc {
    [_title release];
    [_title_label release];
    [super dealloc];
}

+ (instancetype)omTableViewHeadViewWithTitle:(NSString *)title{
    OMTableViewHeadView *headView = [[[NSBundle mainBundle]loadNibNamed:@"OMTableViewHeadView" owner:nil options:nil] lastObject];
    headView.title = title;
    return headView;
}

-(void)setTitle:(NSString *)title{
    [_title release],_title = nil;
    _title = [title retain];
    
    
    self.title_label.text = title;
    
}


@end
