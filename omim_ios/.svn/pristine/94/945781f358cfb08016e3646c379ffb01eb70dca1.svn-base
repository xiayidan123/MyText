//
//  MomentTypeView.m
//  wowtalkbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "MomentTypeView.h"
#import "BizNewMomentViewController.h"
#import "Colors.h"

@implementation MomentTypeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        UIButton* btn_cancel = [[UIButton alloc] initWithFrame:self.frame];
        btn_cancel.backgroundColor = [UIColor clearColor];
        [btn_cancel addTarget:self action:@selector(cancelTheView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_cancel];
        [btn_cancel release];
        
        UITableView* tb_options = [[UITableView alloc] initWithFrame:CGRectMake(20, (self.frame.size.height - 44*4)/2, 280, 44*4)];
        tb_options.delegate = self;
        tb_options.dataSource = self;
        [tb_options setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tb_options setScrollEnabled:FALSE];
        
        [self addSubview:tb_options];
        [tb_options release];
        
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)cancelTheView
{
    [self removeFromSuperview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tag = indexPath.row;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMomentType:)]) {
        [self.delegate didSelectMomentType:tag];
    }
    
    [self removeFromSuperview];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"momenttypecell"];
    
    if (cell == Nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momenttypecell"] autorelease];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel* lbl_type = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
        lbl_type.backgroundColor = [UIColor clearColor];
        lbl_type.font = [UIFont systemFontOfSize:17];
        lbl_type.textAlignment = NSTextAlignmentCenter;
        lbl_type.textColor = [UIColor blackColor];
        lbl_type.tag = 1;
        [cell.contentView addSubview:lbl_type];
        [lbl_type release];
        
        UIView* uv_divider = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 280, 1)];
        uv_divider.tag = 3;
        uv_divider.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:uv_divider];
        [uv_divider release];
        
        
        UIView* uv_color = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 44)];
        uv_color.tag = 2;
        [cell.contentView addSubview:uv_color];
        [uv_color release];
    }
    
    
    UILabel* lbl_type = (UILabel*)[cell.contentView viewWithTag:1];
    UIView* uv_color = (UIView*)[cell.contentView viewWithTag:2];
    UIView* uv_divider = (UIView*)[cell.contentView viewWithTag:3];
    
    if (indexPath.row == 3) {
        [uv_divider setHidden:TRUE];
    }
    else
        [uv_divider setHidden:FALSE];
    
    if (indexPath.row == 0) {
        [uv_color setBackgroundColor:[Colors wowtalkbiz_blue]];
        lbl_type.text = NSLocalizedString(@"Current Status", Nil);
        
    }
    else  if (indexPath.row == 1) {
        [uv_color setBackgroundColor:[Colors wowtalkbiz_orange]];
        lbl_type.text = NSLocalizedString(@"Q&A", Nil);
        
    }
    else  if (indexPath.row == 2) {
        [uv_color setBackgroundColor:[Colors wowtalkbiz_red]];
        lbl_type.text = NSLocalizedString(@"Sharing", Nil);
        
    }
    else  if (indexPath.row == 3) {
        [uv_color setBackgroundColor:[Colors wowtalkbiz_green]];
        lbl_type.text = NSLocalizedString(@"Survey", Nil);
        
    }
    
    return cell;
    
}



@end
