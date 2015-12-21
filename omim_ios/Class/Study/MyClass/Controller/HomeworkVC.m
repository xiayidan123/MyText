//
//  HomeworkVC.m
//  dev01
//
//  Created by 杨彬 on 14-12-31.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "HomeworkVC.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "WTUserDefaults.h"
#import "AddClasstimetableCell.h"
#import "WTHeader.h"


@interface HomeworkVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BOOL _userTypeIsTeacher;
}

@property (retain, nonatomic)UITableView *homeworkTableView;

@property (retain, nonatomic)NSMutableArray *homeworkArray;

@property (retain, nonatomic)UIAlertView *addAlerView;

@property (assign, nonatomic)BOOL userTypeIsTeacher;


@end

@implementation HomeworkVC


-(void)dealloc{
    self.addAlerView = nil;
    self.lessonModel = nil;
    self.homeworkArray = nil;
    self.homeworkTableView = nil;

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setPermission];
    
    [self configNavigation];
    
    [self prepareData];
    
    [self uiConfig];
}

- (void)setPermission{
    if([[WTUserDefaults getUsertype] isEqualToString:@"2"]){
       self.userTypeIsTeacher = YES;
    }
}


- (void)configNavigation{
    
    self.title = NSLocalizedString(@"布置作业", nil);
    
//    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
//    [self.navigationItem addLeftBarButtonItem:backBarButton];
//    [backBarButton release];
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareData{
    [self loadData];
}


- (void)loadData{
    self.homeworkArray = [Database fetchHomeworkWithLessonID:self.lessonModel.lesson_id];
    
    
    [WowTalkWebServerIF getLessonHomeworkWithLessonId:self.lessonModel.lesson_id withCallback:@selector(didGetLessonHomework:) withObserver:self];
}

- (void)didGetLessonHomework:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.homeworkArray = [Database fetchHomeworkWithLessonID:self.lessonModel.lesson_id];
        [_homeworkTableView reloadData];
    }
}

- (void)uiConfig{
    self.homeworkTableView = [[[UITableView alloc]initWithFrame:self.view.bounds] autorelease];
    self.homeworkTableView.delegate = self;
    self.homeworkTableView.dataSource = self;
    self.homeworkTableView.tableFooterView = [[[UIView alloc]init] autorelease];
    [self.view addSubview:_homeworkTableView];
}



#pragma mark - UITableViewDelegate


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_homeworkArray.count == indexPath.row){
        static NSString *AddClasstimetableCellID = @"AddClasstimetableCellID";
        AddClasstimetableCell *addClasstimetableCell = [tableView dequeueReusableCellWithIdentifier:AddClasstimetableCellID];
        if (!addClasstimetableCell){
            addClasstimetableCell = [[[NSBundle mainBundle]loadNibNamed:@"AddClasstimetableCell" owner:self options:nil] firstObject];
            
        }
        addClasstimetableCell.text_context = @"添加作业";
//        addClasstimetableCell.lab_add.text = NSLocalizedString(@"增加练习", nil);
        return addClasstimetableCell;
    }
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text  =[NSString stringWithFormat:@"%ld.%@",indexPath.row + 1,[_homeworkArray[indexPath.row] title]];


    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _homeworkArray.count){
        _addAlerView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"添加作业", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确认", nil), nil];
        _addAlerView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [_addAlerView show];
    }
    else{
        /*点击每个作业查看作业详情*/
        NSString *str = [_homeworkArray[indexPath.row] title];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"作业详情" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        [alter release];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userTypeIsTeacher ? (_homeworkArray.count + 1) : _homeworkArray.count ;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        UITextField *addAlerViewTF = [_addAlerView textFieldAtIndex:0];
        [WowTalkWebServerIF uploadLessonHomeworkWithLessonID:self.lessonModel.lesson_id withTitle:addAlerViewTF.text WithCallBack:@selector(didUploadLessonHomework:) withObserver:self];
    }
}


- (void)didUploadLessonHomework:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.homeworkArray = [Database fetchHomeworkWithLessonID:self.lessonModel.lesson_id];
        [_homeworkTableView reloadData];
    }
}




@end
