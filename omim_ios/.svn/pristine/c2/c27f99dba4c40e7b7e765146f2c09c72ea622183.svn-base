//
//  FavoriteGroupCell.m
//  dev01
//
//  Created by elvis on 2013/08/26.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "FavoriteGroupCell.h"
#import "Constants.h"
#import "WTHeader.h"

@implementation FavoriteGroupCell

@synthesize level = _level;
@synthesize department = _department;
@synthesize isPickedCell = _isPickedCell;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _arrow  = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 40, 40)];
        
        [_arrow setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [_arrow setImage:[UIImage imageNamed:GROUP_ARROW_RIGHT] forState:UIControlStateNormal];
        
        _arrow.alpha = 0;
        [_arrow addTarget:self action:@selector(showStarredGroups) forControlEvents:UIControlEventTouchUpInside];
        
        _selectToView = [[UIButton alloc] initWithFrame:CGRectMake(47, 2, 226, 40)];
        _selectToView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_selectToView addTarget:self action:@selector(selectGroup) forControlEvents:UIControlEventTouchUpInside];
        _selectToView.alpha = 0;
        
        _groupname = [[UILabel alloc] initWithFrame:CGRectMake(57, 2, 215, 40)];
        _groupname.text = @"business";
        _groupname.backgroundColor = [UIColor clearColor];
        _groupname.textColor = [UIColor whiteColor];
        _groupname.textAlignment = NSTextAlignmentLeft;
        _groupname.alpha = 0;
        
        
        _favirate = [[UIButton alloc] initWithFrame:CGRectMake(233, 2, 40, 40)];
        _favirate.backgroundColor = [UIColor clearColor];
        [_favirate setImage:[UIImage imageNamed:GROUP_BOOKMARK] forState:UIControlStateNormal];
        [_favirate addTarget:self action:@selector(favoriteGroup) forControlEvents:UIControlEventTouchUpInside];
        _favirate.alpha = 0;
        
        _level = -1; // to detect it is the first initial.
        
        _changeOrder =[[UIButton alloc] initWithFrame:CGRectMake(275, 2, 40, 40)];
        _changeOrder.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_changeOrder setImage:[UIImage imageNamed:GROUP_SORT] forState:UIControlStateNormal];
        [_changeOrder addTarget:self action:@selector(orderGroup) forControlEvents:UIControlEventTouchUpInside];
        
        _groupchat = [[UIButton alloc] initWithFrame:CGRectMake(275, 2, 40, 40)];
        _groupchat.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_groupchat setImage:[UIImage imageNamed:GROUP_SEND] forState:UIControlStateNormal];
        [_groupchat addTarget:self action:@selector(messageGroup) forControlEvents:UIControlEventTouchUpInside];
        _groupchat.alpha = 0;
        
        _selectionButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 2, 40, 40)];
        _selectionButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_selectionButton setImage:[UIImage imageNamed:@"group_select.png"] forState:UIControlStateNormal];
        [_selectionButton addTarget:self action:@selector(pickGroup) forControlEvents:UIControlEventTouchUpInside];
        _selectionButton.alpha = 0;

        
        [self addSubview:self.arrow];
        [self addSubview:self.selectToView];
        [self addSubview:self.groupname];
        [self addSubview:self.favirate];
        [self addSubview:self.changeOrder];
        [self addSubview:self.groupchat];
        [self addSubview:self.selectionButton];
        
        
        [_arrow release];
        [_selectToView release];
        [_groupname release];
        [_changeOrder release];
        [_groupchat release];
        [_favirate release];
        [_selectionButton release];
        
        
    }
    return self;
}


#pragma mark -- setter
-(void)setIsPickedCell:(BOOL)isPickedCell
{
    _isPickedCell = isPickedCell;
    if (isPickedCell) {
           [self.selectionButton setImage:[UIImage imageNamed:@"group_select_a.png"] forState:UIControlStateNormal];
           isPicked = TRUE;
    }
    else{
          [self.selectionButton setImage:[UIImage imageNamed:@"group_select.png"] forState:UIControlStateNormal];
           isPicked = FALSE;
    }
    
}

-(BOOL)isPickedCell{
    return _isPickedCell;
}

-(void)setDepartment:(Department *)department
{
    _groupname.text = department.groupNameLocal;
    _department = department;
    
    self.arrow.hidden = TRUE;
    [self.selectToView setFrame:CGRectMake(5, 2, self.selectToView.frame.size.width + 42, 40)];
    [self.groupname setFrame:CGRectMake(15, 2, self.groupname.frame.size.width+42, 40)];
   
    if([Database isDepartmentFavorited:department.groupID]){
        [self.favirate setImage:[UIImage imageNamed:GROUP_BOOKMARK_P] forState:UIControlStateNormal];
    }
    else
        [self.favirate setImage:[UIImage imageNamed:GROUP_BOOKMARK] forState:UIControlStateNormal];
    
}

-(void)setLevel:(int)celllevel
{
    if (_level == -1) {
        self.frame = CGRectMake(self.frame.origin.x +  celllevel* 40, self.frame.origin.y, 320 - celllevel*40, 44);
        [self.selectToView setFrame:CGRectMake(self.selectToView.frame.origin.x, self.selectToView.frame.origin.y, self.selectToView.frame.size.width - celllevel*40, 40)];
        [self.groupname setFrame:CGRectMake(self.groupname.frame.origin.x, self.groupname.frame.origin.y, self.groupname.frame.size.width - celllevel*40, 40)];
        [self.favirate setFrame:CGRectMake(self.favirate.frame.origin.x - celllevel*40, self.favirate.frame.origin.y, self.favirate.frame.size.width, 40)];
        [self.groupchat setFrame:CGRectMake(self.groupchat.frame.origin.x - celllevel*40, self.groupchat.frame.origin.y, self.groupchat.frame.size.width, 40)];
         [self.selectionButton setFrame:CGRectMake(self.selectionButton.frame.origin.x - celllevel*40, self.selectionButton.frame.origin.y, self.selectionButton.frame.size.width, 40)];
        
        [UIView animateWithDuration:0.0 animations:^{
            self.selectToView.alpha = 1;
            self.groupname.alpha = 1;
            self.arrow.alpha = 1;
            self.favirate.alpha = 1;
            if (self.isSelectionMode) {
                self.selectionButton.alpha = 1;
            }
            else
                self.groupchat.alpha = 1;
        }];
        _level = celllevel;
    }
    else{
        int diff = celllevel -_level;
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(self.frame.origin.x +  diff* 40, self.frame.origin.y, self.frame.size.width - diff*40, 44);
            [self.selectToView setFrame:CGRectMake(self.selectToView.frame.origin.x, self.selectToView.frame.origin.y, self.selectToView.frame.size.width - diff*40, 40)];
            [self.groupname setFrame:CGRectMake(self.groupname.frame.origin.x, self.groupname.frame.origin.y, self.groupname.frame.size.width- diff*40, 40)];
            [self.favirate setFrame:CGRectMake(self.favirate.frame.origin.x - diff*40, self.favirate.frame.origin.y, self.favirate.frame.size.width, self.favirate.frame.size.height)];
            [self.groupchat setFrame:CGRectMake(self.groupchat.frame.origin.x - diff*40, self.groupchat.frame.origin.y, self.groupchat.frame.size.width, self.groupchat.frame.size.height)];
            [self.selectionButton setFrame:CGRectMake(self.selectionButton.frame.origin.x - diff*40, self.selectionButton.frame.origin.y, self.selectionButton.frame.size.width, self.selectionButton.frame.size.height)];
        }];
        
        _level = celllevel;
    }
    
}
-(int)level
{
    return  _level;
}

#pragma mark -- action
-(void)showStarredGroups
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toggleInStarredGroups:)]) {
        [self.delegate toggleInStarredGroups:self];
    }
}

-(void)favoriteGroup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(favoriteInStarredGroups:)]) {
        [self.delegate favoriteInStarredGroups:self];
    }
    
}

-(void)messageGroup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageInStarredGroups:)]) {
        [self.delegate messageInStarredGroups:self];
    }
}

-(void)selectGroup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectInStarredGroups:)]) {
        [self.delegate selectInStarredGroups:self];
    }
}

-(void)orderGroup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeGroupOrderInStarredGroups:)]) {
        [self.delegate changeGroupOrderInStarredGroups:self];
    }
}

-(void)pickGroup
{
    if (isPicked) {
        isPicked = FALSE;
        _isPickedCell = FALSE;
        [self.selectionButton setImage:[UIImage imageNamed:@"group_select.png"] forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(unpickTheGroupInStarredGroup:)]) {
            [self.delegate unpickTheGroupInStarredGroup:self];
        }
    }
    else{
        [self.selectionButton setImage:[UIImage imageNamed:@"group_select_a.png"] forState:UIControlStateNormal];
        isPicked = TRUE;
        _isPickedCell = TRUE;
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickTheGroupInStarredGroup:)]) {
        [self.delegate pickTheGroupInStarredGroup:self];
    }
        
    }
    

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
