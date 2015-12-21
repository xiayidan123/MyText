//
//  GenderVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "GenderVC.h"
#import "PitchonCellModel.h"
#import "PitchonCell.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "WTUserDefaults.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"

@interface GenderVC ()<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *gender_tabelView;

@property (retain, nonatomic) NSMutableArray *itemsArray;

@property (assign, nonatomic) BOOL isNetWorking;

@property (assign, nonatomic) NSInteger genderType;

@end

@implementation GenderVC

- (void)dealloc {
    [_itemsArray release];
    [_gender_tabelView release],_gender_tabelView.dataSource = nil,_gender_tabelView.delegate = nil,_gender_tabelView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self uiConfig];
}


- (void)prepareData{
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    NSArray *titleArray = @[NSLocalizedString(@"男",nil)
                            ,NSLocalizedString(@"女",nil)
                            ,NSLocalizedString(@"保密",nil)];
    
    NSInteger count = titleArray.count;
    for (int i=0; i<count; i++){
        PitchonCellModel * model = [[PitchonCellModel alloc] init];
        model.title = titleArray[i];
        model.isPitchon = NO;
        [itemsArray addObject:model];
        [model release];
    }
    NSInteger genderIndteger = [WTUserDefaults getGender];
    PitchonCellModel * model = itemsArray[genderIndteger];
    if (genderIndteger >=0 && genderIndteger < 2){
       model.isPitchon = YES;
    }
    
    self.itemsArray = itemsArray;
    [itemsArray release];
}


- (void)uiConfig{
    
    [self configNav];
    
    self.gender_tabelView.tableFooterView = [[[UIView alloc]init] autorelease];
    
}


-(void)configNav
{
    self.title = @"性别";
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"取消",nil) style:UIBarButtonItemStylePlain target:self action:@selector(goBack)] autorelease];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PitchonCell *cell = [PitchonCell cellWithTableView:tableView];
    
    cell.pitchonCellModel = self.itemsArray[indexPath.row];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isNetWorking)return;
    
    PitchonCellModel * oldeModel = self.itemsArray[self.genderType];
    oldeModel.isPitchon = NO;
    self.genderType = indexPath.row;
    
    PitchonCellModel * newModel = self.itemsArray[self.genderType];
    newModel.isPitchon = YES;
    
    [self.gender_tabelView reloadData];
    
    self.isNetWorking = YES;
    [WowTalkWebServerIF updateMyProfileWithNickName:nil withStatus:nil withBirthday:nil withSex:[NSString stringWithFormat:@"%zi",indexPath.row] withArea:nil withCallback:@selector(genderChanged:) withObserver:self];
    
}

#pragma mark - NetWork CallBack
- (void)genderChanged:(NSNotification *)notification
{
    
    NSError *err = [[notification userInfo] valueForKey:WT_ERROR];
    
    if (err.code== NO_ERROR) {
        if ([self.delegate respondsToSelector:@selector(genderVC:didChangeGender:)]){
            [self.delegate genderVC:self didChangeGender:[NSString stringWithFormat:@"%zi",self.genderType]];
        }
        
        [self goBack];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to change gender", nil)  message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        self.isNetWorking = NO;
        
    }
    
}


@end