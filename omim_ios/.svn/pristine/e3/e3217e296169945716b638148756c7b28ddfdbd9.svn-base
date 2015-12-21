//
//  AddClassBulletinVC.m
//  dev01
//
//  Created by 杨彬 on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "AddClassBulletinVC.h"

#import "PulldownMenuView.h"
#import "UIPlaceHolderTextView.h"

#import "OMClass.h"
#import "Anonymous_Moment.h"

#import "OMDateBase_MyClass.h"
#import "OMNetWork_MyClass.h"

@interface AddClassBulletinVC ()<PulldownMenuViewDelegate,UIAlertViewDelegate>

@property (retain, nonatomic)PulldownMenuView *pulldownMenuView;

@property (retain, nonatomic)NSMutableArray *items_array;

@property (retain, nonatomic) UIPlaceHolderTextView *input_text;

@property (assign, nonatomic)NSInteger class_index;

@property (retain, nonatomic)Anonymous_Moment *add_moment;

@end

@implementation AddClassBulletinVC


-(void)dealloc{
    self.add_moment = nil;
    self.class_model = nil;
    self.items_array = nil;
    self.pulldownMenuView = nil;
    self.class_array = nil;
    [_input_text release];
    [super dealloc];
}


-(void)setClass_array:(NSMutableArray *)class_array{
    [_class_array release],_class_array = nil;
    _class_array = [class_array retain];
    
    NSMutableArray *items_array = [[NSMutableArray alloc]init];
    for (int i=0; i<1; i++){
        Tag *tag = [[Tag alloc]init];
        tag.tagTitle =@[NSLocalizedString(@"班级",nil)][i];
        NSMutableArray *contentArray = [[NSMutableArray alloc]init];
        NSInteger count = _class_array.count;
        [contentArray addObject:@"全部"];
        for (int j=0; j<count; j++){
            OMClass *classModel = _class_array[j];
            [contentArray addObject:classModel.groupNameOriginal];
        }
        tag.contentArray = contentArray;
        [contentArray release];
        [items_array addObject:tag];
        [tag release];
    }
    self.items_array = items_array;
    [self loadPulldownMenuView];
    [items_array release];
}


-(void)viewDidAppear:(BOOL)animated{
    [self.input_text becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self uiConfig];
    
}

- (void)prepareData{
    self.class_index = 0;
    if (nil == self.class_model ){
       self.class_array = [OMDateBase_MyClass fetchAllClass];
    }
    
}


- (void)uiConfig{
    self.title = @"添加班级通知";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(enterAction)] autorelease];
    
    [self loadInputTextView];
}

- (void)enterAction{
    
    if (self.input_text.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"班级通知不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }else{
        UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:@"确认提交该班级通知吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
        [alertView show];
    }
}

- (void)loadInputTextView{
    self.input_text = [[[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 150)] autorelease];
    self.input_text.backgroundColor = [UIColor clearColor];
    self.input_text.textAlignment = NSTextAlignmentLeft;
    self.input_text.font = [UIFont systemFontOfSize:17];
    if (nil == self.class_model ){
        self.input_text.frame = CGRectMake(10, 128, self.input_text.frame.size.width, self.input_text.frame.size.height);
    }else{
        self.input_text.frame = CGRectMake(10, 84, self.input_text.frame.size.width, self.input_text.frame.size.height);
    }
    self.input_text.showClearButton = NO;
    UIView *input_bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.input_text.frame.size.height)];
    input_bgView.backgroundColor = [UIColor whiteColor];
    input_bgView.center = self.input_text.center;
    [self.view addSubview:input_bgView];
    [input_bgView release];
    
    [self.view addSubview:self.input_text];
    
    [self.view bringSubviewToFront:self.pulldownMenuView];
}

- (void)loadPulldownMenuView{
    self.pulldownMenuView = [[[NSBundle mainBundle] loadNibNamed:@"PulldownMenuView" owner:self options:nil] lastObject];
    [self.pulldownMenuView loadPulldownViewWithFram:CGRectMake(0, 64, self.view.bounds.size.width, 44) andCTagArry:self.items_array];
    self.pulldownMenuView.delegate = self;
    [self.view addSubview:self.pulldownMenuView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - NetWork CallBack
- (void)didAddMomentForClassBulletin:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.add_moment = [[notif userInfo] valueForKey:@"moment"];
        
        NSMutableArray *class_array = nil;
        
        if (nil != self.class_model){
            class_array = [[NSMutableArray alloc]init];
            [class_array addObject:self.class_model];
        }else{
            if (self.class_index != 0){
                class_array = [[NSMutableArray alloc]init];
                OMClass *class_model = self.class_array[self.class_index - 1];
                [class_array addObject:class_model];
            }else{
                class_array = [[NSMutableArray alloc]initWithArray:self.class_array];
            }
        }
        
        [OMNetWork_MyClass addClassBulletinWithClass_array:class_array moment_id:self.add_moment.moment_id WithCallBack:@selector(didAddClassBulletin:) withObserver:self];
        [class_array release];
    }
}


- (void)didAddClassBulletin:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if ([self.delegate respondsToSelector:@selector(addClassBulletinVC:moment:)]){
            [self.delegate addClassBulletinVC:self moment:self.add_moment];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - PulldownMenuViewDelegate
- (void)didSelecteWithState:(NSArray *)stateArray{
    self.class_index = [[stateArray firstObject] integerValue];
}

#pragma mark - UIAlertViewDelegate


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [OMNetWork_MyClass addMomentToClassBulletin:self.input_text.text withCallback:@selector(didAddMomentForClassBulletin:) withObserver:self];
    }
}



@end
