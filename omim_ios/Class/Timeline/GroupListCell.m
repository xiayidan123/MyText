//
//  GroupListCell.m
//  wowtalkbiz
//
//  Created by elvis on 2013/08/19.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "GroupListCell.h"
#import "Constants.h"
#import "WTHeader.h"
@implementation GroupListCell

@synthesize level = _level;
@synthesize isSelectionMode = _isSelectionMode;
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
        [_arrow addTarget:self action:@selector(toggleGroup) forControlEvents:UIControlEventTouchUpInside];
        _arrow.alpha = 0;
        
        _selectToView = [[UIButton alloc] initWithFrame:CGRectMake(47, 2, 226, 0)];
        _selectToView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_selectToView addTarget:self action:@selector(selectGroup) forControlEvents:UIControlEventTouchUpInside];
        _selectToView.alpha = 0;
        
        _groupname = [[UILabel alloc] initWithFrame:CGRectMake(57, 2, 215, 0)];
        _groupname.text = @"business";
        _groupname.backgroundColor = [UIColor clearColor];
        _groupname.textColor = [UIColor whiteColor];
        _groupname.textAlignment = NSTextAlignmentLeft;
        _groupname.alpha = 0;
        
        
        _favirate = [[UIButton alloc] initWithFrame:CGRectMake(233, 2, 40, 40)];
        _favirate.backgroundColor = [UIColor clearColor];
        [_favirate setImage:[UIImage imageNamed:GROUP_BOOKMARK] forState:UIControlStateNormal];
        [_favirate addTarget:self action:@selector(favirateGroup) forControlEvents:UIControlEventTouchUpInside];
        _favirate.alpha = 0;
        
        _level = -1; // to detect it is the first initial.
            
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
        [self addSubview:self.groupchat];
        [self addSubview:self.selectionButton];
        
        
        [_arrow release];
        [_selectToView release];
        [_groupname release];
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
    if (_isPickedCell) {
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
    if([department.groupNameLocal isEqualToString:@"all"]&& department.parent_id==nil){
        _groupname.text=NSLocalizedString(@"All Member", Nil);

    }
    

    
    
    _department = department;
    
    NSMutableArray* children = [Database getChildrenDepartmentsForDeparment:department.groupID];
    if (children== nil ||[children count] == 0) {
         self.arrow.hidden = TRUE;
        [self.selectToView setFrame:CGRectMake(5, 2, self.selectToView.frame.size.width + 42, 40)];
        [self.groupname setFrame:CGRectMake(15, 2, self.groupname.frame.size.width+42, 40)];
    }
    
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
        
        [UIView animateWithDuration:0.4 animations:^{
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
-(void)toggleGroup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toggleTheGroup:)]) {
        [self.delegate toggleTheGroup:self];
    }
}

-(void)favirateGroup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(favirateTheGroup:)]) {
        [self.delegate favirateTheGroup:self];
    }
    
}

-(void)messageGroup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageTheGroup:)]) {
        [self.delegate messageTheGroup:self];
    }
}

-(void)selectGroup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTheGroup:)]) {
        [self.delegate selectTheGroup:self];
    }
}

-(void)pickGroup
{
    if (isPicked) {
        [self.selectionButton setImage:[UIImage imageNamed:@"group_select.png"] forState:UIControlStateNormal];
        isPicked = FALSE;
        _isPickedCell = FALSE;
        if (self.delegate && [self.delegate respondsToSelector:@selector(unpickTheGroup:)]) {
            [self.delegate unpickTheGroup:self];
        }
    }
    else{
        [self.selectionButton setImage:[UIImage imageNamed:@"group_select_a.png"] forState:UIControlStateNormal];
        isPicked = TRUE;
        _isPickedCell = FALSE;
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickTheGroup:)]) {
            [self.delegate pickTheGroup:self];
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
