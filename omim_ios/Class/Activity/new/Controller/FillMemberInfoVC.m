//
//  FillMemberInfoVC.m
//  dev01
//
//  Created by 杨彬 on 14-11-9.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "FillMemberInfoVC.h"
#import "PublicFunctions.h"
#import "OMTelephoneTextField.h"

#import "WowTalkWebServerIF.h"
@interface FillMemberInfoVC ()
@property (assign, getter=isTelephoneCorrect,nonatomic) BOOL telephone_correct;

@end

@implementation FillMemberInfoVC

- (void)dealloc {
    [_tf_realName release];
    [_tf_telephoneNumber release];
    [_btn_enter release];
    [_applyMemberInfo release];
    [super dealloc];
}

#pragma mark------View Handle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.applyMemberInfo = [NSMutableDictionary dictionary];
    
    [self configNavigationBar];// 加载导航栏
    
    [self uiConfig];
}


- (void)configNavigationBar{
    
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"填写报名信息",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
    
//    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    enterButton.titleLabel.textAlignment = NSTextAlignmentRight;
//    [enterButton setTitle:NSLocalizedString(@"确认",nil) forState:UIControlStateNormal];
//    enterButton.frame = CGRectMake(0, 0, 60, 44);
//    [enterButton setTintColor:[UIColor whiteColor]];
//    enterButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [enterButton addTarget:self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:enterButton];
//    [self.navigationItem addRightBarButtonItem:rightBarButton];
//    [rightBarButton release];
    
}

- (void)uiConfig{
    _tf_realName.placeholder = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"姓名",nil)];
    _tf_telephoneNumber .placeholder = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"电话",nil)];
    _tf_telephoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [_tf_telephoneNumber addTarget:self action:@selector(telephone_editing:) forControlEvents:UIControlEventEditingChanged];

    
    [_btn_enter setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]forState:UIControlStateNormal];
}
#pragma mark---
#pragma mark---判断输入的手机格式是否正确
- (void)telephone_editing:(OMTelephoneTextField *)telephone_textfield
{
     self.telephone_correct = telephone_textfield.text.isTelephone;

}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)enterClick:(id)sender {
    
    
    if ([_tf_realName.text isEqualToString:@""]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"姓名不能为空",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
    }else if ([_tf_telephoneNumber.text isEqualToString:@""]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"手机号码不能为空",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
    }else if(!self.isTelephoneCorrect){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"手机号码错误，请您输入正确的手机号",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
    }
    else {
        
        [_applyMemberInfo setValue:_tf_telephoneNumber.text forKey:@"telephone_number"];
        [_applyMemberInfo setValue:_tf_realName.text forKey:@"real_name"];
        
        [WowTalkWebServerIF applyEventWithEventId:_model.event_id withApplyMessage:@"" withMemberInfo:_applyMemberInfo withCallBack:nil withObserver:self];
        
//        [_delegate performSelector:@selector(applyEvent)];
        [self backAction];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
