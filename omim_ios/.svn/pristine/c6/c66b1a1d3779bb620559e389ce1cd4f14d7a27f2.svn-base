//
//  ClassMessageViewController.m
//  dev01
//
//  Created by mac on 14/12/26.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ClassMessageViewController.h"

@interface ClassMessageViewController ()

@end

@implementation ClassMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigation];
}
-(void)configNavigation
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"班级信息",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 44);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"保存" forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 40, 44);
    button1.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [button1 addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = item1;

}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(textWithTerm:andGrade:andSubject:andDate:andTime:andPlace:)]){
        [_delegate textWithTerm:self.term.text  andGrade:self.grade.text andSubject:self.subject.text  andDate:self.date.text andTime:self.time.text andPlace:self.place.text];
    }
    
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [_term release];
    [_grade release];
    [_subject release];
    [_date release];
    [_time release];
    [_place release];
    [super dealloc];
}
@end
