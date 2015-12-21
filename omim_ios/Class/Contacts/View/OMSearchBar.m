//
//  OMSearchBar.m
//  dev01
//
//  Created by Starmoon on 15/7/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMSearchBar.h"


@interface OMSearchBar ()<UITextFieldDelegate>


@property (assign, nonatomic) id <OMSearchBarDelegate> om_delegate;


@end

@implementation OMSearchBar

-(void)dealloc{
    self.button_title = nil;
    [super dealloc];
}


-(void)setDelegate:(id<UISearchBarDelegate,OMSearchBarDelegate>)delegate{
    [super setDelegate:delegate];
    
    self.om_delegate = delegate;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *sub_view in [[self.subviews lastObject] subviews] ) {
        if ([sub_view isKindOfClass:[UIButton class]] ) {
            UIButton *cancel_button = (UIButton *)sub_view;
            [cancel_button setTitle:self.button_title forState:UIControlStateNormal];
            [cancel_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cancel_button.titleLabel.font =[UIFont systemFontOfSize:14];
        }else if ([sub_view isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)sub_view;
            textField.delegate = self;
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    if ([self.om_delegate respondsToSelector:@selector(searchBarShouldReturn:)]){
        [self.om_delegate searchBarShouldReturn:self];
    }
    return YES;
}


@end
