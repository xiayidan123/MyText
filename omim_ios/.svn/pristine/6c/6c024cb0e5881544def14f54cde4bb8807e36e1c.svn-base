//
//  MyClassFunctionButtonCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MyClassFunctionButtonCell.h"
#import "MyClassFunctionButtonModel.h"



@interface MyClassFunctionButtonCell ()

@property (retain, nonatomic) IBOutlet UIButton *function_button;

@end


@implementation MyClassFunctionButtonCell

- (void)dealloc {
    [_buttonModel release];

    [_function_button release];
    [super dealloc];
}

- (IBAction)functionAction {
    self.selected = YES;
    
}

-(void)setSelected:(BOOL)selected{
    if (selected){
        
    }
}


-(void)setButtonModel:(MyClassFunctionButtonModel *)buttonModel{
    [_buttonModel release],_buttonModel = nil;
    _buttonModel = [buttonModel retain];
    
    [self.function_button setImage:[UIImage imageNamed:buttonModel.imageName] forState:UIControlStateNormal];
    [self.function_button setImage:[UIImage imageNamed:buttonModel.imageName_pre] forState:UIControlStateHighlighted];
    
    [self.function_button setTitle:_buttonModel.title forState:UIControlStateNormal];
    
}




- (void)awakeFromNib {
    self.function_button.userInteractionEnabled = NO;
}


@end
