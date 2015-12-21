//
//  PulldownMenuView.m
//  dev01
//
//  Created by 杨彬 on 14-10-20.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "PulldownMenuView.h"

@implementation Tag


-(void)dealloc{
    self.tagTitle = nil;
    self.contentArray = nil;
    [super dealloc];
}


@end



@interface PulldownMenuView ()

@property (retain, nonatomic) IBOutlet UIView *bgview_markBtn;
@property (retain, nonatomic) IBOutlet UIView *maskBgView;



@property (retain, nonatomic)NSMutableArray *tagArray;
@property (retain, nonatomic)UITableView *tableView;
@property (retain, nonatomic)NSMutableArray *stateArray;

@property (assign, nonatomic)BOOL isMoving;
@property (assign, nonatomic)BOOL isShow;
@property (assign, nonatomic)NSInteger selectedIndex;

@property (retain, nonatomic) UIButton * activating_button;

@end

@implementation PulldownMenuView
{
    CGFloat _w;
    CGFloat _h;
}

-(void)dealloc{
    self.tagArray = nil;
    self.tableView = nil;
    self.stateArray = nil;
    
    [_bgview_markBtn release];
    [_maskBgView release];
    [super dealloc];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.tableView = [[[UITableView alloc]init] autorelease];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        _maskBgView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)maskBgViewClick{
    [self hideBranchMenu];
}

- (void)loadPulldownViewWithFram:(CGRect)frame andCTagArry:(NSArray *)tagArray{
    self.frame = frame;
    self.tagArray = [[[NSMutableArray alloc]initWithArray:tagArray] autorelease];
    _w = self.frame.size.width / _tagArray.count;
    _h = self.frame.size.height;
    _tableView.frame = CGRectMake(0, frame.size.height, frame.size.width, 0);
    self.stateArray = [[[NSMutableArray alloc]init] autorelease];
    
    for (int i=0; i<_tagArray.count; i++){
        [self.stateArray addObject:@(0)];
    }
    
    [self loadDividingLineWithContentArray];
    
    [self loadBranchMenuWithContentArray];
    
    [_maskBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskBgViewClick)]];
}


- (void)loadDividingLineWithContentArray{
    for (int i=0 ; i<_tagArray.count - 1; i++){
        UIView *dividingLine = [[UIView alloc]initWithFrame:CGRectMake(_w*(i + 1), 5, 0.5, _h - 10)];
        dividingLine.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1];
        [self addSubview:dividingLine];
        [dividingLine release];
    }
}

- (void)loadBranchMenuWithContentArray{
    for (int i=0; i<_tagArray.count;i++){
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        markBtn.frame = CGRectMake(_w * i, 0, _w, _h);
        [markBtn setTitle:[_tagArray[i] tagTitle] forState:UIControlStateNormal];
        markBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [markBtn setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
        [markBtn setTitleColor:[UIColor colorWithRed:0 green:198.0/255 blue:48.0/255 alpha:1] forState:UIControlStateSelected];
        
        [markBtn setImage:[UIImage imageNamed:@"share_category_icon_triangle_0"] forState:UIControlStateNormal];
        [markBtn setImage:[UIImage imageNamed:@"share_category_icon_triangle_1"] forState:UIControlStateSelected];
        markBtn.imageEdgeInsets = UIEdgeInsetsMake(markBtn.frame.size.height/2 - 1.5,  markBtn.frame.size.width / 5 * 4 - 3.5, markBtn.frame.size.height/2 - 1.5, markBtn.frame.size.width / 5 - 3.5 );
        markBtn.showsTouchWhenHighlighted = YES;
        
        markBtn.tag = i;
        [markBtn addTarget:self action:@selector(markBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgview_markBtn addSubview:markBtn];
    }
}


- (void)markBtnClick:(UIButton *)btn{
    _selectedIndex = btn.tag;
    
    
    if (btn.selected == YES){
        btn.selected = NO;
        self.activating_button = nil;
        [self hideBranchMenu];
    }else{
        for (UIView *view in _bgview_markBtn.subviews){
            if ([view isKindOfClass:[UIButton class]]){
                ((UIButton *)view).selected = NO;
            }
        }
        self.activating_button = btn;
        btn.selected = YES;
        [self showBranchMenu];
    }
}


- (void)action{
    if (_isMoving){
        return;
    }
    _isShow ? [self hideBranchMenu] : [self showBranchMenu] ;
}


- (void)hideBranchMenu{
    _isMoving = YES;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _bgview_markBtn.frame.size.height);
    _maskBgView.frame = _bgview_markBtn.frame;
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, 44, _tableView.frame.size.width, 0);
    }completion:^(BOOL finished) {
        for (UIView *view in _bgview_markBtn.subviews){
            if ([view isKindOfClass:[UIButton class]]){
                ((UIButton *)view).selected = NO;
            }
        }
        _isMoving = NO;
        _isShow = NO;
    }];
}

- (void)fastHideBranchMenu{
    _isMoving = NO;
    _isShow = NO;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _bgview_markBtn.frame.size.height);
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, 44, _tableView.frame.size.width, 0);
    _maskBgView.frame = _bgview_markBtn.frame;
    for (UIView *view in _bgview_markBtn.subviews){
        if ([view isKindOfClass:[UIButton class]]){
            ((UIButton *)view).selected = NO;
        }
    }
}

- (void)showBranchMenu{
    _isMoving = YES;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y);
    _maskBgView.frame = CGRectMake(_maskBgView.frame.origin.x, _maskBgView.frame.origin.y, _maskBgView.frame.size.width, self.frame.size.height);
    CGFloat height_tableView = 44 * [[_tagArray[_selectedIndex] contentArray] count];
    if (height_tableView > [UIScreen mainScreen].bounds.size.height - 200){
        height_tableView = [UIScreen mainScreen].bounds.size.height - 200;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, 44, _tableView.frame.size.width, height_tableView);
    }completion:^(BOOL finished) {
        _isMoving = NO;
        _isShow = YES;
    }];
    [_tableView reloadData];
}



#pragma mark-----tableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid] autorelease];
    }
    for (UIView *subview in cell.contentView.subviews){
        [subview removeFromSuperview];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    cell.textLabel.text = [_tagArray[_selectedIndex] contentArray][indexPath.row];
    if ([self.stateArray[_selectedIndex] integerValue] == indexPath.row){
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 29, cell.frame.size.height/2 - 5.5, 13, 11)];
        imgv.image = [UIImage imageNamed:@"share_category_select"];
        imgv.tag = 2000;
        [cell.contentView addSubview:imgv];
        [imgv release];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.stateArray[_selectedIndex] = [NSNumber numberWithInteger:indexPath.row];
    [self hideBranchMenu];
    
    for (UITableViewCell *cell in [tableView visibleCells]){
        for (UIView *view in cell.contentView.subviews){
            if (view.tag == 2000){
                [view removeFromSuperview];
            }
        }
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 29, cell.frame.size.height/2 - 5.5, 13, 11)];
    imgv.image = [UIImage imageNamed:@"share_category_select"];
    [cell.contentView addSubview:imgv];
    [imgv release];
    
    NSString *item_string = [_tagArray[_selectedIndex] contentArray][indexPath.row];
    
    [self.activating_button setTitle:item_string forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelecteWithState:)]){
        [_delegate didSelecteWithState:self.stateArray];
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 30;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_tagArray[_selectedIndex] contentArray] count];
}









@end
