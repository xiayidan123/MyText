//
//  PopListView.m
//  omim
//
//  Created by Harry on 14-1-17.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "PopListView.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@implementation PopListView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOptions:(NSArray*)options
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        _options = [options copy];
        
        CGFloat tableHeight = 35 * [_options count] - 2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(POPLISTVIEW_BACKGROUDVIEW_ORINGE_X,
                                                                               POPLISTVIEW_BACKGROUDVIEW_ORINGE_Y,
                                                                               POPLISTVIEW_BACKGROUDVIEW_WIDTH,
                                                                               tableHeight + 25)];
        imageView.image = [[UIImage imageNamed:@"popup_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:40] ;
        [self addSubview:imageView];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(POPLISTVIEW_BACKGROUDVIEW_ORINGE_X+11,
                                                                   POPLISTVIEW_BACKGROUDVIEW_ORINGE_Y+17,
                                                                   POPLISTVIEW_BACKGROUDVIEW_WIDTH-22,
                                                                   tableHeight)];
        _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setScrollEnabled:NO];
        _tableView.layer.cornerRadius = 8;
        _tableView.layer.masksToBounds = YES;
        [self addSubview:_tableView];
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedTitleString"]) {
            seletedRow = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedTitleString"];
        }else{
            seletedRow = 0;
        }
        
    }
    return self;
    
}

- (void)setSelectedIndex:(NSInteger)anIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:anIndex forKey:@"SelectedTitleString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedTitleString"]) {
        seletedRow = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedTitleString"];
    } else {
        seletedRow = 0;
    }
}


#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)fadeOut
{
    [UIView animateWithDuration:0.35 animations:^{
//        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)view
{
    [view addSubview:self];
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    static NSString *cellIdentity = @"CustomCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity] autorelease];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setNumberOfLines:1];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.tag = 101;
        [label setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor grayColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 31, POPLISTVIEW_TABLEVIEW_WIDTH, 2)];
        [imageView setImage:[UIImage imageNamed:POPUP_DIVIDER_IAMGE]];
        
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:imageView];
        [label release];
        [imageView release];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    NSInteger row = [indexPath row];
    
    if (seletedRow == row) {
        [label setTextColor:[UIColor blackColor]];
    }
    
    UIFont *font = [UIFont boldSystemFontOfSize:16.0];
    CGSize size = CGSizeMake(170.0f,24.0f);
//    CGSize labelsize = [[_options objectAtIndex:row] sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
    
    NSDictionary *atttibutes=@{NSFontAttributeName:font};
    CGSize labelsize = [[_options objectAtIndex:row] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:atttibutes context:nil].size;
    
    
    [label setFrame:CGRectMake((POPLISTVIEW_TABLEVIEW_WIDTH - labelsize.width)/2, 5, labelsize.width, labelsize.height)];
    
    label.text = [_options objectAtIndex:row];
    
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // tell the delegate the selection
    if (self.delegate && [self.delegate respondsToSelector:@selector(popListView:didSelectedIndex:)]) {
        [self.delegate popListView:self didSelectedIndex:[indexPath row]];
    }
    
    // dismiss self
    [self fadeOut];
    
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"SelectedTitleString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - TouchTouchTouch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(popListViewDidCancel)]) {
        [self.delegate popListViewDidCancel];
    }
    
    // dismiss self
    [self fadeOut];
}

- (void)dealloc
{
    [_tableView release];
    [_options release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
