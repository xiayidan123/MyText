//
//  AddShoolViewController.m
//  dev01
//
//  Created by macbook air on 14-9-25.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "AddShoolViewController.h"

@interface AddShoolViewController ()

@end

@implementation AddShoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _inputView.layer.borderWidth = 1;
    _inputView.layer.cornerRadius = 5;
    _inputView.layer.masksToBounds = YES;
    _inputView.layer.borderColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1].CGColor;
    [_btnAdd setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
#warning 国际化适配
//    _tfCode.placeholder = NSLocalizedString(@"", nil);
    [_btnAdd setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_inputView release];
    [_tfCode release];
    [_btnAdd release];
    [super dealloc];
}
- (IBAction)addClick:(id)sender {
#warning 测试
    [self.navigationController popViewControllerAnimated:YES];
}



@end
