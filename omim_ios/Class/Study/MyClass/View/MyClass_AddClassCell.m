//
//  MyClass_AddClassCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MyClass_AddClassCell.h"


@interface MyClass_AddClassCell ()


@property (retain, nonatomic) IBOutlet UIImageView *imageView_title;

@property (retain, nonatomic) IBOutlet UILabel *title_label;


@end


@implementation MyClass_AddClassCell

- (void)dealloc {
    [_imageView_title release];
    [_title_label release];
    [super dealloc];
}


+ (instancetype)myClass_AddClassCell{
    
    MyClass_AddClassCell *addClassView = [[[NSBundle mainBundle]loadNibNamed:@"MyClass_AddClassCell" owner:nil options:nil]lastObject];
    addClassView.backgroundColor = [UIColor clearColor];
    
    return addClassView;
}

-(void)awakeFromNib{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}




- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    self.imageView_title.image = [UIImage imageNamed:@"icon_myclass_leftpage_addclass_pre"];
    self.title_label.textColor = [UIColor colorWithRed:0 green:0.67 blue:0.92 alpha:1];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        self.imageView_title.image = [UIImage imageNamed:@"icon_myclass_leftpage_addclass"];
        self.title_label.textColor = [UIColor blackColor];
    });
    
    if ([self.delegate respondsToSelector:@selector(didSelectedMyClass_addClassCell:)]){
        [self.delegate didSelectedMyClass_addClassCell:self];
    }
}







@end
