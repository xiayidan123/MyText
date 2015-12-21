//
//  LogoutButtonView.m
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LogoutButtonView.h"


@interface LogoutButtonView ()

@property (retain, nonatomic) IBOutlet UIButton *logoutButton;


@end

@implementation LogoutButtonView

- (void)dealloc {
    [_logoutButton release];
    [super dealloc];
}

+ (instancetype)logoutButtonView{
    LogoutButtonView *logoutButtonView = [[[NSBundle mainBundle]loadNibNamed:@"LogoutButtonView" owner:self options:nil] lastObject];
    [logoutButtonView.logoutButton setTitle:NSLocalizedString(@"退出登录",nil) forState:UIControlStateNormal];
    return logoutButtonView;
}


- (IBAction)logoutAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(logoutAppWithLogoutButtonView:)]){
        [self.delegate logoutAppWithLogoutButtonView:self];
    }
    
}
@end
