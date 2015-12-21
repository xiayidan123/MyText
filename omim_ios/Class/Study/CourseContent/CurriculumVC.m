//
//  CurriculumVC.m
//  dev01
//
//  Created by 杨彬 on 14-10-13.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "CurriculumVC.h"
#import "PublicFunctions.h"
#import "PointsofknowledgeVIew.h"
#import "KeyDifficultKnowledgeView.h"
#import "CommentView.h"
#import "InterlocutionView.h"
#import "AskQuestionVC.h"

@interface CurriculumVC ()
{
    SegmentBar *_segmentBar;
    UITableView *_tableView;
}

@end

@implementation CurriculumVC

-(void)dealloc{
    [_tableView release];
//    [_segmentBar release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self uiConfig];
    
    [self loadSegmentBar];
}
- (void)uiConfig{
    self.view.backgroundColor = [UIColor whiteColor];

    [self configNavigation];
    
    [self loadTableView];
}

- (void)configNavigation{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(_mainTitle,nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
    [backBarItem release];
    
    UIButton *askButton = [UIButton buttonWithType:UIButtonTypeSystem];
    askButton.frame = CGRectMake(0, 0, 50, 44);
    [askButton setTitle:NSLocalizedString(@"提问",nil) forState:UIControlStateNormal];
    [askButton setTintColor:[UIColor whiteColor]];
    askButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [askButton addTarget:self action:@selector(askClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:askButton];
    [self.navigationItem addRightBarButtonItem:rightBarButton];
    [rightBarButton release];
    
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)askClick{
    AskQuestionVC *askQuestionVC = [[AskQuestionVC alloc]init];
    [self.navigationController pushViewController:askQuestionVC animated:YES];
    [askQuestionVC release];
}



- (void)loadTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _tableView.layer.position = CGPointMake(self.view.bounds.size.width/ 2, self.view.bounds.size.height/2);
    _tableView.layer.transform = CATransform3DMakeRotation(-M_PI / 2, 0, 0, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.pagingEnabled = YES;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.frame = CGRectMake(0, 108, _tableView.frame.size.width , _tableView.frame.size.height- 108);
    _tableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_tableView];
}

- (void)loadSegmentBar{
    _segmentBar = [[SegmentBar alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44) andTitleNameArray:@[NSLocalizedString(@"知识点",nil),NSLocalizedString(@"重点难点",nil),NSLocalizedString(@"实录点评",nil),NSLocalizedString(@"问答",nil)]];
    _segmentBar.delegate = self;
    [self.view addSubview:_segmentBar];
}


#pragma mark-----tableView

-(UITableViewCell *)tableView :(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
         cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.view.bounds.size.height - 64 - _segmentBar.bounds.size.height, self.view.bounds.size.width);
        cell.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
   
    CGFloat _w = self.view.bounds.size.height - 108;
    CGFloat _h = self.view.bounds.size.width;
    switch (indexPath.row) {
        case 0:{
            PointsofknowledgeVIew *pointsofknowledgeView = [[PointsofknowledgeVIew alloc]initWithFrame:CGRectMake(_w/2 - _h/2, _h/2 - _w/2, _h, _w)];
            pointsofknowledgeView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            pointsofknowledgeView.layer.position = CGPointMake(_w / 2,_h / 2);
            pointsofknowledgeView.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);
            [cell.contentView addSubview:pointsofknowledgeView];
            [pointsofknowledgeView release];
            
        }break;
        case 1:{
            KeyDifficultKnowledgeView *keyDifficultKnowledgeView = [[KeyDifficultKnowledgeView alloc]initWithFrame:CGRectMake(_w/2 - _h/2, _h/2 - _w/2, _h, _w)];
            keyDifficultKnowledgeView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            keyDifficultKnowledgeView.layer.position = CGPointMake(_w / 2,_h / 2);
            keyDifficultKnowledgeView.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);
            [keyDifficultKnowledgeView adaptHeight];
            [cell.contentView addSubview:keyDifficultKnowledgeView];
            [keyDifficultKnowledgeView release];
        }break;
        case 2:{
            CommentView *commentView = [[CommentView alloc]initWithFrame:CGRectMake(_w/2 - _h/2, _h/2 - _w/2, _h, _w)];
            commentView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            commentView.layer.position = CGPointMake(_w / 2,_h / 2);
            commentView.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);
            [cell.contentView addSubview:commentView];
            [commentView release];
        }break;
        case 3:{
            InterlocutionView *interlocutionView = [[InterlocutionView alloc]initWithFrame:CGRectMake(_w/2 - _h/2, _h/2 - _w/2, _h, _w)];
            interlocutionView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            interlocutionView.layer.position = CGPointMake(_w / 2,_h / 2);
            interlocutionView.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);
            [cell.contentView addSubview:interlocutionView];
            [interlocutionView release];
        }break;
            
        default:
            break;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.bounds.size.width;
}


#pragma mark------scrollView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_segmentBar moveSlideBar:scrollView.contentOffset.y * _segmentBar.frame.size.width  / scrollView.contentSize.height];
}


#pragma mark--------segmentBarDelegate
- (void)moveContentWihtTagIndex:(NSInteger)tag{
    _tableView.contentOffset = CGPointMake(0,_tableView.frame.size.width * tag);
}

@end
