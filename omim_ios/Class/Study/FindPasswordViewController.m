//
//  FindPasswordViewController.m
//  dev01
//
//  Created by macbook air on 14-9-25.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()
{
    CGPoint _center;
    CGRect _upViewRect;
    CGFloat _distance;
}

@end

@implementation FindPasswordViewController


#pragma mark - Functions

- (void)fResignFirstResponder:(id)sender{
    [_tfEmail resignFirstResponder];
}



#pragma mark - View Handler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblLogo.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    _upView.userInteractionEnabled = YES;
    [_upView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fResignFirstResponder:)]];
    _center = _upView.center;
    _center = _upView.center;
    _upViewRect = _upView.frame;
    
    [_btnEnter setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
    [_btnEnter setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];
    _tfEmail.placeholder = NSLocalizedString(@"Please enter your email", nil);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [_tfEmail release];
    [_btnEnter release];
    [_upView release];
    [_btnBack release];
    [_lblLogo release];
    [super dealloc];
}

- (IBAction)enterClick:(id)sender {
}

- (IBAction)backClick:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark Keyboard

- (void) keyboardWillShow:(NSNotification *)note{
    float y = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat distance = _upViewRect.origin.y + _upViewRect.size.height - y;
    if (distance > 0 && (_upView.center.y == _center.y)){
        [UIView animateWithDuration:0.24 animations:^{
            _upView.center = CGPointMake(_center.x, _center.y - distance);
        }];
    }else if (distance > _distance){
        [UIView animateWithDuration:0.24 animations:^{
            _upView.center = CGPointMake(_center.x, _center.y - distance);
        }];
    }
    _distance = distance;
}

-(void) keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.24 animations:^{
        _upView.center = _center;
    }];
}
















@end
