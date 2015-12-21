//
//  YBPulldownItemCell.m
//  YBPulldownView
//
//  Created by Starmoon on 15/7/15.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "OMPulldownItemCell.h"

@interface OMPulldownItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *title_label;

@property (weak, nonatomic) IBOutlet UIImageView *seleted_imageView;


@end


@implementation OMPulldownItemCell


-(void)setSubItem:(OMPulldownSubItem *)subItem{
    _subItem = subItem;
    
    self.title_label.text = _subItem.title;
    
    if (_subItem.seleted ){
        self.seleted_imageView.image = [UIImage imageNamed:@"share_category_select.png"];
    }else{
        self.seleted_imageView.image = nil;
    }
    
}

//-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
//    [super setSelected:selected animated:animated];
//    
//    if (selected ){
//        self.seleted_imageView.image = [UIImage imageNamed:@"share_category_select.png"];
//    }else{
//        self.seleted_imageView.image = nil;
//    }
//}



@end
