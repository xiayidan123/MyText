//
//  OMSaveImageRemindView.m
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMSaveImageRemindView.h"


@interface OMSaveImageRemindView ()

@property (retain, nonatomic) IBOutlet UIImageView *remind_imageView;
@property (retain, nonatomic) IBOutlet UILabel *remind_label;
@end

@implementation OMSaveImageRemindView


- (void)dealloc {
    [_title release];
    [_remind_label release];
    [_remind_imageView release];
    [super dealloc];
}



+ (instancetype)OMSaveImageRemindView{
    OMSaveImageRemindView *saveImageRemindView = [[[NSBundle mainBundle]loadNibNamed:@"OMSaveImageRemindView" owner:self options:nil] lastObject];
    saveImageRemindView.layer.masksToBounds = YES;
    saveImageRemindView.layer.cornerRadius = 8;
    return saveImageRemindView;
}


- (void)showInSuperView:(UIView *)superView{
    self.center = CGPointMake(superView.bounds.size.width/2, superView.bounds.size.height /5);
    [superView addSubview:self];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(hiddenOMSaveImageRemindView:)]){
            [self.delegate hiddenOMSaveImageRemindView:self];
        }
        [self removeFromSuperview];
    });
    
    
}


-(void)setTitle:(NSString *)title{
    [_title release],_title = nil;
    
    _title = [title copy];
    
    self.remind_label.text = title;
}

@end
