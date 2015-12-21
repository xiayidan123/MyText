//
//  MyClassFunctionCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MyClassFunctionCell.h"
#import "MyClassFunctionButtonCell.h"
#import "MyClassFunctionButtonModel.h"
#import "WTUserDefaults.h"

@interface MyClassFunctionCell ()<UICollectionViewDataSource,UICollectionViewDelegate>



@property (retain, nonatomic) IBOutlet UICollectionView *function_collectionView;

@property (retain, nonatomic) NSMutableArray *itemsArray;

@property (retain, nonatomic) IBOutlet UIButton *classCircle_btn;

@end


@implementation MyClassFunctionCell


- (void)dealloc {
    [_itemsArray release];
    
    [_function_collectionView release],_function_collectionView.delegate = nil,_function_collectionView.dataSource = nil,_function_collectionView = nil;
    [_classCircle_btn release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *MyClassFunctionCellid = @"MyClassFunctionCellid";
    MyClassFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClassFunctionCellid];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyClassFunctionCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self prepareData];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.contentView.bounds.size.width/3, 60);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.function_collectionView.collectionViewLayout = layout;
    
    [self.function_collectionView registerNib:[UINib nibWithNibName:@"MyClassFunctionButtonCell" bundle:nil] forCellWithReuseIdentifier:@"MyClassFunctionButtonCell"];
    
}


- (void)prepareData{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    for (int i=0; i<6; i++){
        MyClassFunctionButtonModel *model = [[MyClassFunctionButtonModel alloc]init];
        if ([[WTUserDefaults getUsertype] isEqualToString:@"1"]) {
            model.title = @[@"师生名单",@"班级通知",@"请假申请",@"申请补课",@"拍照答疑",@"在线作业"][i];
        }else{
            model.title = @[@"师生名单",@"班级通知",@"在线签到",@"申请补课",@"拍照答疑",@"在线作业"][i];
        }
        model.imageName = @[@"icon_myclass_list.png" ,@"icon_myclass_bell.png",@"icon_myclass_leave.png",@"icon_myclass_application.png",@"icon_myclass_camera.png",@"icon_myclass_homework.png"][i];
        model.imageName_pre = @[@"icon_myclass_list_press.png" ,@"icon_myclass_bell_press.png",@"icon_myclass_leave_press.png",@"icon_myclass_application_press.png",@"icon_myclass_camera_press.png",@"icon_myclass_homework_press.png"][i];
        [items addObject:model];
        [model release];
    }
    self.itemsArray = items;
    [items release];
}

- (void)awakeFromNib {
    
}


#pragma mark -
#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyClassFunctionButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyClassFunctionButtonCell" forIndexPath:indexPath];
    
    cell.buttonModel = self.itemsArray[indexPath.section * 3 + indexPath.row];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self classFunctionActionWithIndexPath:indexPath];
    
}

//-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor clearColor]];
//}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor colorWithRed:0.72 green:0.71 blue:0.71 alpha:1]];
//    return YES;
//}

#pragma mark - Button_Action
- (void)classFunctionActionWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                [self memberList];
            }break;
            case 1:{
                [self classNotification];
            }break;
            case 2:{
                [self leaveApply];
            }break;default:break;
        }
        
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                [self makeUpLessons];
            }break;
            case 1:{
                [self takePhotoForQuestions];
            }break;
            case 2:{
                [self homeWorkOnLine];
            }break;default:break;
        }
    }
}



/**
 *  师生名单
 */
- (void)memberList{
    if ([self.delegate respondsToSelector:@selector(clickMemberListButtonWithMyClassFunctionCell:)]){
        [self.delegate clickMemberListButtonWithMyClassFunctionCell:self];
    }
    
}

/**
 *  班级通知
 */
- (void)classNotification{
    if ([self.delegate respondsToSelector:@selector(clickClassNotificationButtonWithMyClassFunctionCell:)]){
        [self.delegate clickClassNotificationButtonWithMyClassFunctionCell:self];
    }
}

/**
 *  请假申请
 */
- (void)leaveApply{
    if ([self.delegate respondsToSelector:@selector(clickLeaveApplyButtonWithMyClassFunctionCell:)]){
        [self.delegate clickLeaveApplyButtonWithMyClassFunctionCell:self];
    }
}

/**
 *  申请补课
 */
- (void)makeUpLessons{
    if ([self.delegate respondsToSelector:@selector(clickMakeUpLessonsButtonWithMyClassFunctionCell:)]){
        [self.delegate clickMakeUpLessonsButtonWithMyClassFunctionCell:self];
    }
}

/**
 *  拍照答疑
 */
- (void)takePhotoForQuestions{
    if ([self.delegate respondsToSelector:@selector(clickTakePhotoForQuestionsButtonWithMyClassFunctionCell:)]){
        [self.delegate clickTakePhotoForQuestionsButtonWithMyClassFunctionCell:self];
    }
}

/**
 *  在线作业
 *
 */
-  (void)homeWorkOnLine{
    if ([self.delegate respondsToSelector:@selector(clickHomeWorkOnLineButtonWithMyClassFunctionCell:)]){
        [self.delegate clickHomeWorkOnLineButtonWithMyClassFunctionCell:self];
    }
}


/**
 *  班级圈
 */
- (IBAction)classCircleAction {
    if ([self.delegate respondsToSelector:@selector(clickclassCircleActionButtonWithMyClassFunctionCell:)]){
        [self.delegate clickclassCircleActionButtonWithMyClassFunctionCell:self];
    }
    
    
    
}


@end
