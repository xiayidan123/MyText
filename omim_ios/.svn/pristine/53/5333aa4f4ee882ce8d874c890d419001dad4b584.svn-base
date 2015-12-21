//
//  OMPulldownView.m
//  OMPulldownView
//
//  Created by Starmoon on 15/7/14.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "OMPulldownView.h"

#import "UIView+Extension.h"

#import "OMPulldownTitleButton.h"
#import "OMPulldownMenuView.h"

#import "OMPulldownItem.h"

#define OMPulldownScreenW ([UIScreen mainScreen].bounds.size.height)


@interface OMPulldownView ()<OMPulldownMenuViewDelegate>


/** 数据数组 */
@property (strong, nonatomic) NSMutableArray * items;


@property (strong, nonatomic) NSMutableArray * title_button_array;

/** 是否需要重新排序标签按钮 */
@property (assign, nonatomic) BOOL needLoadTitleButton;

/** 半透明遮盖背景 */
@property (weak, nonatomic) UIView * mark_view;

/** 是否展开 */
@property (assign, nonatomic) BOOL is_unfold;

@property (weak, nonatomic) OMPulldownMenuView * menu_view;

@property (weak, nonatomic) OMPulldownTitleButton * seleted_title_button;

@property (weak, nonatomic) UIImageView * titleBar_imageView;


@end


@implementation OMPulldownView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.titleBar_imageView.x = 0;
    self.titleBar_imageView.y = 0;
    self.titleBar_imageView.width = self.width;
    self.titleBar_imageView.height = Pulldown_TitleButton_Height;
    
    if (self.needLoadTitleButton){
        [self loadTitleButton];
        self.needLoadTitleButton = NO;
    }
}


- (void)loadTitleButton{
    
    NSUInteger count = self.items.count;
    
    CGFloat title_button_width = self.width / count;
    
    for (int i=0; i<count; i++){
        OMPulldownItem *item = self.items[i];
        NSUInteger title_button_count = self.title_button_array.count;
        
        OMPulldownTitleButton *title_button = nil;
        if (title_button_count >= i) {
            title_button = [[OMPulldownTitleButton alloc]init];
            [title_button addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.titleBar_imageView addSubview:title_button];
            [self.title_button_array addObject:title_button];
        }else{
            title_button = self.title_button_array[i];
        }
        
        title_button.width = title_button_width;
        title_button.height = Pulldown_TitleButton_Height;
        title_button.y = 0;
        title_button.x = title_button_width * i;
        
        title_button.item = item;
    }
}


- (void)titleButtonAction:(OMPulldownTitleButton *)title_button{
    
    title_button.selected = ! title_button.selected;
    
    if (title_button.selected){
        self.seleted_title_button = title_button;
        for (UIButton *button in self.title_button_array) {
            if (button != title_button) button.selected = NO;
        }
    }else{
        self.seleted_title_button = nil;
    }
    
    self.is_unfold = title_button.selected;
}


// 展开
- (void)unfoldMenu{
    CGRect rect = [self convertRect:self.bounds toView:nil];
    
    self.height = OMPulldownScreenW - rect.origin.y;
    self.mark_view.height = self.height - Pulldown_TitleButton_Height;
    
    self.menu_view.x = 0;
    self.menu_view.y = Pulldown_TitleButton_Height;
    self.menu_view.width = self.width;
    self.menu_view.backgroundColor = [UIColor whiteColor];
    
    OMPulldownItem *item = self.seleted_title_button.item;
    self.menu_view.items = item.subitems;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.menu_view.height = self.menu_view.unfold_height;
    }];
}

// 收起
- (void)packupMenu{
    [UIView animateWithDuration:0.25 animations:^{
        self.mark_view.backgroundColor = [UIColor clearColor];
        self.menu_view.height = 0;
        
    }completion:^(BOOL finished) {
        self.height = Pulldown_TitleButton_Height;
        self.mark_view.height = 0;
        self.mark_view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
}


- (void)fastPackupMenu{
    self.height = Pulldown_TitleButton_Height;
    self.mark_view.height = 0;
    self.mark_view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
}

- (void)clickMarkView:(UITapGestureRecognizer *)tap{
    [self titleButtonAction:self.seleted_title_button];
}

#pragma mark - OMPulldownMenuViewDelegate


- (void)menuView:(OMPulldownMenuView *)menuView didSeletedItemtIndexPath:(NSIndexPath *)indexPath{
    OMPulldownItem *item = self.seleted_title_button.item;
    
    NSIndexPath *item_indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:[self.items indexOfObject:item]];
    
    if ([self.delegate respondsToSelector:@selector(pulldown:didSeletedItem:atIndexPath:)]){
        [self.delegate pulldown:self didSeletedItem:item atIndexPath:item_indexPath];
    }
    if(self.item_top){
        OMPulldownSubItem *subItem = item.subitems[indexPath.row];
        [self.seleted_title_button setTitle:subItem.title forState:UIControlStateNormal];
    }
    [self clickMarkView:nil];
}


#pragma mark - Set and Get


-(void)setPlist_file_name:(NSString *)plist_file_name{
    _plist_file_name = plist_file_name;
     NSArray *dic_array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_plist_file_name ofType:@"plist"]];
    
    NSUInteger count = dic_array.count;
    
    for (int i=0; i<count; i++) {
        NSDictionary *item_dic = dic_array[i];
        
        OMPulldownItem *item = [OMPulldownItem itemWithDic:item_dic];
        [self.items addObject:item];
    }
    self.needLoadTitleButton = YES;
    [self setNeedsLayout];
}


-(void)setIs_unfold:(BOOL)is_unfold{
    _is_unfold = is_unfold;
    if (_is_unfold){
        [self unfoldMenu];
    }else{
        [self packupMenu];
    }
}


-(UIView *)mark_view{
    if (_mark_view == nil){
        UIView *mark_view = [[UIView alloc]init];
        mark_view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        mark_view.userInteractionEnabled = YES;
        [mark_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMarkView:)]];
        mark_view.x = 0;
        mark_view.y = Pulldown_TitleButton_Height;
        mark_view.width = self.width;
        [self addSubview:mark_view];
        _mark_view = mark_view;
    }
    return _mark_view;
}


-(OMPulldownMenuView *)menu_view{
    if (_menu_view == nil){
        OMPulldownMenuView *menu_view = [[OMPulldownMenuView alloc]init];
        menu_view.delegate = self;
        _menu_view.backgroundColor = [UIColor whiteColor];
        [self addSubview:menu_view];
        _menu_view = menu_view;
    }
    return _menu_view;
}


-(UIImageView *)titleBar_imageView{
    if (_titleBar_imageView == nil){
        UIImageView *titleBar_imageView = [[UIImageView alloc]init];
        titleBar_imageView.image = [[UIImage imageNamed:@"titlebar_background"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        titleBar_imageView.clipsToBounds = YES;
        titleBar_imageView.userInteractionEnabled = YES;
        [self addSubview:titleBar_imageView];
        _titleBar_imageView = titleBar_imageView;
    }
    return _titleBar_imageView;
}

-(NSMutableArray *)title_button_array{
    if (_title_button_array == nil){
        _title_button_array = [[NSMutableArray alloc]init];
    }
    return _title_button_array;
}


-(NSMutableArray *)items{
    if (_items == nil){
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}



-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:[UIColor clearColor]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}


@end
