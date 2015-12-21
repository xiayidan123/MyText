//
//  GradeViewController.m
//  dev01
//
//  Created by Huan on 15/5/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  教室评分页

#import "GradeViewController.h"
#import "FiveStarView.h"
#import "CommentListVC.h"
#import "SchoolMember.h"
#import "OMNetWork_MyClass.h"
#import "MBProgressHUD.h"
#import "OMAlertViewForNet.h"
#import "AppDelegate.h"
#import "WowTalkWebServerIF.h"
#import "Buddy.h"
#import "OMMessageVC.h"
#import "WTUserDefaults.h"
#import "OMDateBase_MyClass.h"
#import "OMClass.h"
#import "Lesson.h"
@interface GradeViewController ()<FiveStarViewDelegate,CommentListVCDelegate,OMAlertViewForNetDelegate,UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *comment_textF;
@property (retain, nonatomic) NSMutableArray *gradeArray;
@property (retain, nonatomic) IBOutlet UIButton *comment_btn;
@property (retain, nonatomic) NSMutableDictionary * rankDic;
@property (retain, nonatomic) OMAlertViewForNet * alertViewForNet;
@property (copy, nonatomic) NSString * messageContent;
@property (retain, nonatomic) Buddy * buddy;
@property (copy, nonatomic) NSString * schoolName;
@property (retain, nonatomic) MBProgressHUD *hud;
@end

@implementation GradeViewController


- (void)dealloc {
    [_comment_textF release];
    [_comment_btn release];
    self.student = nil;
    self.gradeArray = nil;
    self.rankDic = nil;
    self.alertViewForNet = nil;
    self.messageContent = nil;
    self.hud = nil;
    self.buddy = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
    [self loadData];
}

- (NSMutableArray *)gradeArray{
    if (!_gradeArray) {
        NSArray *array = @[@"完整性",@"及时性",@"准确性"];
        _gradeArray = [[NSMutableArray alloc] initWithArray:array];
    }
    return _gradeArray;
}
- (NSDictionary *)rankDic{
    if (!_rankDic) {
        _rankDic = [[NSMutableDictionary alloc] init];
        
    }
    return _rankDic;
}
- (NSString *)schoolName{
    if (!_schoolName) {
        SchoolMember *schoolMem = [OMDateBase_MyClass fetchClassMemberByClass_id:self.lessonmodel.class_id andMember_id:[WTUserDefaults getUid]];
        _schoolName = [[NSString alloc] init];
        _schoolName = schoolMem.alias;
    }
    return _schoolName;
}
- (void)uiConfig{
    self.title = @"评分";
    self.comment_textF.delegate = self;
    [self.comment_textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    for (int i = 0; i < 3; i++) {
        FiveStarView *view = [[FiveStarView alloc] initWithFrame:CGRectMake(0, 84 + 44 * i, self.view.bounds.size.width, 44)];
        view.tag = i + 300;
        view.delegate = self;
        [self.view addSubview:view];
    }
    
    UIImage *cannotImg = [UIImage imageNamed:@"btn_small_valid"];
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.comment_btn setBackgroundImage:[cannotImg resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.comment_btn setTitleColor:[UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f] forState:UIControlStateNormal];
}

- (void)send{
    
    if (self.rankDic[@"rank1"] && self.rankDic[@"rank2"] && self.rankDic[@"rank3"] && self.comment_textF.text.length) {
        [OMNetWork_MyClass addHomeworkReviewWithHomeworkResultID:self.student.homework_result_id withRankDic:self.rankDic WithContent:self.comment_textF.text withCallBack:@selector(didAddReView:) withObserver:self];
        self.alertViewForNet = [OMAlertViewForNet OMAlertViewForNet];
        self.alertViewForNet.type = OMAlertViewForNetStatus_Loading;
        self.alertViewForNet.title = @"正在提交";
        self.alertViewForNet.delegate = self;
        [self.alertViewForNet show];
    }else{
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"请填写完整信息" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil] autorelease];
        [alertView show];
    }
    
    
}


- (void)loadData{
    
}
/** 评语模板 */
- (IBAction)commentTemplate:(id)sender {
    CommentListVC *commentListVC = [[[CommentListVC alloc] init] autorelease];
    commentListVC.delegate = self;
    [self.navigationController pushViewController:commentListVC animated:YES];
}

#pragma mark FiveStarViewDelegate
- (void)fiveStarViewTag:(NSInteger)tag andValue:(float)value{
    if (tag == 300) {
        [self.rankDic setValue:[NSString stringWithFormat:@"%d",(int)(value * 10)] forKey:@"rank1"];
//        self.rankDic
    }else if (tag == 301){
        [self.rankDic setValue:[NSString stringWithFormat:@"%d",(int)(value * 10)] forKey:@"rank2"];
    }else if (tag == 302){
        [self.rankDic setValue:[NSString stringWithFormat:@"%d",(int)(value * 10)] forKey:@"rank3"];
    }
}


#pragma mark - CommentListVCDelegate

- (void)getCommentContent:(NSString *)comment{
    self.comment_textF.text = comment;
}

- (void)didAddReView:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        HomeworkReviewModel *homework_review_model = [[notif userInfo] objectForKey:@"fileName"];
        
        if ([self.delegate respondsToSelector:@selector(GradeViewController:didUploadReview:)]){
            [self.delegate GradeViewController:self didUploadReview:homework_review_model];
        }
        self.messageContent = [NSString stringWithFormat:@"%@课%@班的%@老师，已经批改了你的作业，快去查看",self.lessonmodel.title,self.classmodel.groupNameOriginal,self.schoolName];
//        self.buddy = [Database buddyWithUserID:self.student.userID];
//        
//        if (self.buddy) {
//            [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:self.buddy withFirstChat:NO WithMessageContent:self.messageContent];
//            [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
//        }
//        else{
            [WowTalkWebServerIF getBuddyWithUID:self.student.userID withCallback:@selector(didGetBuddyWithUID:) withObserver:self];
//        }
        self.alertViewForNet.type = OMAlertViewForNetStatus_Done;
        self.alertViewForNet.title = @"提交成功";
    }
//    else{
//        self.alertViewForNet.type = OMAlertViewForNetStatus_Failure;
//        self.alertViewForNet.title = @"提交失败";
//    }
}


- (void)didGetBuddyWithUID:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.buddy = [Database buddyWithUserID:self.student.userID];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:self.buddy withFirstChat:NO WithNoPushMessageContent:self.messageContent];
 
    }
}

#pragma mark - OMAlertViewForNetDelegate
- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{

//    if (alertViewForNet.type == OMAlertViewForNetStatus_Done){
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - UITextfieldDelegate
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect frame = textField.frame;
    NSLog(@"%f",textField.frame.origin.y);
//    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -100, self.view.frame.size.width, self.view.frame.size.height);//先写死吧，垃圾代码以后再改
    
    [UIView commitAnimations];
}
//限制此textfield字数最大为20。
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.comment_textF) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
            self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"输入超过20字";
            [self.hud hide:YES afterDelay:1];
        }
    }
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.comment_textF resignFirstResponder];
}

- (Buddy *)buddy{
    if (!_buddy) {
        _buddy = [[Buddy alloc] init];
    }
    return _buddy;
}


@end
