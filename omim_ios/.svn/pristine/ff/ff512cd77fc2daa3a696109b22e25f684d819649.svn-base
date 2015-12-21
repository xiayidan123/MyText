//
//  OMBaseDatePickerCell.m
//  dev01
//
//  Created by 杨彬 on 15/2/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBaseDatePickerCell.h"
#import "OMBaseCellFrameModel.h"
#import "OMBaseDatePickerView.h"


@interface OMBaseDatePickerCell ()<OMBaseDatePickerViewDelegate>
/**
 *  label部分
 */
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *title_label;
@property (retain, nonatomic) IBOutlet UILabel *content_label;

@property (retain, nonatomic) OMBaseDatePickerView *datePickerView;


@property (assign, nonatomic) CGFloat originalOffset;

//@property (assign, nonatomic) BOOL isOpen;


@property (retain, nonatomic) IBOutlet NSLayoutConstraint *dateTrailing;

@end

@implementation OMBaseDatePickerCell

- (void)dealloc {
    self.content_color = nil;
    [_cellFrameModel release],_cellFrameModel = nil;
    
    [_datePickerView release],_datePickerView = nil;
    
    [_superTableView release];
    
    [_title_label release];
    [_content_label release];
    [_bgView release];
    [_dateTrailing release];
    [super dealloc];
}


- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgView.userInteractionEnabled = YES;
    self.layer.masksToBounds = YES;
    [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction:)]];
}

-(void)setCellFrameModel:(OMBaseCellFrameModel *)cellFrameModel{
    [_cellFrameModel release],_cellFrameModel = nil;
    _cellFrameModel = [cellFrameModel retain];
    self.title_label.text = _cellFrameModel.cellModel.title;
    self.content_label.text = _cellFrameModel.cellModel.content;
    
    if (_cellFrameModel.isOpen && (_cellFrameModel.cellModel.type == OMBaseCellModelTypeDatePicker || _cellFrameModel.cellModel.type == OMBaseCellModelTypeTimePicker || _cellFrameModel.cellModel.type == OMBaseCellModelTypeCountDownTimer)){
        [self loadDatePickerView];
    }else{
        [self.datePickerView removeFromSuperview];
        [self.datePickerView release],self.datePickerView = nil;
    }
    
    if (_cellFrameModel.canEdit){
        self.title_label.textColor = [UIColor blackColor];
        self.content_label.textColor = [UIColor blackColor];
    }else{
        self.title_label.textColor = [UIColor lightGrayColor];
        self.content_label.textColor = [UIColor lightGrayColor];
    }
    
}


-(void)setContent_color:(UIColor *)content_color{
    [_content_color release],_content_color = nil;
    
    _content_color = [content_color retain];
    
    self.content_label.textColor = _content_color;
}

- (void)loadDatePickerView{
    self.datePickerView = [OMBaseDatePickerView baseDatePickerViewWithFrame:CGRectMake(0, 24, self.contentView.bounds.size.width, 230)];
    self.datePickerView.cellFrameModel = self.cellFrameModel;
    self.datePickerView.delegate = self;
    switch (_cellFrameModel.cellModel.type) {
        case OMBaseCellModelTypeDatePicker:{
            self.datePickerView.type = OMBaseDatePickerViewTypeDate;
        }break;
        case OMBaseCellModelTypeTimePicker:{
            self.datePickerView.type = OMBaseDatePickerViewTypeTime;
        }break;
        case OMBaseDatePickerViewTypeCountDownTimer:{
            self.datePickerView.type = OMBaseDatePickerViewTypeCountDownTimer;
        }break;
        default:
            self.datePickerView.type = OMBaseDatePickerViewTypeDefault;
            break;
    }

    [self.contentView addSubview:self.datePickerView];
    
    [self.contentView bringSubviewToFront:self.bgView];
}


-(void)drawRect:(CGRect)rect{
    if (_cellFrameModel.isOpen){
        
//        _originalOffset = self.superTableView.contentOffset.y;
//        CGFloat centerY = [self cellHeightInSuperView:self] + self.bounds.size.height/2;
//        CGFloat distanceToMiddle = centerY - self.superTableView.bounds.size.height / 2;
//        if (distanceToMiddle > 0 ){
//            [UIView animateWithDuration:0.15 animations:^{
//                self.superTableView.contentOffset = CGPointMake(self.superTableView.contentOffset.x, self.superTableView.contentOffset.y + distanceToMiddle);
//            }];
//        }
        
        [self.datePickerView showDatePickerWithAnimated:YES];
    }else{
//        [self.datePickerView hiddenDatePickerWithAnimated:YES];
    }
}


/**
 *  点击当前cell,做相应操作（收起或者展开）
 *
 *  @param tap
 */
- (void)selectAction:(UITapGestureRecognizer *)tap{
    if(self.cellFrameModel.canEdit == NO)return;
    self.cellFrameModel.isOpen = ! self.cellFrameModel.isOpen;
    if (!self.cellFrameModel.isOpen){
//        [UIView animateWithDuration:0.15 animations:^{
//            self.superTableView.contentOffset = CGPointMake(self.superTableView.contentOffset.x, _originalOffset);
//            _originalOffset = 0;
//        }];
        
        [self.datePickerView hiddenDatePickerWithAnimated:YES withCompletion:^{
            if ([self.delegate respondsToSelector:@selector(baseDatePickerCell:hiddenWithModel:)]){
                [self.delegate baseDatePickerCell:self hiddenWithModel:self.cellFrameModel];
            }
            [self.datePickerView refreshModel];// 刷新model 获取用户修改的时间
            [self changeDate];
            [self.datePickerView removeFromSuperview];
//            [self.datePickerView release], self.datePickerView = nil;
        }];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(baseDatePickerCell:hiddenWithModel:)]){
        [self.delegate baseDatePickerCell:self hiddenWithModel:self.cellFrameModel];
    }
}

-(void)setIsSettingVCInit:(BOOL)isSettingVCInit{
    _isSettingVCInit = isSettingVCInit;
    if (_isSettingVCInit){
        self.dateTrailing.constant = 0;
        self.title_label.textColor = [UIColor blackColor];
        self.title_label.font = [UIFont systemFontOfSize:14];
        self.content_label.font = [UIFont systemFontOfSize:14];
        self.content_label.textAlignment = NSTextAlignmentRight;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        self.dateTrailing = 15;
        self.content_label.textAlignment = NSTextAlignmentLeft;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}


+ (OMBaseDatePickerCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"OMBaseDatePickerCellID";
    OMBaseDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OMBaseDatePickerCell" owner:nil options:nil] lastObject];
    }
    cell.superTableView = tableView;
    return cell;
}

/**
 *  点击确定或者bgView以后，给代理传递信息，时间有修改。让代理类自己判断是否修改
 */
- (void)changeDate{
    self.cellFrameModel.cellModel.old_content = self.content_label.text;
    
    self.content_label.text = self.cellFrameModel.cellModel.content;// 刷新时间Label显示
    if ([self.delegate respondsToSelector:@selector(baseDatePickerCell:changeDateWithModel:)]){
        [self.delegate baseDatePickerCell:self changeDateWithModel:self.cellFrameModel];
    }
}


/**
 *  计算cell在VC中的位置
 *
 *  @param subView
 *
 *  @return 高度
 */
- (CGFloat)cellHeightInSuperView:(UIView *)subView {
    CGFloat height = 0;
    UIView * superView = [subView superview];
    CGFloat offsetY = 0;
    if ([subView isKindOfClass:[UIScrollView class]]){
        offsetY = ((UIScrollView *)subView).contentOffset.y;
    }
    if (superView == self.superTableView) {
        return height - offsetY;
    }else{
        CGFloat subHeight = [self cellHeightInSuperView:superView];
        height += subView.frame.origin.y - offsetY + subHeight;
    }
    return height;
}


#pragma mark - OMBaseDatePickerViewDelegate

/**
 *  点击OMBaseDatePickerView 确定的按钮代理方法
 *
 *  @param baseDatePickerView
 *  @param cellFrameModel    修改过后的cellFrameModel
 */
-(void)baseDatePickerView:(OMBaseDatePickerView *)baseDatePickerView enterClick:(OMBaseCellFrameModel *)cellFrameModel{
    [self selectAction:nil];
//    [self changeDate];
}


@end
